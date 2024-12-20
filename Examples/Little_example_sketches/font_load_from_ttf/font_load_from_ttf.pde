/*Katakana copy.ttf is in this folder, BUT IT DOESN'T HAVE TO BE.
 processing can only recognize a font if it's in the
 Library > Fonts directory of the computer. then you can use the
 Create Font tool to make a vlw file of the font in the sketch's data
 folder. i only put the ttf file in here so that I don't lose it in
 case i want to install it on other machines*/

PFont myFont;

void setup() {
  size(500, 500);

  //  String[] fontList = PFont.list();
  //  println(fontList);
  //myFont = loadFont("Katakana-48.vlw");
  //textFont(myFont, 25);
  
  myFont = createFont("Katakana", 25);
  textFont(myFont);
  
  float[] pos = new float[2];

  for (int i=33; i<109; i++) {
    // this range of integers covers all of the japanese
    // characters in this font
    char c = (char)i;

    //String s = Character.toString(c);
    String s = "" + 'c';
    if (s == null) println(i);

    pos[0] = 100+(i*25)%300;
    pos[1] = 25*(i/12);
    text(c, pos[0], pos[1]);
  }
}

