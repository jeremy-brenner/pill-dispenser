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
  _dispenseLambda([](){})
{
  _timeClient.begin();
} 

bool Scheduler::update() {
  _timeClient.update();
  if(_ntpReady() && _shouldDispense()) {
    _dispenseLambda();
    _dayDispensed.set(_timeClient.getDay());
  }
  return _ntpReady();
}

void Scheduler::onDispense( Lambda handler ) {
  _dispenseLambda = handler;
}

bool Scheduler::_shouldDispense() {
  int currentDay = _timeClient.getDay();
  int currentTime = _timeClient.getHours() * 100 + _timeClient.getMinutes();
  return currentDay != _dayDispensed.get() && currentTime >= DISPENSE_TIME;
}

bool Scheduler::_ntpReady() {
  return _timeClient.getEpochTime()-TIME_OFFSET > _saneTime;
}
  