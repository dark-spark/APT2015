#include <Adafruit_NeoPixel.h>

int floatingPin = A0;
//const int AI0 = A1;
//const int AI1 = A2;
//const int AI2 = A3;
//const int AI3 = A4;
//const int AI4 = A5;
//const int AI5 = A6;
const int ledPin = 2;
const int numOfPixels = 6;

uint32_t red, green, blue, magenta, cyan, yellow, off;
uint32_t colors[7];

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
  
  uint32_t red = leds.Color(255, 0, 0);
  uint32_t green = leds.Color(0, 255, 0);
  uint32_t blue = leds.Color(0, 0, 255);
  uint32_t magenta = leds.Color(255, 0, 255);
  uint32_t cyan = leds.Color(0, 255, 255);
  uint32_t yellow = leds.Color(255, 255, 0);
  uint32_t off = leds.Color(0, 0, 0);
  uint32_t colors[] = {red, green, blue, magenta, cyan, yellow, off};
  
  leds.begin();
  leds.show();
  
  randomSeed(analogRead(floatingPin));

  Serial.begin(9600);

}


void loop(){
  displayRand(500);
}

void displayRand(int wait) {
  int r = random(30);
  for(int i = 0; i < numOfPixels; i++) {
    leds.setPixelColor(i, colors[randoms[r][i]]);
  }
  leds.show();
  delay(wait);
  for(int i = 0; i < numOfPixels; i++) {
    leds.setPixelColor(i, off);
  }
  leds.show();
}

//int sensorVal(int pin) {
//  int val = analogRead(pin);
//  if(val > 96 && < 196) {
//    return 0;
//  } else if (val >= 243 && <= 343) {
//    return 1;
//  } else if (val >= 389 && <= 489) {
//    return 2;
//  } else if (val >= 535 && <= 635) {
//    return 3;
//  } else if (val >= 681 && <= 781) {
//    return 4;
//  } else if (val >= 828 && <= 928) {
//    return 5;
//  } else {
//    return 6;
//  }
//}

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

