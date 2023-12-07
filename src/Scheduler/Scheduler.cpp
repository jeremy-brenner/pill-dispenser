#include "Scheduler.h"
#include "Arduino.h"
#include "../StateStorage/StateStorage.h"
#include <TimeLib.h>


#include "../../schedule.h"
#define TIME_OFFSET TIME_OFFSET_HOURS*3600L

Scheduler::Scheduler(StateStorage* state) :
  _state(state),
  _nextDayLambda([](){}),
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
  if(_isFirstRun()) {
    _state->setLastDayHandled(_currentDay());
  }
  if(_isNextDay()) {
    _nextDayLambda();
    _state->setLastDayHandled(_currentDay());
  }
}

void Scheduler::scheduleUnlock(int minutes) {
  unsigned long scheduleTime = now() + minutes * 60L;
  _state->setUnlockTime(scheduleTime);
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

void Scheduler::onNextDay( Lambda handler ) {
  _nextDayLambda = handler;
}

bool Scheduler::_isFirstRun() {
  return _state->getLastDayHandled() == -1;
}

bool Scheduler::_isNextDay() {
  return _currentDay() != _state->getLastDayHandled() && _currentTime() >= DISPENSE_TIME;
}

bool Scheduler::getCanUnlock() {
  return _state->getUnlockTime() < now();
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

