int cols=5;
int rows=4;
color f1 = color(0);
color f2 = color(255);
Cell[][] palette = new Cell[cols][rows];
color[] rectCol = new color[20];
void setup() {
  size(500, 500);
  smooth();
  background(255);

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      palette[i][j] = new Cell(i*80/5, j*20, 80/5, 20, j + 4*i);
    }
  }
  rectCol[0] = color(0); //black
  rectCol[1] = color(255); //white
  rectCol[2] = color(46, 11, 11); //brown
  rectCol[3] = color(120, 10, 10); // dark red
  rectCol[4] = color(255, 0, 0); //red
  rectCol[5] = color(250, 71, 74); // light red
  rectCol[6] = color(245, 59, 255); //pinkish
  rectCol[7] = color(232, 0, 245); // pink
  rectCol[8] = color(129, 3, 137); //purple
  rectCol[9] = color(55, 55, 250); //light blue
  rectCol[10] = color(0, 0, 255); //blue
  rectCol[11] = color(0, 0, 150); //dark blue
  rectCol[12] = color(95, 247, 101); //light green
  rectCol[13] = color(0, 247, 10); //lime green
  rectCol[14] = color(0, 103, 4); //dark green
  rectCol[15] = color(58, 103, 0); //yellow green
  rectCol[16] = color(255, 255, 0); //yellow
  rectCol[17] = color(255, 100, 0); //orange
  rectCol[18] = color(155); // gray
  rectCol[19] = color(55); //grayer
}
void draw() {
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      palette[i][j].display();
      checkMouseOver(palette[i][j]);
    }
  }
}
void mouseDragged() {
  if (mouseButton == LEFT) {
    noFill();
    stroke(f1);
    strokeWeight(20);
    strokeJoin(ROUND);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
  if (mouseButton == RIGHT) {
    noFill();
    stroke(f2);
    strokeWeight(20);
    strokeJoin(ROUND);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

void checkMouseOver(Cell d) {
  if (mousePressed) {
    if (mouseButton == LEFT && mouseX > d.x && mouseX < d.x+d.w && mouseY > d.y && mouseY < d.y+d.h) {
      f1 = (get(mouseX, mouseY));
    }
    //else if (mouseButton == RIGHT && mouseX > d.x && mouseX < d.x+d.w && mouseY > d.y && mouseY < d.y+d.h) {
      //f2 = (get(mouseX, mouseY));
    //}
  }
}
class Cell {
  float x, y, w, h;
  int c;

  Cell (float tempX, float tempY, float tempW, float tempH, int tempC) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    c = tempC;
  }
  void display() {
    noStroke();
    fill(rectCol[c]);
    rect(x, y, w, h);
  }
}

