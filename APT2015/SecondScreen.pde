
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
  int time = 123;
  int startTime, stopTime;
  int t0 = 0;
  int fontSize = 200;
  PFont f;
  boolean run = false;

  public void setup() {
    background(0);
    noStroke();
    f = createFont("Arial Unicode MS", fontSize);
    textAlign(CENTER);
    textFont(f);
    fontSize = width / 5;
  }

  public void draw() {
    background(0);
    
    fontSize = width / 5;
    f = createFont("Arial Unicode MS", fontSize);
    textAlign(CENTER);
    textFont(f);
    
    updateTime();
    display(time);
  }

  public void display(int val) { 
    fill(255);
    val = val / 10;
    char[] chars = millisToChar(val);
    String display = "" + chars[0] + chars[1] + ":" + chars[2] + chars[3] + ":" + chars[4] + chars [5];
    text(display, width/2, (height/2) + (fontSize/3));
  }

  public void updateTime() {
    if (run) {
      time = t0 + millis() - startTime;
    }
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

  public void stopTimer() {
    if (run) {
      run = false;
      stopTime = millis();
      t0 = time;
    }
  }

  public void resetTimer() {
    time = 0;
    startTime = millis();
    stopTime = 0;
    t0 = 0;
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
