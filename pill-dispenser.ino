#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h> 
#include <ArduinoJson.h>
#include <uri/UriBraces.h>
#include <TimeLib.h>
#include <RTClib.h>

#include "src/Lock/Lock.h"
#include "src/Carousel/Carousel.h"
#include "src/Scheduler/Scheduler.h"
#include "src/TimeSync/TimeSync.h"

#include "config.h"
#include "wifi.h"

ESP8266WebServer server(80);
Scheduler scheduler;
Lock lock;
Carousel carousel;
RTC_DS3231 RTC;
TimeSync timeSync;

bool haveRTC;
bool haveWifi;

time_t time_provider()
{
    return RTC.now().unixtime();
}


void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  haveRTC = RTC.begin();
  if(!haveRTC){
    Serial.println("RTC not found");
  }else{
    Serial.println("RTC found");
  }

  setSyncProvider(time_provider);
  setSyncInterval(60);

  connectToWifi();
  
  scheduler.onDispense(doDispense);
  scheduler.onUnlock( []() { lock.unlock(); } );
  
//  button.onPress(buttonPress);
  
  if(DEBUG) {
    server.on("/unlock", []() { lock.unlock(); sendOk(); });           
    server.on("/toggleLock", []() { lock.toggleLock(); sendOk(); });           
    server.on("/dispensePill", []() { dispensePill(); sendOk(); }); 
    server.on("/doDispense", []() { doDispense(); sendOk(); }); 
    server.on("/clearSchedule", []() { scheduler.scheduleUnlock(0); sendOk(); }); 
  }
  
  server.on(UriBraces("/scheduleUnlock/{}"), scheduleUnlock);    
  server.on("/lock", []() { lock.lock(); sendOk(); });           
  server.on("/status", sendStatus);

  server.onNotFound(sendNotFound);       
  server.begin();
  
  scheduler.ready();
  Serial.println("End setup");
  delay(1000);
}

void loop() {
  checkWifi();
  timeSync.update(RTC);
  scheduler.update();
  server.handleClient();
  delay(100);
}

void buttonPress() {
   if(!lock.isLocked()) {
      lock.lock(); 
      scheduler.scheduleUnlock(30*MINUTES_IN_A_DAY);
    }
}

void scheduleUnlock() {
  int minutes = server.pathArg(0).toInt();
  if(minutes >= MINIMUM_UNLOCK_TIME) {
    scheduler.scheduleUnlock(minutes);
    sendOk(); 
  } else {
    sendBadRequest();
  }
}

void doDispense() {
  Serial.println("Dispensing");
  for (int i = 0; i < PILLS_PER_DAY; i++) { 
    dispensePill();
    delay(500);
  }
}

void dispensePill() {
  carousel.next();
}

void connectToWifi() {
  Serial.print("Configuring access point...");
  WiFi.mode(WIFI_AP_STA);
  delay(1000);
  IPAddress localIP(192,168,2,1);
  IPAddress gateway(192,168,2,0);
  IPAddress subnet(255,255,255,0);
  WiFi.softAPConfig(localIP, gateway, subnet);
  WiFi.softAP(AP_SSID, AP_PASS, AP_CHANNEL, AP_HIDDEN);  
  WiFi.hostname(WIFI_HOSTNAME);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

void checkWifi() {
  if (WiFi.status() == WL_CONNECTED && !haveWifi) {
    haveWifi=true;
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
  }
  if(WiFi.status() != WL_CONNECTED && haveWifi) {
    haveWifi=false;
    Serial.println("WiFi disconnected");
  }
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
  doc["unlockTime"] = String(scheduler.getUnlockTime());
  doc["currentTime"] = String(scheduler.getCurrentTime());
  doc["readyTime"] = String(scheduler.getReadyTime());
  doc["minimumUnlockTime"] = String(MINIMUM_UNLOCK_TIME);
  doc["debug"] = String(DEBUG);
  String status;
  serializeJson(doc, status);
  return status;
}

void sendStatus() {
  server.send(200, "text/plain", systemStatus()); 
}
