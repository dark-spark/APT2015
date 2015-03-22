
void create() {

  //Text
  fill(255);
  textFont(f1);
  textAlign(CENTER);
  text("Current Session", width/2, 50);
  text("Ranking", width/2, 180);

  //Alternating Bars    
  fill(40);
  stroke(40);
  rectMode(CENTER);
  for (int i = 1; i < index + 1 && i < 25; i = i + 2) {
    rect(width/2 + 77, (201 + (i * 20)), 1035, 19, 7);
  }
  rect(width/2 + 77, 114, 1035, 24, 7);

  //Text for Current Session
  fill(255);
  textFont(f2);
  textAlign(CENTER);
  text("Name", width/2 - (115 * 4) + 57, 96);
  text("Reaction Time", width/2 - (115 * 3) + 57, 96);
  text("Speed", width/2 - (115 * 2) + 57, 96);
  text("Sector 1", width/2 - (115 * 1) + 57, 96);
  text("Sector 2", width/2 - (115 * 0) + 57, 96);
  text("Sector 3", width/2 + (115 * 1) + 57, 96);
  text("Sector 4", width/2 + (115 * 2) + 57, 96);
  text("ET", width/2 + (115 * 3) + 57, 96);
  text("Total Time", width/2 + (115 * 4) + 57, 96);

  //Text for times and name of current session
  if (count == 7 && nameSet == false) {
    for (int i = 1; i < count + 2; i++) {
      //Check for minimum time 
      if (data[index -  1][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else if (data[index -  1][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else {
        fill(255);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
    }
    fill(255);
    text(names[int(data[index - 1][0])], width/2 - (115 * 4) + 57, 120);
  } else {
    for (int i = 1; i < count + 1; i++) {
      //Check for minimum time 
      if (data[index][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else if (data[index][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else {
        fill(255);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
      text("Hit", width/2 - (115 * (4 - i)) + 57, 120);
    }
    fill(255);
    text(names[int(data[index][0])], width/2 - (115 * 4) + 57, 120);
  }


  //text for times and names of Ranking
  if (sortFastest) { //For fastest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[i]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else if (data[sortListPos[i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
  } else { //For slowest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[index-i-1]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[index - 1-i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else if (data[sortListPos[index - 1-i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
  }

  //Draw box and text for sort selection
  rectMode(CORNER);
  textFont(f3);
  textAlign(LEFT);

  stroke(255);  
  fill(255);
  if (sortFastest) {
    text("Fastest", boxX+20, boxY+13);
  } else {
    text("Slowest", boxX+20, boxY+13);
  }
  fill(c3);
  stroke(50);
  rect(boxX, boxY, boxSize, boxSize);

  //Draw text for Ready
  textFont(f1);
  textAlign(LEFT);
  if (count == 0 && nameSet == true) {
    fill(0, 255, 0);
    //    text("Ready", 20, 300);
  } else {
    fill(255, 0, 0);
    //    text("Not Ready", 20, 300);
  }
}


void delay(int delay) {
  
  int time = millis();
  while (millis () - time <= delay);
}

void drawPixelArray(int[][] image, color color1, int posx, int posy, int multiplier) {

  fill(color1);
  stroke(color1);
  
  for (int i = 0; i < brokenHeart[0].length; i++) {
    for (int j = 0; j < brokenHeart.length; j++) {
      if (image[j][i] > 0) {
        rect((i*multiplier) + posx, (j*multiplier) + posy, multiplier, multiplier);
      }
    }
  }
}

void sortResults() {
  
  //Find Minimum sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] < min[j]) {
        min[j] = data[i][j];
      }
    }
  }

  //Find Max sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] > max[j]) {
        max[j] = data[i][j];
      }
    }
  }

  //Sort the list for ranking based on total time
  for (int i = 0; i < index; i++) {
    sortList[i] = data[i][8];
  }
  sortList = sort(sortList);

  //Generate a list of the ranked positions
  for (int i = 0; i < index; i++) {
    for (int j = 0; j < index; j++) {
      if (data[j][8] == sortList[i]) {
        sortListPos[i] = j;
      }
    }
  }
}

void mimicLights() {
  
  //Text for current mode for the swtich
  textFont(f1);
  stroke(255);
  text(mode, 20, 350);
  noStroke();
  fill(255);
  rect(boxX, boxY, boxSize, boxSize);
  rect(boxX1, boxY1, boxSize, boxSize);


  //Mimic lights
  ellipseMode(CORNER);
  if (redON) {
    fill(255, 0, 0);
  } else { 
    fill(50, 0, 0);
  }
  ellipse(20, 360, 40, 40);

  if (blueON) {
    fill(0, 0, 255);
  } else {
    fill(0, 0, 50);
  }
  ellipse(20, 410, 40, 40);

  if (greenON) {
    fill(0, 255, 0);
  } else {
    fill(0, 50, 0);
  }
  ellipse(20, 460, 40, 40);

  if (whiteON) {
    fill(255);
  } else {
    fill(50);
  }
  ellipse(20, 510, 40, 40);

  if (yellowON) {
    fill(255, 255, 0);
  } else {
    fill(50, 50, 0);
  }
  ellipse(20, 560, 40, 40);
}


boolean barcodeGood(String text) {
  
  text = trim(text);
  boolean good = false;
  for (int i = 0; i < barcodes.length; i++) {
    if (text.equals(barcodes[i])) {
      good = true;
      break;
    }
  }
  return good;
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup() && theEvent.name().equals("myList")) {
    selection = (int)theEvent.group().value();
    updateName();
  }
}

void updateName() {
  firstClick = false;
  //  println(names[selection]);
  l.captionLabel().set(names[selection]);
  data[index][0] = selection;
  name = names[int(data[index][0])];
  barcode = barcodes[selection];
  nameSet = true;
}

void formatPostData(float multiplier) {
  
//  println("Multipler = " + multiplier);
  
  float rt = reactionTime * multiplier;
  float ta0 = float(timeArray[0]) * multiplier;
  float ta1 = float(timeArray[1]) * multiplier;
  float ta2 = float(timeArray[2]) * multiplier;
  float ta3 = float(timeArray[3]) * multiplier;
  float ta4 = float(timeArray[4]) * multiplier;
  
  float speed = float(trapDistance) / ta0 * 3.6;
  int et = int(ta1) + int(ta2) + int(ta3) + int(ta4);
  int totalTime = et + int(abs(rt));
  
  postData[0] = pBarcode;
  postData[1] = str(reactionTime + .0);
  postData[2] = str(speed);
  postData[3] = str(ta1);
  postData[4] = str(ta2);
  postData[5] = str(ta3);
  postData[6] = str(ta4);
  postData[7] = str(et + .0);
  postData[8] = str(totalTime + .0);
  postData[9] = str(jumpStart);
}

void fillData() {
  
  for (int i = 0; i < 9; i++) {
    data[index][i] = float(postData[i]);
  }
}
