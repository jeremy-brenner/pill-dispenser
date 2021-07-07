/*
  Lock
*/
#ifndef Lock_h
#define Lock_h

#include <ESPFlash.h>
#include "Arduino.h"
#include "../Motor/Motor.h"

class Lock
{
  public:
    Lock();
    void toggleLock();
    void lock();
    void unlock();
    bool isLocked();
  private:
    void _lock();
    void _unlock();
    Motor _motor;
    ESPFlash<bool> _isLocked;
};

#endif