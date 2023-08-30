/*
  Scheduler
*/
#ifndef Scheduler_h
#define Scheduler_h

#include "Arduino.h"
#include "../StateStorage/StateStorage.h"
#include <TimeLib.h>

typedef void (*Lambda)();

class Scheduler
{
  public:
    Scheduler(StateStorage* state);
    void ready();
    bool isReady();
    void update(bool isTimeSet);
    void scheduleUnlock(int minutes);
    void onUnlock( Lambda fn );
    void onDispense( Lambda fn );
    unsigned long getUnlockTime();
    unsigned long getCurrentTime();
    unsigned long getReadyTime();
  private:
    unsigned long _readyTime;
    bool _shouldDispense();
    bool _shouldUnlock();
    unsigned long _offsetNow();
    int _currentDay();
    int _currentTime();
    StateStorage* _state;
    Lambda _unlockLambda;
    Lambda _dispenseLambda;
};

#endif