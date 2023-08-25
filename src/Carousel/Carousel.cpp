#include <Servo.h> 
#include "Arduino.h"
#include "Carousel.h"
#include "../../carousel.h"

Carousel::Carousel() 
{
  _servo.attach(CAROUSEL_PIN);
  _servo.write(REST_ANGLE);
}

void Carousel::next() {
  _servo.write(PUSH_ANGLE);
  delay(500);
  _servo.write(REST_ANGLE);
  delay(500);
}