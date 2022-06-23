#include "TimeSync.h"
#include "Arduino.h"
#include "../NTPClient/NTPClient.h"
#include <WiFiUdp.h>
#include <TimeLib.h>
#include <RTClib.h>

#include "../../schedule.h"

#define SECONDS_BETWEEN_SYNCS 60*60

TimeSync::TimeSync() :
  _ntpUDP(),
  _timeClient(_ntpUDP),
  _lastSynced(0)
{
  _timeClient.begin();
} 

void TimeSync::update(RTC_DS3231 rtc) {
  _timeClient.update();
  if(_timeClient.isTimeSet()) {
    unsigned long currentTime = _timeClient.getEpochTime();
    unsigned long timeSyncLastSync = currentTime - _lastSynced;
    if(timeSyncLastSync > SECONDS_BETWEEN_SYNCS) {
      _lastSynced = currentTime;
      rtc.adjust(DateTime((uint32_t) currentTime));
    }    
  }
}
