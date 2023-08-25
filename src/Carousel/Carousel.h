/*
  Carousel
*/
#ifndef Carousel_h
#define Carousel_h

#include "Arduino.h"
#include <Servo.h> 

class Carousel
{
  public:
    Carousel();
    void next();
  private:
    Servo _servo;
};

#endif