class tableOfStrings {
  //Gloabal variables
  float[][] table;
  int[][] colours;
  int tableHeight, colSpacing, maxLength;
  int[] rowHeights;
  ArrayList<rowOfStrings> rows;
  boolean initialised = false;

  tableOfStrings() {
  }

  void init(float[][] _table, int _tableHeight, int _colSpacing, int _maxLength) {
    if (!initialised) {
      table = _table;
      colours = whiteColor2dArray(100, table[0].length);
      tableHeight = _tableHeight;
      colSpacing = _colSpacing; 
      maxLength = _maxLength;

      rowHeights = new int[table.length];
      for (int i = 0; i < rowHeights.length; i++) {
        rowHeights[i] = tableHeight + (i * 20);
      }

      String[][] tableToDisplay = floatToStringArray(table, 0, table.length, table[0].length, maxLength);

      rows = new ArrayList<rowOfStrings>();
      for (int i = 0; i < maxLength; i++) {
        rows.add(new rowOfStrings(tableToDisplay[i], rowHeights[i], colSpacing, colours[i]));
      }

      initialised = true;
    }
  }  

  String[][] floatToStringArray(float[][] data, int a, int b, int c, int max) {

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

  void colorResults(boolean max) {
    for (int i = 0; i < table.length; i++) {
      for (int j = 0; j < table[0].length; j++) {
      }
    }
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

  void display() {
    if (initialised) {
      for (int i = 0; i < maxLength; i++) {
        rowOfStrings ros = rows.get(i);
        ros.display();
      }
    }
  }
}
