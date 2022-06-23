/*
  Scheduler
*/
#ifndef Scheduler_h
#define Scheduler_h

#include "Arduino.h"
#include <ESPFlash.h>
#include <TimeLib.h>

typedef void (*Lambda)();

class Scheduler
{
  public:
    Scheduler();
    void ready();
    void update();
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
    ESPFlash<int> _dayDispensed;
    ESPFlash<unsigned long> _unlockTime;
    Lambda _unlockLambda;
    Lambda _dispenseLambda;
};

#endif