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
    int getLastDayHandled();
    unsigned long getUnlockTime();
    unsigned int getPillsAvailable();
    void setIsLocked(bool isLocked);
    void setLastDayHandled(int lastDayHandled);
    void setUnlockTime(unsigned long unlockTime);
    void setPillsAvailable(unsigned int pillsAvailable);
  private:
    bool _isLocked;
    int _lastDayHandled;
    unsigned long _unlockTime;
    unsigned int _pillsAvailable;
    void _getStoredState();
    void _saveStoredState();
    FS* _fs;
};

#endif