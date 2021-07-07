#include "Scheduler.h"

#include "Arduino.h"
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>

#include "../../schedule.h"

Scheduler::Scheduler() :
  _ntpUDP(),
  _timeClient(_ntpUDP, TIME_OFFSET),
  _dayDispensed("/dayDispensed"),
  _unlockTime("/unlockTime"),
  _unlockLambda([](){}),
  _dispenseLambda([](){}),
  _ntpReadyLambda([](){})
{
  _timeClient.begin();
} 

bool Scheduler::readyCheck() {
  _timeClient.update();
  if(_ntpReady()) {
    _ntpReadyLambda();
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

void Scheduler::scheduleUnlock(int days) {
  unsigned long scheduleTime = _timeClient.getEpochTime() + days * 86400L;
  _unlockTime.set(scheduleTime);
}

void Scheduler::onDispense( Lambda handler ) {
  _dispenseLambda = handler;
}

void Scheduler::onNtpReady( Lambda handler ) {
  _ntpReadyLambda = handler;
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
  return _timeClient.getEpochTime()-TIME_OFFSET > SANE_TIME;
}
  