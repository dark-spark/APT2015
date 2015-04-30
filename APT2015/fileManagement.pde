
void writeTextFile() {

  //Create string for saving to text file
  String[] listString = new String[index];
  for (int i = 0; i < index; i++) {
    listString[i] = join(nf(int(data[i]), 0), ",");
  }

  //Save to text file
  saveStrings("list.txt", listString);
}


String loadlist[] = new String[0];
String nameString[] = new String[0];

void loadFiles() {
    
  loadlist = loadStrings("list.txt");
  for (int i = 0; i < loadlist.length; i++) {
    String[] split = split(loadlist[i], ',');
    for (int j = 0; j < split.length; j++) {
      data[i][j] = float(split[j]);
    }
    index++;
  }

  // Import Names
  nameString = loadStrings("names.txt");
  for (int i = 0; i < nameString.length; i++) {
    String[] split = split(nameString[i], ',');
    names[i] = split[0];
    barcodes[i] = split[1];
  }
}
