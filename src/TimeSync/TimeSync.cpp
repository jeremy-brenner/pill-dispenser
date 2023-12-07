#include "TimeSync.h"
#include "Arduino.h"
#include "../NTPClient/NTPClient.h"
#include <WiFiUdp.h>
#include <TimeLib.h>
#include <RTClib.h>

#include "../../schedule.h"

#define SECONDS_BETWEEN_SYNC_TO_RTC 60*60

RTC_DS3231 RTC;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

time_t rtc_time_provider()
{
  return RTC.now().unixtime();
}

time_t ntp_time_provider()
{
  return timeClient.getEpochTime(); 
}

TimeSync::TimeSync() :
  _RTCLastSynced(0),
  _haveRTC(false),
  _haveNTP(false)
{
} 

void TimeSync::init() {
  Serial.println("Starting UDP client");
  timeClient.begin();
  Serial.println("Starting RTC");
  _haveRTC = RTC.begin();
  if(_haveRTC) {
    Serial.println("Got RTC");
    setSyncProvider(rtc_time_provider);
  }else{
    Serial.println("NO RTC");
    setSyncProvider(ntp_time_provider);
  }
  setSyncInterval(60);

}


bool TimeSync::isTimeSet() {
  return _haveNTP || _haveRTC;
}

bool TimeSync::haveRTC() {
  return _haveRTC;
}

bool TimeSync::haveNTP() {
  return _haveNTP;
}

bool TimeSync::_isTimeToSyncToRTC() {
  return timeClient.getEpochTime() - _RTCLastSynced > SECONDS_BETWEEN_SYNC_TO_RTC;
}

void TimeSync::_syncToRTC() {
  unsigned long currentTime = timeClient.getEpochTime();
  RTC.adjust(DateTime((uint32_t) currentTime));
  _RTCLastSynced = currentTime;
}

void TimeSync::update() {
  bool didUpdate = timeClient.update();
  if(!_haveNTP && didUpdate) {
    Serial.println("Got NTP");
    setTime(timeClient.getEpochTime());
    _haveNTP = true;
  }

  if(_haveNTP && _haveRTC && _isTimeToSyncToRTC()) {
    _syncToRTC();
  }
}


