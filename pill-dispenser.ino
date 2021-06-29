#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>
#include "config.h"

WiFiUDP ntpUDP;

NTPClient timeClient(ntpUDP, TIME_OFFSET);
ESPFlash<int> dayDispensed("/dayDispensed");
int lastDD;

int motorSteps = 2048;
int holeSteps = motorSteps/8;
 
int pins[4] = { 5, 4, 0, 2 };

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  connectToWifi();

  timeClient.begin();  
  lastDD = dayDispensed.get();

  for (int p : pins) {
    pinMode(p, OUTPUT);
  }
  
  Serial.println("End setup");
  delay(1000);
}

void loop() {
  timeClient.update();
  if( !ntpReady() ){
    Serial.println("Ntp not ready, bailing");
    Serial.println(timeClient.getEpochTime());
    delay(1000);
    return;
  }
  
  int currentDay = timeClient.getDay();
  int currentTime = timeClient.getHours() * 100 + timeClient.getMinutes();

  printDebugInfo(currentDay, currentTime); 

  if(currentDay != lastDD && currentTime >= DISPENSE_TIME) {
    Serial.println("Dispensing");
    setDD(currentDay);
    nextPill();
  }

  delay(5000);
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

void nextPill() {
  for(int s = 0;  s < holeSteps; s++) {
    for(int p = 0;  p < 4; p++) {
      digitalWrite(pins[p], pinState(s,p));
    }
    delay(10);
  }
}

int pinState(int holeStep, int pin) {
  return holeStep % 4 == pin ? HIGH : LOW;
}
