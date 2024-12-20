//rtf files don't work, but simple text files do
String[] textfile; //this array gets filled with loadStrings

ArrayList allWords = new ArrayList(); //this will be an array of an array of strings
//whose length is the number of lines in the text file, and whose individual elements' length
//is the number of words in each line
ArrayList<String> individualWords = new ArrayList<String>();
//this will get individual words from the array list allWords
String[] words; //this will eventually store all the individual words


PFont font;
float angle, x, y;
float initialSize=50;
float s=initialSize;
int index;


void setup() {
  size(500, 500);
  smooth();
  frameRate(10);
  background(0);

  font=loadFont("SansSerif-48.vlw");

  textfile=loadStrings("test3.txt");

  for (int l=0; l<textfile.length; l++) {
    String[] linewords=split(textfile[l], " ");
    allWords.add(linewords);
  }
  
  //here the words are added line by line, word by word to the arrayList individual words
  //an arrayList is used because the total number of words isn't known
  for (int i=0; i<allWords.size(); i++) {

    String[] temp=(String[]) allWords.get(i);

    for (int j=0; j<temp.length; j++) {
      individualWords.add(temp[j]);
    }
  }

  words=new String[individualWords.size()];
  for (int i=0; i<words.length; i++) words[i]=individualWords.get(i);
  //this is just an array copy from an array list to an array of primitives
}



void draw() {
  fill(0, 10);
  rect(0, 0, width, height);

  angle=random(0, 2*PI);
  x=random(0, width);
  y=random(0, height);
  index=(int)random(words.length);

  pushMatrix();
  translate(x, y);
  rotate(angle);
  fill(255);
  textFont(font, s);
  text(words[index], 0, 0);
  popMatrix();


  s-=.1;
  if (s<1) s=initialSize;

  if (keyPressed) {
    background(0);
    s=initialSize;
  }
}

