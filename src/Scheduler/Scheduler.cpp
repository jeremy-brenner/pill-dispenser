#include "Scheduler.h"

#include "Arduino.h"
#include "../NTPClient/NTPClient.h"
#include <WiFiUdp.h>
#include <ESPFlash.h>

#include "../../schedule.h"

#define TIME_OFFSET TIME_OFFSET_HOURS*3600L

Scheduler::Scheduler() :
  _ntpUDP(),
  _timeClient(_ntpUDP, TIME_OFFSET),
  _readyTime(0), 
  _began(false),
  _dayDispensed("/dayDispensed"),
  _unlockTime("/unlockTime"),
  _unlockLambda([](){}),
  _dispenseLambda([](){})
{} 

bool Scheduler::readyCheck() {
  if(!_began) {
    _timeClient.begin();
    _began = true;
  }
  if(_readyTime == 0) {
    _timeClient.update();
    delay(100);
  }
  if(_readyTime == 0 && _timeClient.isTimeSet()) {
    _readyTime = _timeClient.getEpochTime();
  }
  return _timeClient.isTimeSet();
}

void Scheduler::update() {
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
  _unlockTime.set(minutes == 0 ? 0 : scheduleTime);
}

unsigned long Scheduler::getUnlockTime() {
  return _timestamp( _unlockTime.get() );
}

unsigned long Scheduler::getCurrentTime() {
  return _timestamp( _timeClient.getEpochTime() );
}

unsigned long Scheduler::getReadyTime() {
  return _timestamp( _readyTime );
}

void Scheduler::onDispense( Lambda handler ) {
  _dispenseLambda = handler;
}

void Scheduler::onUnlock( Lambda handler ) {
  _unlockLambda = handler;
}

unsigned long Scheduler::_timestamp(unsigned long time) {
  return time - TIME_OFFSET;
}

bool Scheduler::_shouldDispense() {
  int currentDay = _timeClient.getDay();
  int currentTime = _timeClient.getHours() * 100 + _timeClient.getMinutes();
  return currentDay != _dayDispensed.get() && currentTime >= DISPENSE_TIME;
}

bool Scheduler::_shouldUnlock() {
  return _unlockTime.get() != 0 && _unlockTime.get() < _timeClient.getEpochTime();
}

