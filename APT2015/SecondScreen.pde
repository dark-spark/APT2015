
public class PFrame extends JFrame {
  public PFrame(int width, int height) {
    setBounds(100, 100, width, height);
    sScreen = new SecondApplet();
    add(sScreen);
    sScreen.init();
    show();
  }
}

public class SecondApplet extends PApplet {
  int time = 0;
  int time1 = 0;
  int startTime, stopTime;
  int startTime1, stopTime1;
  int t0 = 0;
  int t1 = 0;
  int fontSize = 200;
  int fontSize1 = 100;
  PFont f, f1;
  boolean run = false;
  boolean run1 = false;
  boolean countUp = false;
  boolean showTimer = true;
  boolean showTimer1 = false;
  boolean timerSwap = false;

  public void setup() {
    background(0);
    noStroke();
    f = createFont("Arial Unicode MS", fontSize);
    f1 = createFont("Arial Unicode MS", fontSize1);
    textAlign(CENTER);
  }

  public void draw() {
    background(0);
    f = createFont("Arial Unicode MS", fontSize);
    f1 = createFont("Arial Unicode MS", fontSize1);
    textAlign(CENTER);
    textFont(f);
    textFont(f1);
    fontSize = width / 4;
    fontSize1 = width / 8;

    updateTimer();
    updateTimer1();
    if (showTimer) {
      textFont(f);
      if (timerSwap) {
        display(time1);
      } else {
        display(time);
      }
    }
    if (showTimer1) {
      textFont(f1);
      if (timerSwap) {
        display1(time);
      } else {
        display1(time1);
      }
    }
    if(checkForZero()) {
      timerNotSwap();
      hideTimer1(); 
    }
  }

  public void display1(int val) {
    fill(255);
    val = val / 10;
    char[] chars = millisToChar(val);
    String display = "" + chars[0] + chars[1] + ":" + chars[2] + chars[3] + ":" + chars[4] + chars [5];
    text(display, width/2, (height/5) + (fontSize1/3));
  }

  public void display(int val) { 
    fill(255);
    val = val / 10;
    char[] chars = millisToChar(val);
    String display = "" + chars[0] + chars[1] + ":" + chars[2] + chars[3] + ":" + chars[4] + chars [5];
    text(display, width/2, (height/2) + (fontSize/3));
  }

  public void updateTimer() {
    if (run) {
      time = t0 + millis() - startTime;
    }
  }

  public void updateTimer1() {
    if (run1) {
      if (countUp) {
        time1 = t1 + millis() - startTime1;
      } else if (!countUp) {
        time1 = t1 - (millis() - startTime1);
      }
    }
  }

  public boolean checkForZero() {
    if (time1 <= 0) {
      return true;
    } else { 
      return false;
    }
  }
  
  public void timerSwap() {
    timerSwap = true;
  }
  
  public void timerNotSwap() {
    timerSwap = false;
  }

  public void showTimer() {
    showTimer = true;
  }

  public void hideTimer() {
    showTimer = false;
  }

  public void showTimer1() {
    showTimer1 = true;
  }

  public void hideTimer1() {
    showTimer1 = false;
  }

  public void setTime1(int t) {
    time1 = t;
    t1 = t;
  }

  public void setTime(int t) {
    time = t;
  }

  public void startTimer() {
    if (!run) {
      run = true;
      startTime = millis();
    }
  }

  public void startTimer1() {
    if (!run1) {
      run1 = true;
      startTime1 = millis();
    }
  }

  public void stopTimer() {
    if (run) {
      run = false;
      stopTime = millis();
      t0 = time;
    }
  }

  public void stopTimer1() {
    if (run1) {
      run1 = false;
      stopTime1 = millis();
      t1 = time;
    }
  }

  public void resetTimer() {
    time = 0;
    startTime = millis();
    stopTime = 0;
    t0 = 0;
    time1 = 0;
    startTime1 = millis();
    stopTime1 = 0;
  }

  public void resetTimer1() {
    time1 = 0;
    startTime1 = millis();
    stopTime1 = 0;
  }

  public int getTime() {
    return time;
  }

  public char[] millisToChar(int micros) {

    char[] chars = new char[6];
    int minutes, seconds, msec;

    msec = micros % 100;
    minutes = (micros - msec) /  100 / 60;
    seconds = (micros - msec - (minutes * 60 * 100)) / 100;

    //    println(minutes + ":" + seconds + ":" + msec);

    String min = str(minutes);
    String sec = str(seconds);
    String mse = str(msec);

    if (minutes > 9) {
      chars[0] = min.charAt(0);
      chars[1] = min.charAt(1);
    } else {
      chars[0] = '0';
      chars[1] = min.charAt(0);
    }

    if (seconds > 9) {
      chars[2] = sec.charAt(0);
      chars[3] = sec.charAt(1);
    } else {
      chars[2] = '0';
      chars[3] = sec.charAt(0);
    }

    if (msec > 9) {
      chars[4] = mse.charAt(0);
      chars[5] = mse.charAt(1);
    } else {
      chars[4] = '0';
      chars[5] = mse.charAt(0);
    }

    return chars;
  }

  public char[] intToCharArray(int t) {
    String str = str(t);
    char[] chars = new char[6];

    for (int i = 0; i < chars.length; i++) {
      if (i < (chars.length - str.length())) {
        chars[i] = '0';
      } else {  
        chars[i] = str.charAt(i - (chars.length - str.length()));
      }
    }

    return chars;
  }
}
