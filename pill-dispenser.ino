#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>
#include <uri/UriBraces.h>
#include <TimeLib.h>
#include <LittleFS.h>
#include <uri/UriRegex.h>

#include "src/Lock/Lock.h"
#include "src/Carousel/Carousel.h"
#include "src/Scheduler/Scheduler.h"
#include "src/StateStorage/StateStorage.h"
#include "src/TimeSync/TimeSync.h"

#include "config.h"
#include "wifi.h"

ESP8266WebServer server(80);
Carousel carousel;
TimeSync timeSync;
static bool fsOK;
FS* fileSystem = &LittleFS;
LittleFSConfig fileSystemConfig = LittleFSConfig();
StateStorage state(fileSystem);
Scheduler scheduler(&state);
Lock lock(&state);

bool haveWifi;


void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println();

  timeSync.init();
  connectToWifi();

  fileSystemConfig.setAutoFormat(false);
  fileSystem->setConfig(fileSystemConfig);
  fsOK = fileSystem->begin();
  Serial.println(fsOK ? F("Filesystem initialized.") : F("Filesystem init failed!"));
  if(!fsOK) {
    stop();
  }
  

  state.init();
  lock.init();
  
  scheduler.onNextDay(doNextDay);
  scheduler.onUnlock( []() {
    state.setCanUnlock(true);
  } );

  if (DEBUG) {
    server.on("/toggleLock", []() {
      lock.toggleLock();
      sendOk();
    });
    server.on("/canUnlock", []() {
      state.setCanUnlock(true);
      sendOk();
    });
    server.on("/dispensePill", []() {
      dispensePill();
      sendOk();
    });
    server.on("/doNextDay", []() {
      doNextDay();
      sendOk();
    });
    server.on("/clearSchedule", []() {
      scheduler.scheduleUnlock(0);
      sendOk();
    });
  }

  server.on("/doDispense", []() {
    doDispense();
    sendOk();
  });

  server.on(UriBraces("/scheduleUnlock/{}"), scheduleUnlock);
  
  server.on("/lock", []() {
    lock.lock();
    sendOk();
  });

  server.on("/unlock", []() {
    if(state.getCanUnlock()){
      lock.unlock();
    }
    sendOk();
  });
  
  server.on("/status", sendStatus);

  server.on(UriRegex("/.*"), HTTP_GET, handleGet);
  server.onNotFound(sendNotFound);
  server.begin();

  Serial.println("End setup");
  delay(1000);
}

void stop() {
  Serial.println("STOPPING!");
  while(1);
}

void handleGet() { 
  handleFileRead(server.uri());
}


void handleFileRead(String path) {
  Serial.println("Trying to serve");
  Serial.println(path);
  if (path.endsWith("/")) {
    path += "index.html";
  }

  String contentType = mime::getContentType(path);

  if (!fileSystem->exists(path)) {
    // File not found, try gzip version
    path = path + ".gz";
  }
  if (fileSystem->exists(path)) {
    Serial.println("exists");
    File file = fileSystem->open(path, "r");
    if (server.streamFile(file, contentType) != file.size()) { Serial.println("Sent less data than expected!"); }
    file.close();
  } else {
    Serial.println("no exists");
  }
}

void loop() {
  checkWifi();
  timeSync.update();
  scheduler.update(timeSync.isTimeSet());
  server.handleClient();
  delay(100);
}

void scheduleUnlock() {
  int minutes = server.pathArg(0).toInt();
  if (minutes >= MINIMUM_UNLOCK_TIME) {
    scheduler.scheduleUnlock(minutes);
    state.setCanUnlock(false);
    sendOk();
  } else {
    sendBadRequest();
  }
}

void doNextDay() {
  Serial.println("Next day");
  Serial.println();
  unsigned int currentlyAvailable = state.getPillsAvailable();
  state.setPillsAvailable(currentlyAvailable + PILLS_PER_DAY*100);
}

void doDispense() {
  unsigned int currentlyAvailable = state.getPillsAvailable();
  if(currentlyAvailable >= 100){
    Serial.println("Dispensing");
    state.setPillsAvailable(currentlyAvailable - 100);
    carousel.next();
  }
}

void dispensePill() {
  carousel.next();
}

void connectToWifi() {
  Serial.print("Configuring access point...");
  WiFi.mode(WIFI_AP_STA);
  delay(1000);
  IPAddress localIP(192, 168, 2, 1);
  IPAddress gateway(192, 168, 2, 0);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.softAPConfig(localIP, gateway, subnet);
  WiFi.softAP(AP_SSID, AP_PASS, AP_CHANNEL, AP_HIDDEN);
  WiFi.hostname(WIFI_HOSTNAME);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

void checkWifi() {
  if (WiFi.status() == WL_CONNECTED && !haveWifi) {
    haveWifi = true;
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
  }
  if (WiFi.status() != WL_CONNECTED && haveWifi) {
    haveWifi = false;
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
  doc["isLocked"] = String(state.getIsLocked());
  doc["canUnlock"] = String(state.getCanUnlock());
  doc["unlockTime"] = String(scheduler.getUnlockTime());
  doc["currentTime"] = String(scheduler.getCurrentTime());
  doc["readyTime"] = String(scheduler.getReadyTime());
  doc["pillsAvailable"] = String(float(state.getPillsAvailable())/float(100));
  doc["minimumUnlockTime"] = String(MINIMUM_UNLOCK_TIME);
  doc["debug"] = String(DEBUG);
  String status;
  serializeJson(doc, status);
  return status;
}

void sendStatus() {
  server.send(200, "text/plain", systemStatus());
}
