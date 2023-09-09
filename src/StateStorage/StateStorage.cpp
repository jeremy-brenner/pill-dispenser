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

bool StateStorage::getIsDebug() {
  return _isDebug;
}

bool StateStorage::getCanUnlock() {
  return _canUnlock;
}

int StateStorage::getLastDayHandled() {
  return _lastDayHandled;
}

unsigned long StateStorage::getUnlockTime() {
  return _unlockTime;
}

unsigned int StateStorage::getPillsAvailable() {
  return _pillsAvailable;
}

unsigned int StateStorage::getPillsLeft() {
  return _pillsLeft;
}

void StateStorage::setIsLocked(bool isLocked) {
  if(isLocked != _isLocked) {
    _isLocked = isLocked;
    _saveStoredState();
  }
}

void StateStorage::setIsDebug(bool isDebug) {
  if(isDebug != _isDebug) {
    _isDebug = isDebug;
    _saveStoredState();
  }
}

void StateStorage::setCanUnlock(bool canUnlock) {
  if(canUnlock != _canUnlock) {
    _canUnlock = canUnlock;
    _saveStoredState();
  }
}

void StateStorage::setLastDayHandled(int lastDayHandled) {
  if(lastDayHandled != _lastDayHandled) {
    _lastDayHandled = lastDayHandled;
    _saveStoredState();
  }
}

void StateStorage::setUnlockTime(unsigned long unlockTime) {
  if(unlockTime != _unlockTime) {
    _unlockTime = unlockTime;
    _saveStoredState();
  }
}

void StateStorage::setPillsAvailable(unsigned int pillsAvailable) {
    if(pillsAvailable != _pillsAvailable) {
    _pillsAvailable = pillsAvailable;
    _saveStoredState();
  }
}

void StateStorage::setPillsLeft(unsigned int pillsLeft) {
    if(pillsLeft != _pillsLeft) {
    _pillsLeft = pillsLeft;
    _saveStoredState();
  }
}


void StateStorage::_getStoredState() {
  if (_fs->exists(STATEFILE)) {
    StaticJsonDocument<500> stateJson;
    File file = _fs->open(STATEFILE, "r");
    String stateString = file.readString();
    file.close();
    DeserializationError error = deserializeJson(stateJson, stateString);
    if (error) {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(error.f_str());
    }
    _isLocked = stateJson["isLocked"] == "1";
    _isDebug = stateJson["isDebug"] == "1";
    _canUnlock = stateJson["canUnlock"] == "1";
    _lastDayHandled = stateJson["lastDayHandled"];
    _unlockTime = stateJson["unlockTime"];
    _pillsAvailable = stateJson["pillsAvailable"];
    _pillsLeft = stateJson["pillsLeft"];
    Serial.println("gpl");
    Serial.println(_pillsLeft);
    Serial.println("Got state");
    Serial.println(stateString);
  }else{
    Serial.println("no state file, setting defaults");
    _isLocked = false;
    _isDebug = true;
    _canUnlock = true;
    _lastDayHandled = -1;
    _unlockTime = 0;
    _pillsAvailable = 0;
    _pillsLeft = 0;
    _saveStoredState();
  }
}

void StateStorage::_saveStoredState() {
  Serial.println("saving state");
  StaticJsonDocument<500> stateJson;
  stateJson["isLocked"] = String(_isLocked);
  stateJson["isDebug"] = String(_isDebug);
  stateJson["canUnlock"] = String(_canUnlock);
  stateJson["lastDayHandled"] = String(_lastDayHandled);
  stateJson["unlockTime"] = String(_unlockTime);
  stateJson["pillsAvailable"] = String(_pillsAvailable);
  stateJson["pillsLeft"] = String(_pillsLeft);
  String state;
  serializeJson(stateJson, state);
  File file = _fs->open(STATEFILE, "w");
  file.print(state);
  file.close();
  Serial.println(state);
}

void StateStorage::reset() {
  if (_fs->exists(STATEFILE)) {
    _fs->remove(STATEFILE);
  }
  _getStoredState();
}