/*
  Lock
*/
#ifndef Lock_h
#define Lock_h

#include "Arduino.h"
#include "../StateStorage/StateStorage.h"
#include <Servo.h> 

class Lock
{
  public:
    Lock(StateStorage* state);
    void init();
    void toggleLock();
    void lock();
    void unlock();
    bool isLocked();
  private:
    void _moveServo();
    StateStorage* _state;
    Servo _servo;
};

#endif