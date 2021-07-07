/*
  WebServer
*/
#ifndef WebServer_h
#define WebServer_h

#include <ESP8266WebServer.h>   
#include "Arduino.h"

typedef void (*Lambda)();

class WebServer
{
  public:
    WebServer();
    void update();
    void onToggleLock( Lambda fn );
    void onLock( Lambda fn );
    void onUnlock( Lambda fn );
    void onNextPill( Lambda fn );
  private:
    ESP8266WebServer _server;
    Lambda _toggleLockLambda;
    Lambda _lockLambda;
    Lambda _unlockLambda;
    Lambda _nextPillLambda;
    void _sendOk();
    void _sendNotFound();
};


#endif

