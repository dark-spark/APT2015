
void control() {
  switch(mode) {

  case 10:
    redON();
    if (nameSet) {
      debugB();//////////////////////////////////////////////////
      clearCurrentArrays();
      currentSesh[0] = name;
      currentRun[0] = nameCode(name, names);
      debugA();////////////////////////////////////////////////// 
      startButton.show();
      sScreen.setTime1(10000);
      mode = 20;
    }
    break;

  case 20:
    //Wait for start button to be pressed, start() will advance to next mode
    break;

  case 30:
    redOFF();
    greenON();
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
      currentRun[1] = t;
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
      currentRun[2] = t - currentRun[0];
      float ft = (t/1000) - currentRun[0]/1000;
      currentSesh[2] = String.format("%.2f", ft);
      resetSerialData();
      dfrButton.show();
      lcsgButton.show();
      pbrButton.hide();
      sScreen.setTime1(12340);
      sScreen.startTimer1();
      sScreen.timerSwap();
      sScreen.showTimer1();
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
      } else if (dfr) { //If zombie run this should trigger, only dfr should be hit, with out lcsg.
        float t = float(sScreen.getTime());
        currentRun[4] = t - currentRun[2] - currentRun[1];
        float ft = (t/1000) - currentRun[2]/1000 - currentRun[1]/1000;
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
      currentRun[3] = t - currentRun[1] - currentRun[2];
      float ft =(t/1000) - currentRun[1]/1000 - currentRun[2]/1000;
      currentSesh[3] = String.format("%.2f", ft);
      resetSerialData();
      hideAllButtons();
      mode = 100;
    }
    break;

  case 100:
    sScreen.stopTimer();
    sScreen.stopTimer1();
    float t = float(sScreen.getTime());
    currentRun[6] = t;
    t /= 1000;
    currentSesh[6] = String.format("%.2f", t);
    mode = 105;
    nameSet = false;
    break;

  case 105:
    if (obstacleCourse) {
      mode = 108;
    } else {
      textField.show();
      mode = 107;
    }
    break;

  case 107:
    //Ok button or data entry will move to next case.
    break;

  case 108:
    textField.hide();
    okButton.hide();
    data = appendArray(currentRun, data);
    ranking.addNewRow(currentRun);
    mainGlobalTable.add(currentRun);
    index++;
    //    writeTextFile();//////////////////////////////////////Commented Out for testing////////////////////
    mode = 110;
    break;

  case 110:
    //Wait for name to be set
    if (nameSet) {
      mode = 10;
      sScreen.resetTimer();
      sScreen.resetTimer1();
    }
    break;
  }
} 

