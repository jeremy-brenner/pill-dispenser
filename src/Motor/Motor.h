/*
  Motor
*/
#ifndef Motor_h
#define Motor_h

#include "Arduino.h"

#define MOTOR_STEPS 2048

class Motor
{
  public:
    Motor(const int (&pins)[4]);
    void move(int deg);
  private:
    int _degToSteps(int deg);
    int _pinState(int step, int pin);
    int _pins[4];
};

#endif