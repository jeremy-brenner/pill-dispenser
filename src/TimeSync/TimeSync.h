/*
  TimeSync
*/
#ifndef TimeSync_h
#define TimeSync_h

#include "Arduino.h"
#include "../NTPClient/NTPClient.h"
#include <WiFiUdp.h>
#include <TimeLib.h>
#include <RTClib.h>

class TimeSync
{
  public:
    TimeSync();
    bool isTimeSet();
    void update();
    void init();
  private:
    WiFiUDP _ntpUDP;
    NTPClient _timeClient;
    bool _haveRTC;
    unsigned long _lastSynced;
    unsigned long _timestamp(unsigned long time);
};

#endif