import peasy.*;

PeasyCam cam;

int N = 20;
float boxSpacing;
float boxSize;

void setup() {
  background(0);
  size(800, 800, P3D);
  
  boxSpacing = .5*width / (float)N;
  boxSize = boxSpacing / 4.0;
  
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(25);
  cam.setMaximumDistance(2500);
}


void draw() {
  background(0);
  strokeWeight(1);
  noStroke();
  // stroke(255);
  fill(0, 255, 255, 25);
  println(frameRate);
  
  rotateX(-.5);
  rotateY(-.5);
  translate(0, -height/2.0);

  for (int i = 0; i < N; i++) {

    for (int j = 0; j < N; j++) {

      for (int k = 0; k < N; k++) {

        translate(0, 0, boxSpacing);
        box(boxSize);
      }

      translate(0, 0, -N * boxSpacing);
      translate(0, boxSpacing, 0);
    }

    translate(0, -N * boxSpacing, 0);
    translate(boxSpacing, 0, 0);
  }
}



/***********
left-drag to rotate
mouse wheel, or right-drag up and down to zoom
middle-drag (cmd-left-drag on mac) to pan
double-click to reset 
************/

