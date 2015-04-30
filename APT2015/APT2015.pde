import controlP5.*;
import processing.serial.*;
import javax.swing.*;
SecondApplet sScreen;
tableOfStrings1 ranking;

void setup() {

  size(1200, 786);

  PFrame f = new PFrame(500, 786);
  f.setTitle("Timer");
  fill(0);


  if (frame != null) {
    frame.setResizable(true);
  }

  frameRate(30);
  index = 0;

  loadFiles();

  //Start serial comms and initialise
  serial = startSerial();

  //Create fonts
  f1 = createFont("Calibri", 50);
  f2 = createFont("Calibri Bold", 20);
  f3 = createFont("Calibri Bold", 17);
  f4 = createFont("Arial Unicode MS", 15);
  f6 = createFont("Arial Unicode MS", 12);

  setupCP5();

  //  boolean max = false;
  //  ranking = new tableOfStrings1();
  //  ranking.setSorting(true, max);
  //  ranking.setColoured(true);
  //  ranking.init(data, 226, columGap, 24, index, names);

  int tableHeight = 226;
  rowHeights = new int[arrayLength];
  for (int i = 0; i < rowHeights.length; i++) {
    rowHeights[i] = tableHeight + (i * 20);
  }

  sScreen.resetTimer();
  sScreen.resetTimer1();

  mode = 10; //Resets the mode to the start as the button callback is triggered during setup of buttons
  stop = false;
  first = false;
}

void draw() {

  background(0);
  frame.setTitle("Apocalypse Party 2015. FPS = " + int(frameRate));

  control();
  mimicLights();

  //Text
  fill(255);
  textFont(f1);
  textAlign(CENTER);
  text("Current Session", width/2, 50);
  text("Ranking", width/2, 180);

  alternatingBars(index, 25);

  //Text for Headings and Current Session
  fill(255);
  textFont(f2);
  textAlign(CENTER);  

  rowOfText(headings, columGap, headingHeight);
  rowOfText(currentSesh, columGap, currentSeshHeight);

  //Text for ranking table
  displayMainTable(data);
}


/*
To-do list
 
 Add penalty bits data point and display
 
 
 */
