
void control() {
  switch(mode) {
  case 10:
    if(nameSet) {
      mode = 20;
      currentSesh[0] = name;
    }
    break;

  case 20:
    displayGoButton();
    break;
  }
}

void displayGoButton() {
  
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
  textFont(f1);
  stroke(255);
  text(mode, 20, 350);
//  noStroke();
//  fill(255);
//  rect(boxX, boxY, boxSize, boxSize);
//  rect(boxX1, boxY1, boxSize, boxSize);
//
//  //Mimic lights
//  ellipseMode(CORNER);
//  if (redON) {
//    fill(255, 0, 0);
//  } else { 
//    fill(50, 0, 0);
//  }
//  ellipse(20, 360, 40, 40);
//
//  if (greenON) {
//    fill(0, 255, 0);
//  } else {
//    fill(0, 50, 0);
//  }
//  ellipse(20, 410, 40, 40);
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
