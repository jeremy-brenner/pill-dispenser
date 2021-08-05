/*
  Scheduler
*/
#ifndef Scheduler_h
#define Scheduler_h

#include "Arduino.h"
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>


#define SANE_TIME 1624000000

typedef void (*Lambda)();

class Scheduler
{
  public:
    Scheduler();
    bool update();
    bool readyCheck();
    void scheduleUnlock(int minutes);
    void onUnlock( Lambda fn );
    void onDispense( Lambda fn );
    unsigned long getUnlockTime();
    unsigned long getCurrentTime();
    unsigned long getReadyTime();
  private:
    WiFiUDP _ntpUDP;
    NTPClient _timeClient;
    unsigned long _readyTime;
    bool _shouldDispense();
    bool _shouldUnlock();
    bool _ntpReady();
    ESPFlash<int> _dayDispensed;
    ESPFlash<unsigned long> _unlockTime;
    Lambda _unlockLambda;
    Lambda _dispenseLambda;
};

#endif