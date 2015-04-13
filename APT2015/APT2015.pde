import controlP5.*;
import processing.serial.*;
import javax.swing.*;
SecondApplet sScreen;
tableOfStrings ranking;

void setup() {

  size(1200, 786);

  PFrame f = new PFrame(1024, 786);
  f.setTitle("Timer");
  fill(0);

  ranking = new tableOfStrings();

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

  //Set up listbox
  cp5 = new ControlP5(this);
  l = cp5.addListBox("myList")
    .setPosition(6, 21)
      .setSize(120, 200)
        .setItemHeight(15)
          .setBarHeight(15)
            .setColorBackground(color(255, 255, 255))
              .setColorActive(color(50))
                .setColorForeground(color(255, 100, 100))
                  .setColorLabel(color(0))
                    .actAsPulldownMenu(true);
  ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Select a Name");
  l.captionLabel().setColor(#000000);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;

  for (int i=0; i< nameString.length; i++) {
    ListBoxItem lbi = l.addItem(names[i], i);
    lbi.setColorBackground(#EAEAEA);
  }

  //Fill array for min times
  for (int i = 0; i < 9; i++) {
    min[i] = 2147483647;
  }  

  //Fill array for times times
  for (int i = 0; i < 6; i++) {
    timeArray[i] = "1";
  }

  if (salesForce) {
    salesForceLogin();
  }

  sScreen.resetTimer();
}

boolean sorted = false;
String[] currentSesh = {
  "", 
  "", 
  "", 
  "", 
  "", 
  "", 
  ""
};

String[] headings = {
  "Name", 
  "Obstacle Course", 
  "Smash and Grab", 
  "Obstacle Course", 
  "Zombies", 
  "Ammo Used", 
  "Total Time"
};

void draw() {

  background(0);
  frame.setTitle("Apocalypse Party 2015. FPS = " + int(frameRate));

  int columGap = 150;
  int headingHeight = 96;
  int currentSeshHeight = 120;

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
  boolean max = false;
  ranking.init(data, 226, columGap, 24); //Only triggered once
  if (!sorted) {
    ranking.sortResults(max);
  }
  ranking.colorResults(max);
  ranking.display();

  if (updateTimer) {
    timer = millis();
  }
}
