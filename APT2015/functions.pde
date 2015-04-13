
void control() {
  switch(mode) {

  case 10:
    redON();
    if (nameSet) {
      mode = 20;
      currentSesh[0] = name;
      startButton.show();
    }
    break;

  case 20:
    //Wait for start button to be pressed, start() will advance to next mode
    break;

  case 30:

    redOFF();
    greenON();
    time0 = millis();
    sScreen.startTimer();
    mode = 40;
    break;

  case 40:
    startButton.hide();
    lcsgButton.show();
    mode = 60;
    break;

  case 60: //First obstacle course
    if (serialData) {
      redON();
      greenOFF();
      float t = float(sScreen.getTime());
      currentRun[0] = t;
      float ft = t/1000;
      currentSesh[1] = String.format("%.2f", ft);
      resetSerialData();
      pbrButton.show();
      lcsgButton.hide();
      mode = 70;
    }
    break;

  case 70: //Smash and grab
    if (serialData) {
      float t = float(sScreen.getTime());
      currentRun[1] = t - currentRun[0];
      float ft = (t/1000) - currentRun[0]/1000;
      currentSesh[2] = String.format("%.2f", ft);
      resetSerialData();
      dfrButton.show();
      lcsgButton.show();
      pbrButton.hide();
      mode = 80;
    }
    break;

  case 80:
    if (serialData) {
      if (lcsg) {
        obstacleCourse = true;
        resetSerialData();
        lcsgButton.hide();
        mode = 90;
        break;
      } else if (dfr) { //If zombie run this should trigger, only dfr should be hit, with out lcsg.
        float t = float(sScreen.getTime());
        currentRun[3] = t - currentRun[1] - currentRun[0];
        float ft = (t/1000) - currentRun[1]/1000 - currentRun[0]/1000;
        currentSesh[4] = String.format("%.2f", ft);
        resetSerialData();
        hideAllButtons();
        mode = 100;
      }
    }
    break;

  case 90: //If obstacle course run this should trigger.
    if (serialData) {
      float t = float(sScreen.getTime());
      currentRun[2] = t - currentRun[0] - currentRun[1];
      float ft =(t/1000) - currentRun[0]/1000 - currentRun[1]/1000;
      currentSesh[3] = String.format("%.2f", ft);
      resetSerialData();
      hideAllButtons();
      mode = 100;
    }
    break;

  case 100:
    sScreen.stopTimer();
    float t = float(sScreen.getTime());
    currentRun[5] = t;
    t /= 1000;
    currentSesh[6] = String.format("%.2f", t);
    data = appendArray(currentRun, data, index);
    ranking.pushNewData(data);
    mode = 110;
    nameSet = false;
    break;

  case 110:
    //Wait for name to be set
    if (nameSet) {
      mode = 10;
      sScreen.resetTimer();
    }
  }
} 

public float[][] appendArray(float[] newData, float[][] da, int ind) {
  float[][] d = new float[da.length][da[0].length];
  d[index] = newData;
  index++;
  return d;
}

public void resetSerialData() {
  serialData = false;
  lcsg = false;
  dfr = false;
  pbr = false;
}

public void hideAllButtons() {
  lcsgButton.hide();
  pbrButton.hide();
  dfrButton.hide();
  startButton.hide();
}

public void Start(int theValue) {
  mode += 10;
}

public void LCSG(int theValue) {
  lcsg = true;
  serialData = true;
}

public void DFR(int theValue) {
  dfr = true;
  serialData = true;
}

public void PBR(int theValue) {
  pbr = true;
  serialData = true;
}

void delay(int delay) {

  int time = millis();
  while (millis () - time <= delay);
}

void drawPixelArray(int[][] image, color color1, int posx, int posy, int multiplier) {

  fill(color1);
  stroke(color1);

  for (int i = 0; i < image[0].length; i++) {
    for (int j = 0; j < image.length; j++) {
      if (image[j][i] > 0) {
        rect((i*multiplier) + posx, (j*multiplier) + posy, multiplier, multiplier);
      }
    }
  }
}

void mimicLights() {

  //Text for current mode for the swtich
  textFont(f2);
  stroke(255);
  text(mode, 20, 350);

  //Mimic lights
  noStroke();
  ellipseMode(CORNER);
  if (redON) {
    fill(255, 0, 0);
  } else { 
    fill(50, 0, 0);
  }
  ellipse(20, 360, 40, 40);

  if (greenON) {
    fill(0, 255, 0);
  } else {
    fill(0, 50, 0);
  }
  ellipse(20, 410, 40, 40);
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup() && theEvent.name().equals("myList")) {
    selection = (int)theEvent.group().value();
    updateName();
  }
}

void updateName() {

  firstClick = false;
  l.captionLabel().set(names[selection]);
  data[index][0] = selection;
  name = names[int(data[index][0])];
  nameSet = true;
}


void fillData() {

  for (int i = 0; i < 9; i++) {
    data[index][i] = float(postData[i]);
  }
}

void alternatingBars(int count, int max) {

  int w = 1000;

  //Alternating Bars    
  fill(40);
  stroke(40);
  rectMode(CENTER);

  for (int i = 1; i < count + 1 && i < max; i = i + 2) {
    rect(width/2, (201 + (i * 20)), w, 19, 7);
  }

  rect(width/2, 114, w, 24, 7);
}

void rowOfText(String[] text, int colSpacing, int hheight) {

  float numOfCols = text.length;
  int ceil = ceil(numOfCols / 2);

  for (int i = 0; i < numOfCols; i++) {
    text(text[i], width/2 + (colSpacing * (i - numOfCols + ceil)), hheight);
  }
}

void rowOfText(String[] text, int colSpacing, int hheight, color[] colors) {

  float numOfCols = text.length;
  int ceil = ceil(numOfCols / 2);

  for (int i = 0; i < numOfCols; i++) {
    fill(colors[i]);
    text(text[i], width/2 + (colSpacing * (i - numOfCols + ceil)), hheight);
  }
} 

String[][] create2dArray(float[][] data, int a, int b, int c, int max) {

  String[][] string;
  if (b-a < max) {
    string = new String[b-a][c];
    for (int i = a; i < b; i++) {
      string[i][0] = names[int(data[i][0])];
      for (int j = 1; j < c; j++) {
        string[i][j] = String.format("%.2f", (data[i][j]));
      }
    }
    return string;
  } else {
    string = new String[max][c];
    for (int i = a; i < max + a; i++) {
      string[i][0] = names[int(data[i][0])];
      for (int j = 1; j < c; j++) {
        string[i][j] = String.format("%.2f", (data[i][j]));
      }
    }
    return string;
  }
}

int[][] whiteColor2dArray(int a, int b) {
  int[][] array = new int[a][b];
  for (int i = 0; i < a; i++) {
    for (int j = 0; j < b; j++) {
      array[i][j] = color(255, 255, 255);
    }
  }
  return array;
}

void mousePositionDisplay() {
  stroke(225);
  fill(225);
  rectMode(CORNER);
  rect(0, 0, 500, 20); 
  fill(0);
  textFont(f6);
  text(mouseX, 130, 20);
  text(mouseY, 160, 20);
  text(mouseX - valueX, 190, 20);
  text(mouseY - valueY, 220, 20);
}

int[][] formatColorArray(int[][] colorArray, float[][] dat, boolean max, int count) {

  int[][] maskedColorArray = colorArray;
  float[] mask = sortResults(dat, max, count);
  int colour;
  if (max) {
    colour = pink;
  } else {
    colour = yellow;
  };

  for (int i = 0; i < colorArray[0].length; i++) {
    for (int j = 0; j < colorArray.length; j++) {
      if (dat[j][i] == mask[i]) {
        maskedColorArray[j][i] = colour;
      } else {
        maskedColorArray[j][i] = white;
      }
    }
  }
  return maskedColorArray;
}

float[] sortResults(float[][] dat, boolean max, int count) {

  float[] sorted = new float[count];

  for (int i = 0; i < dat[0].length; i++) {
    for (int j = 0; j < count; j++) {
      if (max) {
        if (data[j][i] < sorted[i]) {
          sorted[i] = data[j][i];
        }
      } else {
        if (data[j][i] > sorted[i]) {
          sorted[i] = data[j][i];
        }
      }
    }
  }
  return sorted;
}

void keyPressed() {

  valueX = mouseX;
  valueY = mouseY;
  //
  //  if (key == '\n' || keyCode == RETURN || keyCode == ENTER) {
  //    if (barcodeGood(typing)) {
  //      player = typing;
  //      typing = "";
  //      for (int i = 0; i < barcodes.length; i++) {
  //        if (player.equals(barcodes[i]) && mode == 1 && !(player.equals("00"))) {
  //          firstClick = false;
  //          int selection = i;
  //          l.captionLabel().set(names[selection]);
  //          data[index][0] = selection;
  //          name = names[int(data[index][0])];
  //          barcode = barcodes[selection];
  //          count = 0;
  //          nameSet = true;
  //        }
  //      }
  //    }
  //  } else {
  //    typing = typing + key;
  //  }
  //
  //  if (typing.length() > 2) {
  //    typing = typing.substring(1);
  //  }
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
    //    sScreen.resetTimer();
  }
}
