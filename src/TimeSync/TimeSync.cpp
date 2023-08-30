#include "TimeSync.h"
#include "Arduino.h"
#include "../NTPClient/NTPClient.h"
#include <WiFiUdp.h>
#include <TimeLib.h>
#include <RTClib.h>

#include "../../schedule.h"

#define SECONDS_BETWEEN_SYNCS 60*60

RTC_DS3231 RTC;

time_t time_provider()
{
  return RTC.now().unixtime();
}

TimeSync::TimeSync() :
  _ntpUDP(),
  _timeClient(_ntpUDP, "pool.ntp.org"),
  _lastSynced(0),
  _haveRTC(false)
{
} 

void TimeSync::init() {
  _timeClient.begin();
  _haveRTC = RTC.begin();
  setSyncProvider(time_provider);
  setSyncInterval(60);
}

bool TimeSync::isTimeSet() {
  return _timeClient.isTimeSet() || _haveRTC;
}

void TimeSync::update() {
  _timeClient.update();
  if(_timeClient.isTimeSet()) {
    unsigned long currentTime = _timeClient.getEpochTime();
    unsigned long timeSyncLastSync = currentTime - _lastSynced;
    if(timeSyncLastSync > SECONDS_BETWEEN_SYNCS) {
      _lastSynced = currentTime;
      RTC.adjust(DateTime((uint32_t) currentTime));
    }    
  }
}
