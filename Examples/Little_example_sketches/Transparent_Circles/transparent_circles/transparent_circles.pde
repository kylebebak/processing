float x;
float y;
float r;

void setup() {
  
  size(700, 700);
  smooth();
  noLoop();
  
  background(0);
  
  x=random(width/4, 3*width/4);
  y=random(height/4, 3*height/4);
  
  for (int i=0; i<100; i++) {
    r=random(150, 400);
    ellipse(x, y, r, r);
    x+=random(-25, 25);
    y+=random(-25, 25);
  }
}

void draw() {
  
  stroke(0, 255, 255);
  fill(0, 255, 255, 7);
  
  x=mouseX;
  y=mouseY;

  background(0);

  for (int i=0; i<100; i++) {
    r=random(150, 400);
    ellipse(x, y, r, r);
    x+=random(-25, 25);
    y+=random(-25, 25);
  }
}

void mouseReleased() {
 redraw(); 
}

