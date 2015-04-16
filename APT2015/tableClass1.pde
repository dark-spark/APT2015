class tableOfStrings1 extends tableOfStrings {
  //Class variables
  int tableHeight, colSpacing, maxLength;
  ArrayList<rowOfStrings> rows;
  ArrayList<int[]> colors;
  ArrayList<float[]> mainTable;
  int[][] colours;
  int[] rowHeights;
  boolean initialised = false;

  tableOfStrings1() {
  }

  void init(float[][] _table, int _tableHeight, int _colSpacing, int _maxLength, int _index) {
    if (!initialised) {
      
      float[][] table = _table;
      tableHeight = _tableHeight;
      colSpacing = _colSpacing; 
      maxLength = _maxLength;

      mainTable = new ArrayList<float[]>();
      for (int i = 0; i < _index; i++) {
        mainTable.add(new float[7]);
        float[] fArray = mainTable.get(i);
        for (int j = 0; j < fArray.length; j++) {
          fArray[j] = table[i][j];
        }
      }
      
      colours = whiteColor2dArray(arrayLength, table[0].length);
      
      colors = new ArrayList<int[]>(mainTable.size());
      for(int i = 0; i < colors.size(); i++) {
        int[] _colors = colors.get(i);
        _colors = new int[7];
        for(int j = 0; j < _colors.length; j++) {
          _colors[j] = white;
        }
      }
        
      rowHeights = new int[table.length];
      for (int i = 0; i < rowHeights.length; i++) {
        rowHeights[i] = tableHeight + (i * 20);
      }
      
      rows = new ArrayList<rowOfStrings>();
      for (int i = 0; i < _index && i < maxLength; i++) {
        float[] arrayToDisplay = mainTable.get(i);
        String[] stringArrayToDisplay = floatToStringRow(arrayToDisplay);
        rows.add(new rowOfStrings(stringArrayToDisplay, rowHeights[i], colSpacing, colours[i]));
      }

      initialised = true;
    }
  }
}
