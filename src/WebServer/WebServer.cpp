#include <ESP8266WebServer.h>   
#include "Arduino.h"
#include "WebServer.h"


WebServer::WebServer() :
  _server(80),
  _lockLambda([](){}),
  _unlockLambda([](){}),
  _toggleLockLambda([](){}),
  _nextPillLambda([](){})
{
  _server.on("/lock", [this]() { 
    _lockLambda();
    _sendOk(); 
  });           
  _server.on("/unlock", [this]() { 
    _unlockLambda();
    _sendOk(); 
  });           
  _server.on("/toggleLock", [this]() { 
    _toggleLockLambda();
    _sendOk(); 
  });           
  _server.on("/nextPill", [this]() { 
    _nextPillLambda();
    _sendOk(); 
  }); 
  _server.onNotFound([this]() { _sendNotFound(); });       
  _server.begin();
} 

void WebServer::onToggleLock( Lambda handler ) {
  _toggleLockLambda = handler;
}
void WebServer::onLock( Lambda handler ) {
  _lockLambda = handler;
}
void WebServer::onUnlock( Lambda handler ) {
  _unlockLambda = handler;
}
void WebServer::onNextPill( Lambda handler ) {
  _nextPillLambda = handler;
}

void WebServer::update() {
  _server.handleClient();                    
}

void WebServer::_sendNotFound() {
  _server.send(404, "text/plain", "404: Not found"); 
}

void WebServer::_sendOk() {
  _server.send(200, "text/plain", "OK"); 
}