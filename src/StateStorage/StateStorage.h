/*
  StateStorage
*/
#ifndef StateStorage_h
#define StateStorage_h

#include "Arduino.h"
#include <LittleFS.h>
#include <ArduinoJson.h>

class StateStorage
{
  public:
    StateStorage(FS* fs);
    void init();
    bool getIsLocked();
    int getDayDispensed();
    unsigned long getUnlockTime();
    void setIsLocked(bool isLocked);
    void setDayDispensed(int dayDispensed);
    void setUnlockTime(unsigned long unlockTime);
  private:
    bool _isLocked;
    int _dayDispensed;
    unsigned long _unlockTime;
    void _getStoredState();
    void _saveStoredState();
    FS* _fs;
};

#endif