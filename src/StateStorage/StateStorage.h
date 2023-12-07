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
    void reset();
    bool getIsLocked();
    bool getIsDebug();
    int getLastDayHandled();
    unsigned long getUnlockTime();
    unsigned int getPillsAvailable();    
    unsigned int getPillsLeft();
    void setIsLocked(bool isLocked);
    void setIsDebug(bool isDebug);
    void setLastDayHandled(int lastDayHandled);
    void setUnlockTime(unsigned long unlockTime);
    void setPillsAvailable(unsigned int pillsAvailable);
    void setPillsLeft(unsigned int pillsLeft);
  private:
    bool _isLocked;
    bool _isDebug;
    int _lastDayHandled;
    unsigned long _unlockTime;
    unsigned int _pillsAvailable;
    unsigned int _pillsLeft;
    void _getStoredState();
    void _saveStoredState();
    FS* _fs;
};

#endif