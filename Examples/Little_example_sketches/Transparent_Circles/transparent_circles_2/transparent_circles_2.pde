float x;
float y;
float r;

void setup() {

  size(700, 700);
  smooth();
}

void draw() {

  noStroke();
  fill(0, 40);
  rect(0, 0, width, height);

  stroke(0, 255, 255);
  fill(0, 255, 255, 7);


  x=random(x-50, x+50);
  x=constrain(x, 0, width);
  y=random(y-50, y+50);
  y=constrain(y, 0, height);

  for (int i=0; i<50; i++) {
    r=random(150, 400);
    ellipse(x, y, r, r);
    x+=random(-25, 25);
    y+=random(-25, 25);
  }
}

