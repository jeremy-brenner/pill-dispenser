#include "Arduino.h"
#include <LittleFS.h>
#include "StateStorage.h"
#include <ArduinoJson.h>

#define STATEFILE "/state.json"

StateStorage::StateStorage(FS* fs) :
  _fs(fs)
{}

void StateStorage::init() {
  _getStoredState();
}

bool StateStorage::getIsLocked() {
  return _isLocked;
}

int StateStorage::getDayDispensed() {
  return _dayDispensed;
}

unsigned long StateStorage::getUnlockTime() {
  return _unlockTime;
}

void StateStorage::setIsLocked(bool isLocked) {
  if(isLocked != _isLocked) {
    _isLocked = isLocked;
    _saveStoredState();
  }
}

void StateStorage::setDayDispensed(int dayDispensed) {
  if(dayDispensed != _dayDispensed) {
    _dayDispensed = dayDispensed;
    _saveStoredState();
  }
}

void StateStorage::setUnlockTime(unsigned long unlockTime) {
  if(unlockTime != _unlockTime) {
    _unlockTime = unlockTime;
    _saveStoredState();
  }
}

void StateStorage::_getStoredState() {

  if (_fs->exists(STATEFILE)) {
    StaticJsonDocument<200> stateJson;
    File file = _fs->open(STATEFILE, "r");
    String stateString = file.readString();
    file.close();
    DeserializationError error = deserializeJson(stateJson, stateString);
    if (error) {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(error.f_str());
    }
    _isLocked = stateJson["isLocked"] == "1";
    _dayDispensed = stateJson["dayDispensed"];
    _unlockTime = stateJson["unlockTime"];
    Serial.println("Got state");
    Serial.println(stateString);
    Serial.println(_dayDispensed);
    Serial.println(_unlockTime);
  }else{
    Serial.println("no state file, setting defaults");
    _isLocked = false;
    _dayDispensed = 0;
    _unlockTime = 0;
    _saveStoredState();
  }
}

void StateStorage::_saveStoredState() {
  Serial.println("saving state");
  StaticJsonDocument<200> stateJson;
  stateJson["isLocked"] = String(_isLocked);
  stateJson["dayDispensed"] = String(_dayDispensed);
  stateJson["unlockTime"] = String(_unlockTime);
  String state;
  serializeJson(stateJson, state);
  File file = _fs->open(STATEFILE, "w");
  file.print(state);
  file.close();
  Serial.println(state);
}