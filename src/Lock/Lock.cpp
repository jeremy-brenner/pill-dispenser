#include <ESPFlash.h>
#include <Servo.h> 
#include "Arduino.h"
#include "Lock.h"
#include "../../lock.h"

Lock::Lock() :
  _isLocked("/locked")
{
  _servo.attach(LOCK_PIN);
  _moveServo();
}

void Lock::toggleLock() {
  _isLocked.get() ? _unlock() : _lock();
}

void Lock::lock() {
  if(!_isLocked.get()){
    _lock();
  }
}

void Lock::unlock() {
  if(_isLocked.get()){
    _unlock();
  }
}

bool Lock::isLocked() {
  return _isLocked.get();
}

void Lock::_moveServo() {
  _isLocked.get() ? _servo.write(LOCK_ANGLE) : _servo.write(UNLOCK_ANGLE);
}

void Lock::_lock() {
  // _servo.write(LOCK_ANGLE)
  _isLocked.set(true); 
  _moveServo();
}

void Lock::_unlock() {
  // _servo.write(UNLOCK_ANGLE)
  _isLocked.set(false); 
  _moveServo();
}