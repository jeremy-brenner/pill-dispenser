/*
  Scheduler
*/
#ifndef Scheduler_h
#define Scheduler_h

#include "Arduino.h"
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ESPFlash.h>

typedef void (*Lambda)();

class Scheduler
{
  public:
    Scheduler();
    bool update();
    void onDispense( Lambda fn );
  private:
    WiFiUDP _ntpUDP;
    NTPClient _timeClient;
    bool _ntpReady();
    bool _shouldDispense();
    ESPFlash<int> _dayDispensed;
    int _saneTime = 1624000000;
    Lambda _dispenseLambda;
};

#endif