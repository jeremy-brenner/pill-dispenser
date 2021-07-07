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
  _isLocked.get() ? unlock() : lock();
}

void Lock::lock() {
  _motor.move(LOCK_DEG);
  _isLocked.set(true); 
}

void Lock::unlock() {
  _motor.move(-LOCK_DEG);
  _isLocked.set(false); 
}