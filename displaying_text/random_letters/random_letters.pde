PFont font;
float angle, x, y;
float initialSize=50;
float s=initialSize;
int index;

String[] letters= {
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", 
  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
};


void setup() {
  size(500, 500);
  smooth();
  frameRate(10);


  background(0);
  font=loadFont("SansSerif-48.vlw");


  /*
  letters[0]="a";
   letters[1]="b";
   letters[2]="c";
   letters[3]="d";
   letters[4]="e";
   letters[5]="f";
   letters[6]="g";
   letters[7]="h";
   letters[8]="i";
   letters[9]="j";
   letters[10]="k";
   letters[11]="l";
   letters[12]="m";
   letters[13]="n";
   letters[14]="o";
   letters[15]="p";
   letters[16]="q";
   letters[17]="r";
   letters[18]="s";
   letters[19]="t";
   letters[20]="u";
   letters[21]="v";
   letters[22]="w";
   letters[23]="x";
   letters[24]="y";
   letters[25]="z";
   */
}

void draw() {
  fill(0, 10);
  rect(0, 0, width, height);

  angle=random(0, 2*PI);
  x=random(0, width);
  y=random(0, height);
  index=(int)random(letters.length);

  pushMatrix();
  translate(x, y);
  rotate(angle);
  fill(255);
  textFont(font, s);
  text(letters[index], 0, 0);
  popMatrix();


  s-=.1;
  if (s<1) s=initialSize;

  if (keyPressed) {
    background(0);
    s=initialSize;
  }
}

