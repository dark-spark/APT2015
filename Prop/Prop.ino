#include <Adafruit_NeoPixel.h>

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

const int numOfPixels = 6;

const int floatingPin = A0;
const int AI0 = A1;
const int AI1 = A2;
const int AI2 = A3;
const int AI3 = A4;
const int AI4 = A5;
const int AI5 = A6;
const int ledPin = 2;
const int canPin = 3;
const int buttonPin = 4;
const int buttonPin1 = 5;
const int data0 = 6;
const int data1 = 7;
const int data2 = 8;
const int clk = 9;
const int enableShootingRange = 10;

int r;
boolean score[numOfPixels];
int numCorrect = 0;
int mode = 0;

Adafruit_NeoPixel leds = Adafruit_NeoPixel(numOfPixels, ledPin, NEO_GRB + NEO_KHZ800);

void setup(){
  
  leds.begin();
  leds.show();
  
  randomSeed(analogRead(floatingPin));

  Serial.begin(9600);
  
  pinMode(canPin, INPUT_PULLUP);
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(buttonPin1, INPUT_PULLUP);
  
  pinMode(data0, OUTPUT);
  pinMode(data1, OUTPUT);
  pinMode(data2, OUTPUT);
  pinMode(clk, OUTPUT);
  pinMode(enableShootingRange, OUTPUT);

}

void loop(){
//  for(int i = 0; i < 7; i++) {
//    transmit(i);
//    Serial.println("");
//  }
//  delay(1000);
  while(digitalRead(canPin == LOW)) {
    switch(mode) {
      case 0: //Display Random Colors
        numCorrect = 0;
        r = random(30);
        displayRand(5000);
        mode = 1;
        break;
      case 1: //Wait for button press
        if(digitalRead(buttonPin) == LOW) {
          mode = 2;
        }
        break;
      case 2: //Check sensors and Display pass or fail
//        score[numOfPixels] = checkConnections();
//        for(int i = 0; i < numOfPixels; i++) {
//          leds.setPixelColor(i, colors[bools[i]][0], colors[bools[i]][1], colors[bools[i]][2]);
//        }
//        leds.show();
//        mode = 3;
        break;
      case 3: //Transmit data
        
        break;
    }
  }
  rainbow(20);
}

void transmit(int score) {
  digitalWrite(data0, score & 1 ? HIGH : LOW);
  Serial.println(score & 1 ? "HIGH" : "LOW");
  digitalWrite(data1, score & 2 ? HIGH : LOW);
  Serial.println(score & 2 ? "HIGH" : "LOW");
  digitalWrite(data2, score & 4 ? HIGH : LOW);
  Serial.println(score & 4 ? "HIGH" : "LOW");
  digitalWrite(clk, HIGH);
  delay(100);
  digitalWrite(clk, LOW);
}
//
//boolean[] checkConnections() {
//  int vals[numOfPixels];
//  boolean bools[numOfPixels];
//  vals[0] = sensorVal(AI1);
//  vals[1] = sensorVal(AI2);
//  vals[2] = sensorVal(AI3);
//  vals[3] = sensorVal(AI4);
//  vals[4] = sensorVal(AI5);
//  vals[5] = sensorVal(AI6);
//  for(int i = 0; i < numOfPixels; i++) {
//    if(vals[i] == randoms[r][i]) {
//      bools[i] = 1;
//      numCorrect++;
//    } else {
//      bools[i] = 0;
//    }
//  }
//  return bools[];
//}
  
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

void displayRand(int wait) {
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


