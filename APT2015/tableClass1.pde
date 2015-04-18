class tableOfStrings1 {
  //Class variables
  int tableHeight, colSpacing, maxLength, arrayWidth;
  ArrayList<rowOfStrings> rows;
  ArrayList<int[]> colors;
  float[][] displayTable;
  int[][] colours;
  int[] rowHeights;
  String[] nameArray;
  boolean initialised = false;
  boolean sort, minMax, coloured;
  boolean blinker;

  tableOfStrings1() {
  }

  void init(float[][] _table, int _tableHeight, int _colSpacing, int _maxLength, int _index, String[] _names) {
    if (!initialised) {

      float[][] ttable = _table;
      arrayWidth = ttable[0].length;
      tableHeight = _tableHeight;
      colSpacing = _colSpacing; 
      maxLength = _maxLength;
      nameArray = _names;

      mainTable = new ArrayList<float[]>();
      for (int i = 0; i < _index; i++) {
        mainTable.add(new float[7]);
        float[] fArray = mainTable.get(i);
        for (int j = 0; j < fArray.length; j++) {
          fArray[j] = ttable[i][j];
        }
      }

      colours = whiteColor2dArray(arrayLength, arrayWidth);

      colors = new ArrayList<int[]>(mainTable.size());
      for (int i = 0; i < colors.size (); i++) {
        int[] _colors = colors.get(i);
        _colors = new int[7];
        for (int j = 0; j < _colors.length; j++) {
          _colors[j] = white;
        }
      }

      rowHeights = new int[ttable.length];
      for (int i = 0; i < rowHeights.length; i++) {
        rowHeights[i] = tableHeight + (i * 20);
      }

      initialised = true;
    }
  }

  void addNewRow(float[] _newRow) {
    mainTable.add(_newRow);
  }

  void display() {
    if (sort) {
      float[][] main = getMain();
      displayTable = sortResults(6, minMax, main);
    } else if (!sort) {
      displayTable = getMain();
    }
    if (coloured) {
      colourTableColoured();
    } else if (!coloured) {
      colourTableWhite();
    }
    for (int i = 0; i < displayTable.length; i++) {  
      String[] displayArray = floatToStringRow(displayTable[i]);
      rowOfText(displayArray, colSpacing, rowHeights[i], colours[i]);
    }
  }

  void printMainTable(int seconds) { 
    if (frameCount % (30 * seconds) == 0) { 
      blinker = !blinker;
    }
    if (blinker) {  
      println("mainTable");
      for (int i = 0; i < mainTable.size (); i++) {
        float[] a = mainTable.get(i);
        println(a);
      }
    }
  }

  void printMainTable() { 
    println("mainTable");
    for (int i = 0; i < mainTable.size (); i++) {
      float[] a = mainTable.get(i);
      println(a[0]);
    }
  }

  void colourTableWhite() {
    colours = whiteColor2dArray(arrayLength, arrayWidth);
  }

  void colourTableColoured() {
    colours = colorArray(displayTable, minMax);
  }

  float[][] sortResults(int row, boolean max, float[][] _data) {

    FloatList sortList;
    sortList = new FloatList();
    float[][] sortedTable = new float[_data.length][_data[0].length];

    for (int i = 0; i < _data.length; i++) {
      sortList.append(_data[i][row]);
    }

    //Sort for fastest or slowest
    if (!max) {
      sortList.sort();
    } else {
      sortList.sortReverse();
    }

    //Generate a list of the ranked positions
    for (int i = 0; i < _data.length; i++) {
      for (int j = 0; j < _data.length; j++) {
        if (_data[j][row] == sortList.get(i)) {
          sortedTable[i] = _data[j];
        }
      }
    }
    return sortedTable;
  }

  int[][] colorArray(float[][] dat, boolean max) {

    float[] mask = findMinMax(dat, max);
    int colour;
    int[][] colourArray = new int[dat.length][dat[0].length];
    if (max) {
      colour = pink;
    } else {
      colour = yellow;
    };

    for (int i = 0; i < dat.length; i++) {
      colourArray[i][0] = white;
    }
    for (int i = 1; i < dat[0].length; i++) {
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

  float[][] getMain() {
    int a = mainTable.size();
    float[] r = mainTable.get(0);
    int b = r.length;
    float[][] ccurrent = new float[a][b];
    for (int i = 0; i < a; i++) {
      r = mainTable.get(i);
      for (int j = 0; j < b; j++) {
        ccurrent[i][j] = r[j];
      }
    }
    return ccurrent;
  }

  float[] findMinMax(float[][] dat, boolean max) {

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

  void setSorting(boolean _sort, boolean _minMax) {
    sort = _sort;
    minMax = _minMax;
  }

  void setColoured(boolean _coloured) {
    coloured = _coloured;
  }

  String[] floatToStringRow(float[] _data) {
    String[] strings;
    int a = _data.length;
    strings = new String[a];
    strings[0] = nameArray[int(_data[0])];
    for (int i = 1; i < a; i++) {
      strings[i] = String.format("%.2f", _data[i]);
    }
    return strings;
  }
}
