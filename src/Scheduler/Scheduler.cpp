#include "Scheduler.h"

#include "Arduino.h"
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>

#include "../../schedule.h"

#define TIME_OFFSET TIME_OFFSET_HOURS*3600L

Scheduler::Scheduler() :
  _ntpUDP(),
  _timeClient(_ntpUDP, TIME_OFFSET),
  _readyTime(0), 
  _dayDispensed("/dayDispensed"),
  _unlockTime("/unlockTime"),
  _unlockLambda([](){}),
  _dispenseLambda([](){})
{
  _timeClient.begin();
} 

bool Scheduler::readyCheck() {
  if(!_ntpReady()) {
    _timeClient.update();
  }
  return _ntpReady();
}

bool Scheduler::update() {
  _timeClient.update();
  if(_shouldDispense()) {
    _dispenseLambda();
    _dayDispensed.set(_timeClient.getDay());
  }
  if(_shouldUnlock()) {
    _unlockLambda();
    _unlockTime.set(0);
  }
}

void Scheduler::scheduleUnlock(int minutes) {
  unsigned long scheduleTime = _timeClient.getEpochTime() + minutes * 60L;
  if(_unlockTime.get() == 0 || _unlockTime.get() > scheduleTime ){
    _unlockTime.set(minutes == 0 ? 0 : scheduleTime);
  }
}

unsigned long Scheduler::getUnlockTime() {
  return _unlockTime.get();
}

unsigned long Scheduler::getCurrentTime() {
  return _timeClient.getEpochTime();
}

unsigned long Scheduler::getReadyTime() {
  return _readyTime;
}

void Scheduler::onDispense( Lambda handler ) {
  _dispenseLambda = handler;
}

void Scheduler::onUnlock( Lambda handler ) {
  _unlockLambda = handler;
}

bool Scheduler::_shouldDispense() {
  int currentDay = _timeClient.getDay();
  int currentTime = _timeClient.getHours() * 100 + _timeClient.getMinutes();
  return currentDay != _dayDispensed.get() && currentTime >= DISPENSE_TIME;
}

bool Scheduler::_shouldUnlock() {
  return _unlockTime.get() != 0 && _unlockTime.get() < _timeClient.getEpochTime();
}

bool Scheduler::_ntpReady() {
  if( _readyTime == 0 && _timeClient.getEpochTime()-TIME_OFFSET > SANE_TIME ) {
    _readyTime = _timeClient.getEpochTime();
  }
  return _readyTime > 0;
}
  