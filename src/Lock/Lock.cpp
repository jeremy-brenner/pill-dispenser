#include <ESPFlash.h>
#include "Arduino.h"
#include "Lock.h"
#include "../Motor/Motor.h"
#include "../../lock.h"

Lock::Lock() :
  _isLocked("/locked"),
  _motor(LOCK_PINS)
{
  
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

void Lock::_lock() {
  _motor.move(LOCK_DEG);
  _isLocked.set(true); 
}

void Lock::_unlock() {
  _motor.move(-LOCK_DEG);
  _isLocked.set(false); 
}