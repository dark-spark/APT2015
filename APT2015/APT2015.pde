import controlP5.*;
import processing.serial.*;
import javax.swing.*;
SecondApplet s;

void setup() {
  
  size(1024, 786);

  PFrame f = new PFrame(width, height);
  frame.setTitle("Apocalypse Party 2015");
  f.setTitle("second window");
  fill(0);
  
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(100);
  frame.setTitle("Apocalypse Party 2015");
  index = 0;

  loadFiles();

  //Start serial comms and initialise
  serial = startSerial();
  if (serial) {
    myPort.write("redOFF.greenOFF.blueOFF.yellowOFF.");
  }

  //Create fonts
  f1 = createFont("Calibri", 50);
  f2 = createFont("Calibri Bold", 20);
  f3 = createFont("Calibri Bold", 17);
  f4 = createFont("Arial Unicode MS", 15);
  f5 = createFont("Arial Unicode MS", 15);
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
                  .setColorLabel(color(0));
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
}

void draw() {
  
  background(0);
  sortResults();
  create();
  mimicLights();

  switch(mode) {
  case 0:  //Set lights for initial position, no barcode set
    redOFF();
    greenOFF();
    blueOFF();
    yellowOFF();
    whiteON();
    mode = 1;
    jumpStart = false;
    time2 = millis();
    break;

  case 1: //Check for barcode or name clicked, while waiting ping uC every 2 seconds to make sure its still alive.
    if (nameSet) {
      mode = 2;
      tone3ON();
      break;
    }
    if (millis() - time2 > 5000) {
      heartbeat = !heartbeat;
      if (!ping()) {
        mode = 11;
        heartbeat = false;
      }
      time2 = millis();
    }
    if (noReceived) {
      mode = 12;
    }
    //Heartbeat
    if (heartbeat) {
      drawPixelArray(bigHeart, red, 1200, 20, 2);
    } else { 
      drawPixelArray(smallHeart, red, 1200, 20, 2);
    }
    break;

  case 12: //Sensor Blocked
    whiteOFF();
    if (millis() - time2 > 2000) {
      heartbeat = !heartbeat;
      if (!ping()) {
        mode = 11;
        heartbeat = false;
      }
      time2 = millis();
    }
    if (yesReceived) {
      mode = 0;
    }
    if (noReceived) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      textSize(200);
      text("Sensor", 200, 200);
      text("Blocked", 200, 350);
      String match[] = match(blockedSensors, "1");
      if (match != null) {  
        text("1", 100, 500);
      }
      match = match(blockedSensors, "2");
      if (match != null) {  
        text("2", 200, 500);
      }
      match = match(blockedSensors, "3");
      if (match != null) {  
        text("3", 300, 500);
      }
      match = match(blockedSensors, "4");
      if (match != null) {  
        text("4", 400, 500);
      }
      match = match(blockedSensors, "5");
      if (match != null) {  
        text("5", 500, 500);
      }
    }
    //Heartbeat
    if (heartbeat) {
      drawPixelArray(bigHeart, red, 1200, 20, 2);
    } else { 
      drawPixelArray(smallHeart, red, 1200, 20, 2);
    }
    break;
    
  case 2:  //Barcode set
    reset();
    blueON();
    whiteOFF();
    mode = 10;
    countDown = millis();
    if (!pNameSet) {
      pName = name;
      pBarcode = barcode;
      pNameSet = true;
    }
    break;
  case 10: //Timer for run up
    if (millis() - countDown > runUpTimer) {
      mode = 3;
    }
    if (serialData) {
      jumpStart = true;
      mode = 9;
      flash = true;
      toneFalseStart();
      serialData = true;
    }
    break;
  case 3: //Flash run up light and tones.
    if (serialData) {
      jumpStart = true;
      mode = 9;
      toneFalseStart();
      flash = true;
    }
    if (millis() - lightTimer > toneTime) {
      lightTimer = millis();
      lightFlash++;
    }
    if (lightFlash % 2 == 1) {
      blueON();
      tone1ON();
    } else {
      blueOFF();
    }
    if (millis() - countDown > runUpTimer1) {
      mode = 4;
      lightFlash = 0;
    }
    break;
  case 4:  //Set lights
    blueOFF();
    greenON();
    tone2ON();
    reactionTime0 = millis();
    nameSet = false;
    running = true;
    mode = 6;
    break;
  case 5:
    break;
  case 6:  //Recieve Data
    if (serialData) {
      if (sectorIndex == 0) {
        reactionTime = millis() - reactionTime0;
        count++;
      } else {
        if (sectorIndex == 1) {
          String trapTime = inData[0];
          String trapTime1 = trapTime.substring(2);
          timeArray[sectorIndex] = str(time1);
          timeArray[0] = trapTime1;
          count = count+2;
        } else {
          timeArray[sectorIndex] = str(time1);
          count++;
        }
      }
      serialData = false;
      sectorIndex++;
      greenOFF();
      yellowON();
    }

    if (sectorIndex >= 5) {
      sectorIndex = 0;
      pNameSet = false;
      running = false;

      String match[] = match("Mugen", name);
      if (match != null) {
        formatPostData(mugenMulti);
      } else {
        formatPostData(1);
      }

      fillData();
      redOFF();
      greenOFF();
      blueOFF();
      yellowON();
      index++;
      writeTextFile();
      count = 0;
      mode = 8;
    }

    if (jumpStart) {
      mode = 9;
      toneFalseStart();
      flash = true;
    }
    break;
  case 7:
    break;
  case 8:  //Send Data
    if (data[index -  1][8] <= min[8]) {
      play1upTone();
    }
    if (salesForce) {
      salesForceSendData();
    }
    mode = 0;
    break;
  case 9:  //Jump start

    nameSet = false;
    running = true;

    if (serialData) {
      if (sectorIndex == 0) {
        reactionTime = millis() - countDown - runUpTimer1;
        count++;
      } else {
        if (sectorIndex == 1) {
          String[] split = split(inData[0], " ");
          timeArray[sectorIndex] = str(time1);
          timeArray[0] = split[1];
          count = count+2;
        } else {
          timeArray[sectorIndex] = str(time1);
          count++;
        }
      }
      serialData = false;
      sectorIndex++;
      greenOFF();
      redON();
    }

    blueOFF();

    if (flash) {
      if (millis() - lightTimer > 100) {
        lightTimer = millis();
        lightFlash++;
      }
      if (lightFlash % 2 == 1) {
        redON();
      } else {
        redOFF();
      }
      if (lightFlash > 10) {
        flash = false;
        lightFlash = 0;
        redON();
      }
    }

    if (sectorIndex >= 5) {
      sectorIndex = 0;
      pNameSet = false;
      running = false;
      if (name.equals("Mugen")) {
        formatPostData(mugenMulti);
      } else {
        formatPostData(1);
      }
      fillData();
      redOFF();
      greenOFF();
      blueOFF();
      yellowON();
      index++;
      writeTextFile();
      count = 0;
      mode = 8;
    }
    break;

  case 11:
    pingFailed = true;
    if (millis() - time2 > 1000) {
      if (ping()) {
        pingFailed = false;
        mode = 0;
      }
      time2 = millis();
    }
    drawPixelArray(brokenHeart, red, 1200, 20, 2);

    stroke(255, 0, 0);
    fill(255, 0, 0);
    textSize(300);
    if (yesReceived) {
      text("Ping \nFailed", 350, 250);
    }
    break;
  }

  frame.setTitle("Apocalypse Party 2015. FPS = " + int(frameRate));

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
        time1 = millis() - time0;
        time0 = millis();
        serialData = true;
        inData[0] = "t 100";

    if (mouseX > boxX1 && mouseX < boxX1+boxSize && mouseY >boxY1 && mouseY < boxY1+boxSize) {
      reset();
    }
  }
}
