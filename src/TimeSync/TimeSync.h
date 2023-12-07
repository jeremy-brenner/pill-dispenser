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
    bool haveRTC();
    bool haveNTP();
  private:
    bool _haveRTC;
    bool _haveNTP;
    unsigned long _RTCLastSynced;
    bool _isTimeToSyncToRTC();
    void _syncToRTC();
};

#endif