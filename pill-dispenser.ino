#include <ESP8266WiFi.h>
#include <ESPFlash.h>

#include "src/Motor/Motor.h"
#include "src/Lock/Lock.h"
#include "src/Scheduler/Scheduler.h"
#include "src/WebServer/WebServer.h"
#include "src/Button/Button.h"

#include "config.h"
#include "wifi.h"

Scheduler scheduler;
WebServer webServer;
Lock lock;
Button button(BUTTON_PIN);
Motor pillMotor(PILL_PINS);

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  connectToWifi();

  button.onPress( []() { lock.toggleLock(); } );
  webServer.onToggleLock( []() { lock.toggleLock(); } );
  webServer.onLock( []() { lock.lock(); } );
  webServer.onUnlock( []() { lock.unlock(); } );
  webServer.onNextPill( []() { dispensePill(); } );
  scheduler.onDispense( []() { dispensePill(); } );
  
  Serial.println("End setup");
  delay(1000);
}

void loop() {
  bool ntpReady = scheduler.update();
  if(!ntpReady) {
    Serial.println("Ntp not ready, bailing");
    delay(1000);
    return;
  }
  
  scheduler.update();
  webServer.update();                    
  button.update();
  
  delay(100);
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
