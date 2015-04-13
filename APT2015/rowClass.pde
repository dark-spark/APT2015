class rowOfStrings {

  int rowHeight, colSpacing;
  StringList text;
  IntList colours;

  rowOfStrings(String[] _text, int _rowHeight, int _colSpacing, color[] _colours) {

    text = new StringList();
    colours = new IntList();

    for (int i = 0; i < _text.length; i++) {
      text.append(_text[i]);
    }

    for (int i = 0; i < _colours.length; i++) {
      colours.append(_colours[i]);
    }

    rowHeight = _rowHeight;
    colSpacing = _colSpacing;
  }

  void display() {
    String[] ttext = new String[text.size()];
    for (int i = 0; i < text.size (); i++) {
      ttext[i] = text.get(i);
    }
    int[] ccolours = new int[colours.size()];
    for (int i = 0; i < colours.size (); i++) {
      ccolours[i] = colours.get(i);
    }
    rowOfText(ttext, colSpacing, rowHeight, ccolours);
  }

  void setColor(int pos, int colour) {
    colours.set(pos, colour);
  }

  void setText(int pos, String ttext) {
    text.set(pos, ttext);
  }
}
