import controlP5.*;
import processing.serial.*;
import javax.swing.*;
SecondApplet sScreen;
tableOfStrings currentSession;
tableOfStrings ranking;

void setup() {

  size(1200, 786);

  PFrame f = new PFrame(1024, 786);
  f.setTitle("Timer");
  fill(0);

  currentSession = new tableOfStrings();
  ranking = new tableOfStrings();
  
  if (frame != null) {
    frame.setResizable(true);
  }

  frameRate(100);
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

void draw() {

  background(0);
//  sortResults();
  create();

  frame.setTitle("Apocalypse Party 2015. FPS = " + int(frameRate));

  if (updateTimer) {
    timer = millis();
  }

  //  stroke(225);
  //   fill(225);
  //   rectMode(CORNER);
  //   rect(0, 0, 500, 20); 
  //   fill(0);
  //   textFont(f6);
  //   text(mouseX, 130, 20);
  //   text(mouseY, 160, 20);
  //   text(mouseX - valueX, 190, 20);
  //   text(mouseY - valueY, 220, 20);
}

void keyPressed() {

  valueX = mouseX;
  valueY = mouseY;

  if (key == '\n' || keyCode == RETURN || keyCode == ENTER) {
    if (barcodeGood(typing)) {
      player = typing;
      typing = "";
      for (int i = 0; i < barcodes.length; i++) {
        if (player.equals(barcodes[i]) && mode == 1 && !(player.equals("00"))) {
          firstClick = false;
          int selection = i;
          l.captionLabel().set(names[selection]);
          data[index][0] = selection;
          name = names[int(data[index][0])];
          barcode = barcodes[selection];
          count = 0;
          nameSet = true;
        }
      }
    }
  } else {
    typing = typing + key;
  }

  if (typing.length() > 2) {
    typing = typing.substring(1);
  }
}

void mousePressed() {
  //Check if Mouse is over button and toggle on
  if (mouseX > boxX && mouseX < boxX+boxSize && mouseY >boxY && mouseY < boxY+boxSize) {
//    if (sortFastest) {
//      sortFastest = false;
//      c3 = c2;
//    } 
//    else {
//      sortFastest = true;
//      c3 = c1;
//    }
//    test = !test;
//    if (test) {
//      sScreen.startTimer();
//    } else {
//      sScreen.stopTimer();
//    }
  }


  if (mouseX > boxX1 && mouseX < boxX1+boxSize && mouseY >boxY1 && mouseY < boxY1+boxSize) {
    sScreen.resetTimer();
  }
}
