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
    for (int i = 0; i < text.size(); i++) {
      ttext[i] = text.get(i);
    }
    int[] ccolours = new int[colours.size()];
    for (int i = 0; i < colours.size(); i++) {
      ccolours[i] = colours.get(i);
    }
    rowOfText(ttext, colSpacing, rowHeight, ccolours);
  }

  void setColor(int pos, String text) {
  }

  void setText(int pos, String text) {
  }
}

class tableOfStrings {
  //Gloabal variables
  String[][] table;
  int[][] colours;
  int tableHeight, colSpacing;
  int[] rowHeights;
  ArrayList<rowOfStrings> rows;
  
  tableOfStrings(String[][] _table, int _tableHeight, int _colSpacing, int[][] _colours) {
    
    table = _table;
    colours = _colours;
    tableHeight = _tableHeight;
    colSpacing = _colSpacing; 
      
    rowHeights = new int[table.length];
    for(int i = 0; i < rowHeights.length; i++) {
      rowHeights[i] = 226 + (i * 20);
    }
    
    rows = new ArrayList<rowOfStrings>();
    for(int i = 0; i < table.length; i++) {
      rows.add(new rowOfStrings(table[i], rowHeights[i], colSpacing, colours[i]));
    }
  }
  
  void display(){
    for(int i = 0; i < table.length; i++) {
      rowOfStrings ros = rows.get(i);
      ros.display();
    }
  }
}
