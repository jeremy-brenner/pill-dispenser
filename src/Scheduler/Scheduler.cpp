#include "Scheduler.h"
#include "Arduino.h"
#include "../StateStorage/StateStorage.h"
#include <TimeLib.h>


#include "../../schedule.h"
#define TIME_OFFSET TIME_OFFSET_HOURS*3600L

Scheduler::Scheduler(StateStorage* state) :
  _state(state),
  _unlockLambda([](){}),
  _dispenseLambda([](){}),
  _readyTime(0)
{} 

bool Scheduler::isReady() {
  return _readyTime > 0;
}

void Scheduler::update(bool isTimeSet) {
  if(!isReady() && isTimeSet) {
    _readyTime = now();
  }
  if(!isReady()) {
    Serial.println("not ready");
    return;
  }
  if(_shouldDispense()) {
    _dispenseLambda();
    _state->setDayDispensed(_currentDay());
  }
  if(_shouldUnlock()) {
    _unlockLambda();
    _state->setUnlockTime(0);
  }
}

void Scheduler::scheduleUnlock(int minutes) {
  unsigned long scheduleTime = now() + minutes * 60L;
  _state->setUnlockTime(minutes == 0 ? 0 : scheduleTime);
}

unsigned long Scheduler::getUnlockTime() {
  return _state->getUnlockTime();
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
  return _currentDay() != _state->getDayDispensed() && _currentTime() >= DISPENSE_TIME;
}

bool Scheduler::_shouldUnlock() {
  return _state->getUnlockTime() != 0 && _state->getUnlockTime() < now();
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

