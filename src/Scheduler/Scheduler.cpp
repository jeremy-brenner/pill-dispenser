#include "Scheduler.h"
#include "Arduino.h"
#include <ESPFlash.h>
#include <TimeLib.h>


#include "../../schedule.h"
#define TIME_OFFSET TIME_OFFSET_HOURS*3600L

Scheduler::Scheduler() :
  _dayDispensed("/dayDispensed"),
  _unlockTime("/unlockTime"),
  _unlockLambda([](){}),
  _dispenseLambda([](){})
{} 

void Scheduler::ready() {
  _readyTime = now();
}

void Scheduler::update() {
  if(_shouldDispense()) {
    _dispenseLambda();
    _dayDispensed.set(_currentDay());
  }
  if(_shouldUnlock()) {
    _unlockLambda();
    _unlockTime.set(0);
  }
}

void Scheduler::scheduleUnlock(int minutes) {
  unsigned long scheduleTime = now() + minutes * 60L;
  _unlockTime.set(minutes == 0 ? 0 : scheduleTime);
}

unsigned long Scheduler::getUnlockTime() {
  return _unlockTime.get();
}

unsigned long Scheduler::getCurrentTime() {
  return now();
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
  return _currentDay() != _dayDispensed.get() && _currentTime() >= DISPENSE_TIME;
}

bool Scheduler::_shouldUnlock() {
  return _unlockTime.get() != 0 && _unlockTime.get() < now();
}

unsigned long Scheduler::_offsetNow() {
  return now() + TIME_OFFSET;
}

int Scheduler::_currentDay() {
  return day(_offsetNow());
}

int Scheduler::_currentTime() {
  return hour(_offsetNow()) * 100 + minute(_offsetNow());
}

