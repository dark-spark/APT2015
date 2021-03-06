void displayMainTable(float[][] _data) {
  boolean sortByMax = true;
  float[][] displayData = sortResults(6, sortByMax, _data);
  int[][] colorTable = colorArray(displayData, sortByMax);
  for (int i = 0; i < index; i++) { 
    String[] displayArray = floatToStringRow(displayData[i]);
    rowOfText(displayArray, 150, rowHeights[i], colorTable[i]);
  }
}

String[] floatToStringRow(float[] _data) {
  String[] strings;
  int a = _data.length;
  strings = new String[a];
  strings[0] = names[int(_data[0])];
  for (int i = 1; i < a; i++) {
    if (_data[i] == 0) {
      strings[i] = "";
    } else {
      strings[i] = String.format("%.2f", _data[i]);
    }
  }
  return strings;
}

int[][] colorArray(float[][] dat, boolean max) {

  float[] mask = findMinMax(dat, max);
  int colour;
  int[][] colourArray = new int[dat.length][dat[0].length];
  if (max) {
    colour = pink;
  } else {
    colour = yellow;
  };

  for (int i = 0; i < dat.length; i++) {
    colourArray[i][0] = white;
  }
  for (int i = 1; i < dat[0].length; i++) {
    for (int j = 0; j < dat.length; j++) {
      if (dat[j][i] == mask[i]) {
        colourArray[j][i] = colour;
      } else {
        colourArray[j][i] = white;
      }
    }
  }
  return colourArray;
}

float[] findMinMax(float[][] dat, boolean max) {

  float[] minMax = new float[dat[0].length];
  for (int i = 0; i < dat[0].length; i++) {
    if (!max) {
      minMax[i] = 2147483647;
    }
  } 
  for (int i = 0; i < dat[0].length; i++) {
    for (int j = 0; j < dat.length; j++) {
      //        println("i="+i+"j="+j);
      if (max) {
        if (dat[j][i] > minMax[i]) {
          minMax[i] = dat[j][i];
        }
      } else {
        if (dat[j][i] < minMax[i]) {
          minMax[i] = dat[j][i];
        }
      }
    }
  }
  return minMax;
}


float[][] sortResults(int row, boolean max, float[][] _data) {

  FloatList sortList;
  sortList = new FloatList();
  float[][] sortedTable = new float[_data.length][_data[0].length];

  for (int i = 0; i < _data.length; i++) {
    sortList.append(_data[i][row]);
  }

  //Sort for fastest or slowest
  if (!max) {
    sortList.sort();
  } else {
    sortList.sortReverse();
  }

  //Generate a list of the ranked positions
  for (int i = 0; i < _data.length; i++) {
    for (int j = 0; j < _data.length; j++) {
      if (_data[j][row] == sortList.get(i)) {
        sortedTable[i] = _data[j];
      }
    }
  }
  return sortedTable;
}

void clearCurrentArrays() {
  for (int a = 0; a < 7; a++) {
    currentSesh[a] = "";
    currentRun[a] = 0;
  }
}

int nameCode(String _name, String[] _names) {
  int c = 99;
  for (int i = 0; i < _names.length; i++) {
    if (_name.equals(_names[i])) {
      c = i;
    }
  }
  return c;
}

float[][] appendArray(float[] newData, float[][] da) {
  da[index] = newData;
  return da;
}

void resetSerialData() {
  serialData = false;
  lcsg = false;
  dfr = false;
  pbr = false;
}

void hideAllButtons() {
  lcsgButton.hide();
  pbrButton.hide();
  dfrButton.hide();
  startButton.hide();
  okButton.hide();
}

void ammo(String theText) {
  if (validateText(theText)) {
    currentRun[5] = int(theText);
    currentSesh[5] = theText;
    mode = 108;
  }
}

void OK(int theValue) {
  String theText = textField.getText();
  if (validateText(theText)) {
    currentRun[5] = int(theText);
    currentSesh[5] = theText;
    mode = 108;
  }
}

boolean validateText(String text) {
  boolean isNull = text.equals("") ? true : false;
  int n = int(text);
  if (!isNull && n > 0) {
    return true;
  } else {
    return false;
  }
}

void Start(int theValue) {
  mode += 10;
}

void LCSG(int theValue) {
  lcsg = true;
  serialData = true;
}

void DFR(int theValue) {
  dfr = true;
  serialData = true;
}

void PBR(int theValue) {
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
  if (mode == 110 || mode == 10) {
    firstClick = false;
    l.captionLabel().set(names[selection]);
    data[index][0] = selection;
    name = names[int(data[index][0])];
    nameSet = true;
  }
}

void debugT() {
  println("DEBUG TRIGGERED!!!!!!!!!!!!");
  if (first) {
    stop = true;
  }
  first = true;
}

void debugB() {
  println("Before");
  ranking.printMainTable();
}

void debugA() {
  println("After");
  ranking.printMainTable();
  if (stop) {
    while (stop) {
      //Stop
    }
  }
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

void rowOfText(String[] ttext, int colSpacing, int hheight, color[] colors) {

  float numOfCols = ttext.length;
  int ceil = ceil(numOfCols / 2);

  for (int i = 0; i < numOfCols; i++) {
    fill(colors[i]);
    text(ttext[i], width/2 + (colSpacing * (i - numOfCols + ceil)), hheight);
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
  float[] mask = sortResults1(dat, max, count);
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

float[] sortResults1(float[][] dat, boolean max, int count) {

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
  }


  if (mouseX > boxX1 && mouseX < boxX1+boxSize && mouseY >boxY1 && mouseY < boxY1+boxSize) {
  }
}

void setupCP5() {

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

  //Set up textField
  textField = cp5.addTextfield("ammo")
    .setPosition(1000, 20)
      .setSize(60, 25)
        .setFont(cFont)
          .setFocus(true)
            .hide()
              ;


  //Set up buttons
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

  okButton = cp5.addButton("OK")
    .setValue(0)
      .setPosition(1100, 20)
        .setSize(60, 25)
          .setId(0)
            .activateBy(ControlP5.RELEASE)
              .hide()
                ;

  okButton.captionLabel()
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
}
