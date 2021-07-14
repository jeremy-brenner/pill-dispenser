#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h> 
#include <ArduinoJson.h>
#include <uri/UriBraces.h>

#include "src/Motor/Motor.h"
#include "src/Lock/Lock.h"
#include "src/Scheduler/Scheduler.h"
#include "src/Button/Button.h"

#include "config.h"
#include "wifi.h"

ESP8266WebServer server(80);
Scheduler scheduler;
Lock lock;
Button button(BUTTON_PIN);
Motor pillMotor(PILL_PINS);

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  connectToWifi();
  
  scheduler.onDispense(dispensePill);
  scheduler.onUnlock( []() { lock.unlock(); } );
  
  button.onPress(buttonPress);
  
  if(DEBUG) {
    server.on("/lock", []() { lock.lock(); sendOk(); });           
    server.on("/unlock", []() { lock.unlock(); sendOk(); });           
    server.on("/toggleLock", []() { lock.toggleLock(); sendOk(); });           
    server.on("/nextPill", []() { dispensePill(); sendOk(); }); 
    server.on("/clearSchedule", []() { scheduler.scheduleUnlock(0); sendOk(); }); 
  }
  
  server.on(UriBraces("/scheduleUnlock/{}"), scheduleUnlock);    
       
  server.on("/status", sendStatus);

  server.onNotFound(sendNotFound);       
  server.begin();
  
  Serial.println("End setup");
  delay(1000);
}

void loop() {
  if(!scheduler.readyCheck()) {
    Serial.println("Ntp not ready, bailing");
    delay(1000);
    return;
  }
  
  scheduler.update();
  server.handleClient();
  button.update();
  
  delay(100);
}

void buttonPress() {
   if(!lock.isLocked()) {
      lock.lock(); 
      scheduler.scheduleUnlock(30*24);
    }else{
      scheduler.scheduleUnlock(1*24);
    }
}

void scheduleUnlock() {
  int hours = server.pathArg(0).toInt();
  if(hours >= 24) {
    scheduler.scheduleUnlock(hours);
    sendOk(); 
  } else {
    sendBadRequest();
  }
}

void dispensePill() {
  Serial.println("Dispensing");
  pillMotor.move(PILL_DEG);
}

void connectToWifi() {
  Serial.print("Configuring access point...");
  WiFi.mode(WIFI_STA);
  WiFi.hostname(WIFI_HOSTNAME);
  delay(1000);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void sendBadRequest() {
  server.send(400, "text/plain", "400: Bad Request"); 
} 

void sendNotFound() {
  server.send(404, "text/plain", "404: Not found"); 
}

void sendOk() {
  server.send(200, "text/plain", "OK"); 
}

String systemStatus() {
  StaticJsonDocument<200> doc;
  doc["isLocked"] = String(lock.isLocked());
  doc["minutesUntilUnlock"] = String(scheduler.minutesUntilUnlock());
  doc["timestamp"] = scheduler.getTimestamp();
  doc["debug"] = String(DEBUG);
  String status;
  serializeJson(doc, status);
  return status;
}

void sendStatus() {
  server.send(200, "text/plain", systemStatus()); 
}
