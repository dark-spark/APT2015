class tableOfStrings {
  //Class variables
  float[][] table;
  float[][] sortedTable;
  String[][] displayedTable;
  int[][] colours;
  int[][] dColorTable;
  int tableHeight, colSpacing, maxLength;
  int[] rowHeights;
  ArrayList<rowOfStrings> rows;
  ArrayList<float[]> mainTable;
  boolean initialised = false;
  boolean sort = false;
  boolean minMax = true;
  
  tableOfStrings() {
  }

  void init(float[][] _table, int _tableHeight, int _colSpacing, int _maxLength, int _index) {
    if (!initialised) {
      table = _table;
      colours = whiteColor2dArray(arrayLength, table[0].length);
      tableHeight = _tableHeight;
      colSpacing = _colSpacing; 
      maxLength = _maxLength;

      rowHeights = new int[table.length];
      for (int i = 0; i < rowHeights.length; i++) {
        rowHeights[i] = tableHeight + (i * 20);
      }

      String[][] tableToDisplay = floatToStringArray(table, 0, _index, table[0].length, maxLength);

      mainTable = new ArrayList<float[]>();
      for (int i = 0; i < _index; i++) {
        mainTable.add(new float[7]);
        float[] fArray = mainTable.get(i);
        for (int j = 0; j < fArray.length; j++) {
          fArray[j] = table[i][j];
        }
      }
      
      rows = new ArrayList<rowOfStrings>();
      for (int i = 0; i < _index && i < maxLength; i++) {
        rows.add(new rowOfStrings(tableToDisplay[i], rowHeights[i], colSpacing, colours[i]));
      }

      initialised = true;
    }
  }
  
  void setSorting(boolean _sort, boolean _minMax) {
    sort = _sort;
    minMax = _minMax;
  }

  void init(float[][] _table, int _index) {
    if (!initialised) {
      table = _table;
      colours = whiteColor2dArray(arrayLength, table[0].length);

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
    int[][] colourArray = colorArray(current, max);

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

  int[][] colorArray(float[][] dat, boolean max) {

    float[] mask = findMinMax(dat, max, dat.length);
    int colour;
    int[][] colourArray = new int[dat.length][dat[0].length];
    if (max) {
      colour = pink;
    } else {
      colour = yellow;
    };

    for (int i = 0; i < dat[0].length; i++) {
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

  private float[] findMinMax(float[][] dat, boolean max, int count) {

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

  void display() {
    if (initialised) {
      for (int i = 0; i < index && i < maxLength; i++) {
        rowOfStrings ros = rows.get(i);
        ros.display();
      }
    }
  }

  void display1() {
    if (initialised) {
      float [][] tempTable = table;
      tempTable = sortResults(6, minMax, tempTable);
      
      //code to color
      for (int i = 0; i < index && i < maxLength; i++) {
        rowOfStrings ros = rows.get(i);
        for(int j = 0; j < ros.sizeOf(); j++) {
          ros.setText(j, displayedTable[i][j]);
          ros.setColor(j, dColorTable[i][j]);
        }
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

  public void pushSortResults(boolean max) {
    pushTable(sortResults(6, max, table));
  }

  private float[][] sortResults(int row, boolean max, float[][] data) {

    FloatList sortList;
    float[][] sortedTable = new float[index][data[0].length];
    sortList = new FloatList();

    //Create List of values in the row that you want to sort, list used because it has a sort method.
    for (int i = 0; i < index; i++) {
      sortList.append(data[i][row]);
    }
    
    //Sort for fastest or slowest
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

  public void clearTable() {
    for (int i = 0; i < rows.size (); i++) {
      rows.remove(i);
    }
    initialised = false;
  }

  public void pushNewData(float[][] _data) {
    clearTable();
    init(_data, index);
  }
}
