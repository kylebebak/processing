float x, y;
boolean type=true;

void setup() {
  size(1200, 600);
  smooth();
  noFill();
  background(0);
  stroke(#00FFFF);
  noLoop();
}

void draw() {

  for (int i=0; i<200; i++) {
    pushMatrix();
    if (!type) {
      x=noise(random(2*i-1, 2*i+1));
      y=noise(random(i+9, i+11));
      translate(width*x, height*y);
    } 
    else {
      x=random(3);
      y=random(3);
      translate(x*width/3, y*height/3);
    }
    rotate(2*PI*noise(x+y));
    ellipse(0, 0, 100*noise(2*(x+y), 2*(x-y)), 100*noise(2*(x-y), 2*(x+y)));
    popMatrix();
  }
  
  filter(BLUR);
}



void keyReleased() {
  if (key == 'b') background(0);
  redraw();
}

void mouseReleased() {
  type=!type;
}

