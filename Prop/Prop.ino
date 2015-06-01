#include <Adafruit_NeoPixel.h>
#include <LedControl.h>
#include <TimerOne.h>

int colors[][3] = {
  {
    255, 0, 0      }
  ,
  {
    0, 255, 0      }
  ,
  {
    0, 0, 255      }
  ,
  {
    255, 255, 0      }
  ,
  {
    255, 100, 0      }
  ,
  {
    255, 0, 255      }
  ,
  {
    0, 0, 0      }
};

int randoms[31][6] = {
  {
    0,1,2,3,4,5      }
  ,
  {
    5,4,3,2,1,0      }
  ,
  {
    5,0,3,2,1,4      }
  ,
  {
    1,0,5,2,4,3      }
  ,
  {
    5,3,0,4,1,2      }
  ,
  {
    1,0,3,4,5,2      }
  ,
  {
    3,5,0,2,1,4      }
  ,
  {
    0,3,1,5,2,4      }
  ,
  {
    2,5,0,3,4,1      }
  ,
  {
    4,2,0,1,5,3      }
  ,
  {
    5,1,0,4,2,3      }
  ,
  {
    1,0,2,5,3,4      }
  ,
  {
    0,1,5,4,2,3      }
  ,
  {
    1,0,3,5,4,2      }
  ,
  {
    0,4,3,1,5,2      }
  ,
  {
    4,0,5,1,2,3      }
  ,
  {
    3,2,5,1,4,0      }
  ,
  {
    0,2,1,3,5,4      }
  ,
  {
    2,4,3,0,1,5      }
  ,
  {
    1,5,4,2,0,3      }
  ,
  {
    0,4,5,3,2,1      }
  ,
  {
    4,0,3,2,5,1      }
  ,
  {
    3,5,2,4,1,0      }
  ,
  {
    3,4,5,2,0,1      }
  ,
  {
    1,5,4,2,3,0      }
  ,
  {
    5,4,3,1,0,2      }
  ,
  {
    2,4,0,5,1,3      }
  ,
  {
    0,2,1,3,5,4      }
  ,
  {
    0,1,5,2,4,3      }
  ,
  {
    0,5,2,4,3,1      }
  ,
  {
    4,0,3,2,1,5      }
};

const int floatingPin = A6;
const int red = A0;
const int gree = A1;
const int blue = A2;
const int yell = A3;
const int oran = A4;
const int pink = A7;
const int buttonLight = A5;
const int ledPin = 2;
const int canPin = 3;
const int buttonPin = 4;
const int buttonPin1 = 5;
const int data0 = 6;
const int data1 = 7;
const int data2 = 8;
const int clk = 9;
const int enableShootingRange = 10;
const int digitDINPin = 11;
const int digitCLKPin = 13;
const int digitLoadPin = 12;

const int numOfPixels = 6;

int r;
boolean score[numOfPixels];
int numCorrect = 0;
int mode = 0;
unsigned long time0, time1, time2, time3;
//int d0, d1, d2, d3;
int time;
int countDownTime = 500;
boolean colon = true;
boolean blinker = true;

Adafruit_NeoPixel leds = Adafruit_NeoPixel(numOfPixels, ledPin, NEO_GRB + NEO_KHZ800);

LedControl digit = LedControl(digitDINPin, digitCLKPin, digitLoadPin, 1);

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
  pinMode(buttonLight, OUTPUT);

  digit.shutdown(0,false);
  digit.setIntensity(0,8);
  digit.clearDisplay(0);

  Timer1.initialize(10000);

}

void loop(){

  while (digitalRead(canPin) == LOW) { 

    switch(mode) {

    case 0: //Set clock display
      updateDigit(countDownTime);
      displayNothing();
      mode = 1;
      break;

    case 1: //Switch is off
      if(digitalRead(buttonPin1) == HIGH) {
        mode = 2;
      }
      break;

    case 2: //Switch is on
      if(digitalRead(buttonPin1) == LOW) {
        mode = 4;
      }
      break;

    case 4:  //Display Random Colours
      time0 = millis();
      numCorrect = 0;
      r = random(30);
//      r=0;
      displayRand();
      mode = 5;
      time = countDownTime;
      Timer1.attachInterrupt(decrement);
      break;

    case 5:
      //Wait for counter to finish decrement() will move to next mode
      break;

    case 10: //Clear display
      displayNothing();
      time2 = millis();
      blinker = true;
      digitalWrite(buttonLight, blinker);
      mode = 20;
      break;

    case 20: //Wait for button press
      if(digitalRead(buttonPin) == LOW) {
        digitalWrite(buttonLight, HIGH);
        mode = 30;
        break;
      }
      time3 = millis() - time2;
      if(time3 >= 250) {
        blinker = !blinker;
        digitalWrite(buttonLight, blinker);
        time2 = millis();
      }
      break;

    case 30: //Check sensors and Display pass or fail
      checkConnections(score);
      displayScore();
      mode = 40;
      break;

    case 40: //Transmit data
      transmit(numCorrect);
      Serial.println(numCorrect);
      digitalWrite(enableShootingRange, HIGH);
      mode = 50;
      break;

    case 50:
      break;
    }
  }
  mode = 0;
  Timer1.detachInterrupt();
  transmit(0);
  digitalWrite(enableShootingRange, LOW);
  updateDigit(500);
  rainbowCycle(20);
}

void updateDigit(int value) {

  int d0 = value % 10;
  int d1 = (((value - d0) / 10) % 10);
  int d2 = (((value - d0 - (d1 * 10)) / 100) % 10);
  int d3 = (((value - d0 - (d1 * 10) - (d2 * 100)) / 1000) % 10);

  if(d1 == 5) {
    colon = false;
  } 
  else if (d1 == 0) {
    colon = true;
  }

  digit.clearDisplay(0);  
  digit.setDigit(0,4,d0,false);
  digit.setDigit(0,5,d1,false);
  digit.setDigit(0,6,d2,colon);
  digit.setDigit(0,7,d3,false);

}

void decrement() {
  time--;
  updateDigit(time);
  if(time <= 0) {
    mode = 10;
    Timer1.detachInterrupt();
  }
}

void transmit(int i) {
  digitalWrite(data0, i & 1 ? HIGH : LOW);
  digitalWrite(data1, i & 2 ? HIGH : LOW);
  digitalWrite(data2, i & 4 ? HIGH : LOW);
  delay(10);
  digitalWrite(clk, HIGH);
  delay(1000);
  digitalWrite(clk, LOW);
}

void checkConnections(boolean bools[]) {
  int vals[numOfPixels];
  vals[0] = sensorVal(red);
  vals[1] = sensorVal(gree);
  vals[2] = sensorVal(blue);
  vals[3] = sensorVal(yell);
  vals[4] = sensorVal(oran);
  vals[5] = sensorVal(pink);
  Serial.println("checkConnections");
  for(int i = 0; i < numOfPixels; i++) {
    Serial.println(vals[i]);
    if(vals[i] == randoms[r][i]) {
      bools[i] = 1;
      numCorrect++;
    } 
    else {
      bools[i] = 0;
    }
  }
}

int sensorVal(int pin) {
  int val = analogRead(pin);
  Serial.print("SensorVal/npin: ");
  Serial.println(pin);
  Serial.print("Val: ");
  Serial.println(val);
  if(val > 96 && val < 196) {
    return 0;
  } 
  else if (val >= 243 && val <= 343) {
    return 1;
  } 
  else if (val >= 389 && val <= 489) {
    return 2;
  } 
  else if (val >= 535 && val <= 635) {
    return 3;
  } 
  else if (val >= 681 && val <= 781) {
    return 4;
  } 
  else if (val >= 828 && val <= 928) {
    return 5;
  } 
  else {
    return 6;
  }
}

void displayScore() {
  for(int i = 0; i < numOfPixels; i++) {
    leds.setPixelColor(i, colors[score[i]][0], colors[score[i]][1], colors[score[i]][2]);
  }
  leds.show();
}

void displayRand() {
  Serial.println("displayRand");
  for(int i = 0; i < numOfPixels; i++) {
    Serial.println(randoms[r][i]);
    leds.setPixelColor(numOfPixels-i-1, colors[randoms[r][i]][0], colors[randoms[r][i]][1], colors[randoms[r][i]][2]);
  }
  leds.show();
}

void displayNothing() {
  for(int i = 0; i < leds.numPixels(); i++) {
    leds.setPixelColor(i, colors[6][0], colors[6][1], colors[6][2]);
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
    if(digitalRead(canPin) == LOW) {
      break;
    }
    delay(wait);
  }
}

uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
    return leds.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } 
  else if(WheelPos < 170) {
    WheelPos -= 85;
    return leds.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  } 
  else {
    WheelPos -= 170;
    return leds.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}

void rainbowCycle(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256*5; j++) { // 5 cycles of all colors on wheel
    for(i=0; i< leds.numPixels(); i++) {
      leds.setPixelColor(i, Wheel(((i * 256 / leds.numPixels()) + j) & 255));
    }
    leds.show();
    if(digitalRead(canPin) == LOW) {
      break;
    }
    delay(wait);
  }
}





