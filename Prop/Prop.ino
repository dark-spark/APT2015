#include <Adafruit_NeoPixel.h>


void setup(){

//Initialise Sensor input pins

	pinMode(6, INPUT);		//Light Curtain 

	pinMode(CH1, INPUT); 	// Channel 1
	pinMode(CH2, INPUT); 	// Channel 2
	pinMode(CH3, INPUT); 	// Channel 3
	pinMode(CH4, INPUT); 	// Channel 4
	pinMode(CH5, INPUT); 	// Channel 5
	pinMode(CH6, INPUT); 	// Channel 6 (Spare)

//Initialise Stack Light output pins
	pinMode(8, OUTPUT); 	//top
	pinMode(9, OUTPUT);
	pinMode(10, OUTPUT);
	pinMode(11, OUTPUT);
	pinMode(12, OUTPUT); 	//Bottom
	
//Initialise Serial
	Serial.begin(9600);

void loop(){


}

int[] randomInts(int amount) {
  int numbers[amount];
  for (int i = 0; i < amount; i++) {
    numbers[i] = i;
  }
  int shuffle[amount];
  for (int i = 0; i < amount; i++) {
    rand = random(0,amount - 1);
    
}

