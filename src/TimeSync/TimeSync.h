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
    void update(RTC_DS3231 rtc);
  private:
    WiFiUDP _ntpUDP;
    NTPClient _timeClient;
    unsigned long _lastSynced;
    unsigned long _timestamp(unsigned long time);
};

#endif