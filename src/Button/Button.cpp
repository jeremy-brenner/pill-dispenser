#include "Arduino.h"
#include "Button.h"

Button::Button(int pin):
  _pin(pin),
  _lastButtonState(0)
{
  pinMode(_pin, INPUT);
}

void Button::onPress(Lambda cb) {
  _cb = cb;
}

void Button::update() {
  int buttonState = digitalRead(_pin);
  if( buttonState == _lastButtonState ) {
    return;
  }
  _lastButtonState = buttonState;
  if(buttonState == 0) {
    _cb();
  }
}
