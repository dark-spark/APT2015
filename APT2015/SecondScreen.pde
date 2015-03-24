
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
  int time = 100001;
  int fontSize = 100;
  PFont f;
  
  public void setup() {
    background(0);
    noStroke();
    f = createFont("Arial Unicode MS", fontSize);
    textAlign(CENTER);
    textFont(f);
  }

  public void draw() {
    background(0);
    fill(255);   
    char[] chars = intToCharArray(time);
    String display = "" + chars[0] + chars[1] + ":" + chars[2] + chars[3] + ":" + chars[4] + chars [5];
    text(display, width/2, (height/2) + (fontSize/3));
  }
  
  public void setTime(int t) {
    time = t;
  }
  
  public char[] intToCharArray(int t) {
    String str = str(t);
    char[] chars = new char[6]; 
    for(int i = 0; i < chars.length; i++) {
        
      chars[i] = str.charAt(i);
    }
    return chars;
  }    
}
