/*
  Button
*/
#ifndef Button_h
#define Button_h

#include "Arduino.h"

typedef void (*Lambda)();

class Button
{
  public:
    Button(int pin);
    void onPress(Lambda cb);
    void update();
  private:
    int _pin;
    int _lastButtonState;
    Lambda _cb;
};

#endif