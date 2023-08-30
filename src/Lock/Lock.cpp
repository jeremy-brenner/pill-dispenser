#include "Arduino.h"
#include "../StateStorage/StateStorage.h"
#include "Lock.h"
#include <Servo.h> 
#include "../../lock.h"

Lock::Lock(StateStorage* state) :
  _state(state)
{

}

void Lock::init() {
  _servo.attach(LOCK_PIN);
  _moveServo();
}

void Lock::lock() {
  _state->setIsLocked(true);
  _moveServo();
}

void Lock::toggleLock() {
  if(_state->getIsLocked()) {
    unlock();
  }else{
    lock();
  }
}

void Lock::unlock() {
  _state->setIsLocked(false);
  _moveServo();
}

bool Lock::isLocked(){
  return _state->getIsLocked();
}

void Lock::_moveServo() {
  _state->getIsLocked() ? _servo.write(LOCK_ANGLE) : _servo.write(UNLOCK_ANGLE);
}
