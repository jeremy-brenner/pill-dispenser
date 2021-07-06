#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>
#include "config.h"

WiFiUDP ntpUDP;

NTPClient timeClient(ntpUDP, TIME_OFFSET);
ESPFlash<int> dayDispensed("/dayDispensed");
ESPFlash<bool> isLocked("/locked");

int lastDD;
int lastButtonState = 0;

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  connectToWifi();

  timeClient.begin();  
  lastDD = dayDispensed.get();

  for (int p : HOLE_PINS) {
    pinMode(p, OUTPUT);
  }
 
  for (int p : LOCK_PINS) {
    pinMode(p, OUTPUT);
  }

  pinMode(buttonPin, INPUT);

  Serial.print("Hole steps: ");
  Serial.print(HOLE_STEPS);
  Serial.print(" Lock steps: ");
  Serial.println(LOCK_STEPS);
  Serial.println("End setup");
  Serial.println(isLocked.get());
  delay(1000);
}

void loop() {
  timeClient.update();
  
  if( !ntpReady() ){
    Serial.println("Ntp not ready, bailing");
    delay(1000);
    return;
  }
  
  int buttonState = digitalRead(buttonPin);
  if( buttonState != lastButtonState ) {
    lastButtonState = buttonState;
    if(buttonState == 0) {
      Serial.println("Button pressed"); 
      if(isLocked.get()) {
        Serial.println("unlocking"); 
        unlockBox();
        isLocked.set(false);
      } else {
        Serial.println("locking"); 
        lockBox();
        isLocked.set(true);
      }
    }
  }
  
  int currentDay = timeClient.getDay();
  int currentTime = timeClient.getHours() * 100 + timeClient.getMinutes();

  if(currentDay != lastDD && currentTime >= DISPENSE_TIME) {
    Serial.println("Dispensing");
    setDD(currentDay);
    nextPill();
  }

  delay(100);
}

void printDebugInfo(int currentDay, int currentTime) {
  Serial.print("currentDay: ");
  Serial.print(currentDay);
  Serial.print(" currentTime: ");
  Serial.print(currentTime);
  Serial.print(" lastDD: ");
  Serial.print(lastDD);
  Serial.print(" DISPENSE_TIME: ");
  Serial.println(DISPENSE_TIME);
}

void connectToWifi() {
  Serial.print("Configuring access point...");
  WiFi.mode(WIFI_STA);
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

bool ntpReady() {
  return timeClient.getEpochTime()-TIME_OFFSET > 1624000000 ;
}

void setDD(int dd) {
  dayDispensed.set(dd);
  lastDD = dd;
}

void moveMotor(const int pins[4], const int steps) {
  for(int s = 0;  s < steps; s++) {
    for(int p = 0;  p < 4; p++) {
      digitalWrite(pins[p], pinState(s,p));
    }
    delay(10);
  }
}

void nextPill() {
  moveMotor(HOLE_PINS,HOLE_STEPS);
}

void unlockBox() {
  moveMotor(UNLOCK_PINS,LOCK_STEPS);
}

void lockBox() {
  moveMotor(LOCK_PINS,LOCK_STEPS);
}

int pinState(int holeStep, int pin) {
  return holeStep % 4 == pin ? HIGH : LOW;
}
