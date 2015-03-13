#include <Adafruit_NeoPixel.h>

int floatingPin = A0;
const int AI0 = A1;
const int AI1 = A2;
const int AI2 = A3;
const int AI3 = A4;
const int AI4 = A5;
const int AI5 = A6;
const int ledPin = 2;
const int numOfPixels = 6;

int colors[][3] = {
{255, 0, 0},
{0, 255, 0},
{0, 0, 255},
{255, 0, 255},
{0, 255, 255},
{255, 255, 0},
{0, 0, 0}};

int randoms[30][6] = {
{0,5,4,3,2,1},
{5,0,3,2,1,4},
{1,0,5,2,4,3},
{5,3,0,4,1,2},
{1,0,3,4,5,2},
{3,5,0,2,1,4},
{0,3,1,5,2,4},
{2,5,0,3,4,1},
{4,2,0,1,5,3},
{5,1,0,4,2,3},
{1,0,2,5,3,4},
{0,1,5,4,2,3},
{1,0,3,5,4,2},
{0,4,3,1,5,2},
{4,0,5,1,2,3},
{3,2,5,1,4,0},
{0,2,1,3,5,4},
{2,4,3,0,1,5},
{1,5,4,2,0,3},
{0,4,5,3,2,1},
{4,0,3,2,5,1},
{3,5,2,4,1,0},
{3,4,5,2,0,1},
{1,5,4,2,3,0},
{5,4,3,1,0,2},
{2,4,0,5,1,3},
{0,2,1,3,5,4},
{0,1,5,2,4,3},
{0,5,2,4,3,1},
{4,0,3,2,1,5}};

Adafruit_NeoPixel leds = Adafruit_NeoPixel(numOfPixels, ledPin, NEO_GRB + NEO_KHZ800);

void setup(){
  
  leds.begin();
  leds.show();
  
  randomSeed(analogRead(floatingPin));

  Serial.begin(9600);

}


void loop(){
  displayRand(500);
//  rainbow(20);
  Serial.println(sensorVal(AI0));
  Serial.println(sensorVal(AI1));
  Serial.println(sensorVal(AI2));
  Serial.println(sensorVal(AI3));
  Serial.println(sensorVal(AI4));
  Serial.println(sensorVal(AI5));
  delay(100);
    
}

void displayRand(int wait) {
  int r = random(30);
  for(int i = 0; i < numOfPixels; i++) {
    leds.setPixelColor(i, colors[randoms[r][i]][0], colors[randoms[r][i]][1], colors[randoms[r][i]][2]);
  }
  leds.show();
  delay(wait);
  for(int i = 0; i < leds.numPixels(); i++) {
    leds.setPixelColor(i, colors[7][0], colors[7][1], colors[7][2]);
  }
  leds.show();
}

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j++) {
    for(i=0; i<leds.numPixels(); i++) {
      leds.setPixelColor(i, Wheel((i+j) & 255));
    }
    leds.show();
    delay(wait);
  }
}

uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
   return leds.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else if(WheelPos < 170) {
    WheelPos -= 85;
   return leds.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  } else {
   WheelPos -= 170;
   return leds.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}

int sensorVal(int pin) {
  int val = analogRead(pin);
  if(val > 96 && val < 196) {
    return 0;
  } else if (val >= 243 && val <= 343) {
    return 1;
  } else if (val >= 389 && val <= 489) {
    return 2;
  } else if (val >= 535 && val <= 635) {
    return 3;
  } else if (val >= 681 && val <= 781) {
    return 4;
  } else if (val >= 828 && val <= 928) {
    return 5;
  } else {
    return 6;
  }
}

//
//
//int[] randomInts(int amount) {
//  int numbers[amount];
//  for (int i = 0; i < amount; i++) {
//    numbers[i] = i;
//  }
//  int shuffle[amount];
//  for (int i = 0; i < amount; i++) {
//    rand = random(0,amount - i);
//  }
//}

