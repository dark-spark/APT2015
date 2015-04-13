class tableOfStrings {
  //Class variables
  float[][] table;
  float[][] sortedTable;
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

      String[][] tableToDisplay = floatToStringArray(table, 0, index, table[0].length, maxLength);

      rows = new ArrayList<rowOfStrings>();
      for (int i = 0; i < index && i < maxLength; i++) {
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

    float[][] current = getCurrent();
    int[][] colourArray = colorArray(current, max, index);

    for (int i = 0; i < rows.size (); i++) {
      for (int j = 1; j < colourArray[0].length; j++) {
        rowOfStrings ros = rows.get(i);
        ros.setColor(j, colourArray[i][j]);
      }
    }
  }

  float[][] getCurrent() {
    int a = rows.size();
    rowOfStrings r = rows.get(0);
    int b = r.sizeOf();
    float[][] current = new float[a][b];
    for (int i = 0; i < a; i++) {
      r = rows.get(i);
      for (int j = 1; j < b; j++) {
        current[i][j] = float(r.getText(j));
      }
    }
    return current;
  }

  int[][] colorArray(float[][] dat, boolean max, int count) {

    float[] mask = findMinMax(dat, max, count);
    int colour;
    int[][] colourArray = new int[count][dat[0].length];
    if (max) {
      colour = pink;
    } else {
      colour = yellow;
    };

    for (int i = 0; i < dat[0].length; i++) {
      for (int j = 0; j < count; j++) {
        if (dat[j][i] == mask[i]) {
          colourArray[j][i] = colour;
        } else {
          colourArray[j][i] = white;
        }
      }
    }
    return colourArray;
  }

  private float[] findMinMax(float[][] dat, boolean max, int count) {

    float[] minMax = new float[count];
    for (int i = 0; i < count; i++) {
      if (!max) {
        minMax[i] = 2147483647;
      }
    } 

    for (int i = 0; i < dat[0].length; i++) {
      for (int j = 0; j < count; j++) {
        if (max) {
          if (data[j][i] > minMax[i]) {
            minMax[i] = data[j][i];
          }
        } else {
          if (data[j][i] < minMax[i]) {
            minMax[i] = data[j][i];
          }
        }
      }
    }
    return minMax;
  }

  void display() {
    if (initialised) {
      for (int i = 0; i < index && i < maxLength; i++) {
        rowOfStrings ros = rows.get(i);
        ros.display();
      }
    }
  }

  void pushTable(float[][] pushTable) {
    String[][] tableToDisplay = floatToStringArray(pushTable, 0, index, pushTable[0].length, maxLength);
    for (int i = 0; i < index && i < maxLength; i++) {
      rowOfStrings ros = rows.get(i);
      for (int j = 0; j < pushTable[0].length; j++) {
        ros.setText(j, tableToDisplay[i][j]);
      }
    }
  }

  public void sortResults(boolean max) {

    pushTable(sortResults(6, max, table));
  }

  private float[][] sortResults(int row, boolean max, float[][] data) {

    FloatList sortList;
    float[][] sortedTable = new float[index][data[0].length];
    sortList = new FloatList();

    for (int i = 0; i < index; i++) {
      sortList.append(data[i][row]);
    }

    if (!max) {
      sortList.sort();
    } else {
      sortList.sortReverse();
    }

    //Generate a list of the ranked positions
    for (int i = 0; i < index; i++) {
      for (int j = 0; j < index; j++) {
        if (data[j][row] == sortList.get(i)) {
          sortedTable[i] = table[j];
        }
      }
    }
    return sortedTable;
  }
}
