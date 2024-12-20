//rtf files don't work, but simple text files do
String[] textfile; //this array gets filled with loadStrings

ArrayList allWords = new ArrayList(); //this will be an array of an array of strings
//whose length is the number of lines in the text file, and whose individual elements' length
//is the number of words in each line
ArrayList<String> individualWords = new ArrayList<String>();
//this will get individual words from the array list allWords
String[] words; //this will eventually store all the individual words

ArrayList flyers = new ArrayList();
//this will be an array of arrays the have r, s, and theta info for each word


PFont font;
int index;
int frames=0;
float mx, my;

void setup() {
  size(600, 600);
  smooth();
  background(0);
  
  mx=width/2;
  my=height/2;

  textAlign(CENTER);
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
  background(0);
  
  mx+=(mouseX-mx)*.02;
  my+=(mouseY-my)*.02;
  if (abs(mouseX-mx) < 2.5) mx=mouseX;
  if (abs(mouseY-my) < 2.5) my=mouseY;
  
  frames++;
  if (frames==25) {
    index=(int)random(words.length);
    flyers.add(new flyer(400, 50, 0, words[index], font));
    frames=0;
  }

  for (int i=flyers.size()-1; i>=0; i--) {
    flyer flr = (flyer) flyers.get(i);
    flr.update();
    flr.display();
    if (flr.r < 15) flyers.remove(i);
  }

  if (mousePressed) {
    println(flyers.size());
    for (int i=flyers.size()-1; i>=0; i--) flyers.remove(i);
    background(0);
  }
}


class flyer {
  float r, s, a;
  String word;
  PFont font;
  flyer(float rt, float st, float at, String wordt, PFont tfont) {
    word=wordt;
    r=rt;
    s=st;
    a=at;
    font=tfont;
  }

  void update() {
    r-=.0035*r;
    s-=.003*s;
    a+=.025;
  }

  void display() {
    pushMatrix();
    translate(mx, my);
    rotate(a);
    fill(255, 100*a);
    textFont(font, s);
    text(word, 0, r);
    popMatrix();
  }
}

