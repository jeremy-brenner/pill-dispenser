/*
  Lock
*/
#ifndef Lock_h
#define Lock_h

#include <ESPFlash.h>
#include "Arduino.h"
#include <Servo.h> 

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
    void _moveServo();
    Servo _servo;
    ESPFlash<bool> _isLocked;
};

#endif