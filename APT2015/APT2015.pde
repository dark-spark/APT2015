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

  frameRate(10);
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

  l.captionLabel()
    .toUpperCase(true)
      .set("Select a Name")
        .setColor(#000000)
          .style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;

  for (int i=0; i< nameString.length; i++) {
    ListBoxItem lbi = l.addItem(names[i], i);
    lbi.setColorBackground(#EAEAEA);
  }

  ControlFont cFont = new ControlFont(f2);

  startButton = cp5.addButton("Start")
    .setValue(0)
      .setPosition(1100, 20)
        .setSize(60, 25)
          .setId(0)
            .activateBy(ControlP5.RELEASE)
              .hide()
                ;

  startButton.captionLabel()
    .setFont(cFont)
      .setSize(20)
        .toUpperCase(false)
          .align(ControlP5.CENTER, ControlP5.CENTER)
            ;

  lcsgButton = cp5.addButton("LCSG")
    .setPosition(1000, 20)
      .setSize(60, 25)
        .setId(1)
          .hide()
            ;

  lcsgButton.captionLabel()
    .setFont(cFont)
      .setSize(20)
        .toUpperCase(false)
          .align(ControlP5.CENTER, ControlP5.CENTER)
            ;

  dfrButton = cp5.addButton("DFR")
    .setPosition(1100, 20)
      .setSize(60, 25)
        .setId(1)
          .hide()
            ;

  dfrButton.captionLabel()
    .setFont(cFont)
      .setSize(20)
        .toUpperCase(false)
          .align(ControlP5.CENTER, ControlP5.CENTER)
            ;

  pbrButton = cp5.addButton("PBR")
    .setPosition(900, 20)
      .setSize(60, 25)
        .setId(1)
          .hide()
            ;

  pbrButton.captionLabel()
    .setFont(cFont)
      .setSize(20)
        .toUpperCase(false)
          .align(ControlP5.CENTER, ControlP5.CENTER)
            ;

  sScreen.resetTimer();

  mode = 10; //Resets the mode to the start as the button callback is triggered during setup of button
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
boolean initRankingTable = false;
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
  if (!initRankingTable) {
    ranking.init(data, 226, columGap, 24); //Only triggered once
  }
  if (!sorted) {
    ranking.pushSortResults(max);
  }
  ranking.colorResults(max);
  ranking.display();

  if (updateTimer) {
    timer = millis();
  }
}
