PFont font;
int num_chars = 1000;
ArrayList[] char_info = new ArrayList[num_chars];
float[] size_range = {
  10, 50
};

void setup() {
  size(800, 600); 
  font = loadFont( "Helvetica-48.vlw" );
  textAlign(CENTER);
  background(0);
  // println(char(66)); returns the char associated with the integer 66,
  //which is 'B'
  // println(int('A')); returns 65
  // println(int('z')); returns 122

  for (int i=0; i<num_chars; i++) {
    char_info[i] = new ArrayList();
    char_info[i].add(char((int)random(65, 123)));
    char_info[i].add(random(width));
    char_info[i].add(random(height));
    char_info[i].add(random(size_range[0], size_range[1]));
  }


  for (int i=0; i<num_chars; i++) {
    textFont(font, (Float)char_info[i].get(3));
    text((Character)char_info[i].get(0), (Float)char_info[i].get(1), (Float)char_info[i].get(2));
  }
}



void draw() {
  background(0);

  for (int i=0; i<num_chars; i++) {
    textFont(font, (Float)char_info[i].get(3));
    text((Character)char_info[i].get(0), (Float)char_info[i].get(1), (Float)char_info[i].get(2));
  }

  println(frameRate);
}



/*

PGraphics pg;

void setup() {
  pg = createGraphics(100, 100);
  pg.beginDraw();
  pg.background(255, 127);
  pg.fill(0, 0, 255);
  pg.rect(60, 60, 20, 20);
  pg.endDraw();

  fill(0, 255, 0);
  rect(20, 20, 20, 20);

  image(pg, 0, 0);
}

overlay a transparent PGraphics onto the canvas, the PGraphics will be
all transparent, except for the rectangle i've drawn in it

*/

