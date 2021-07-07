#include "Arduino.h"
#include "Motor.h"

Motor::Motor(const int (&pins)[4]) 
{
  for (int i = 0; i < 4; i++ ) {
    pinMode(pins[i], OUTPUT);
    _pins[i] = pins[i];
  }
}

void Motor::move(int deg)
{
  int absDeg = abs(deg);
  for(int s = 0;  s < _degToSteps(absDeg); s++) {
    for(int p = 0;  p < 4; p++) {
      digitalWrite(_pins[ deg >= 0 ? p : 3-p ], _pinState(s,p));
    }
    delay(10);
  }
}

int Motor::_degToSteps(int deg)
{
 return MOTOR_STEPS/(360/(float)deg);
}

int Motor::_pinState(int step, int pin)
{
  return step % 4 == pin ? HIGH : LOW;
}
