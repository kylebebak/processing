import peasy.*;

PeasyCam cam;

void setup() {
  size(400,400,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1000);
}
void draw() {
  rotateX(-.5);
  rotateY(-.5);
  background(0);
  fill(255,0,0);
  box(30);
  pushMatrix();
  translate(0,0,20);
  fill(0,0,255);
  box(5);
  popMatrix();
}


/***********
left-drag to rotate
mouse wheel, or right-drag up and down to zoom
middle-drag (cmd-left-drag on mac) to pan
double-click to reset 
************/
