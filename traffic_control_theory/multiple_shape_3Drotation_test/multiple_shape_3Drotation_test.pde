PGraphics pg;

void setup() {
 size(400, 400, P3D); 
  rectMode(CENTER);
  pg = createGraphics(20, 20, P3D);
}



void draw() {
  background(0);
  
  fill(127);
  pushMatrix();
  rotateX(PI/6);
  rotateY(PI/4);
  rotateZ(PI/10);
  //rotateY(PI/6);
  rect(.5*width, .5*height, 200, 200);
  popMatrix();
  
  pushMatrix();
  fill(0, 255, 0);
  rotateX(PI/6);
  rotateY(PI/4);
  rotateZ(PI/10);
  ellipse(200, 250, 50, 50);
  
  
  fill(0, 0, 255);
  rotateX(.0001);
  ellipse(265, 200, 50, 50);
  popMatrix();
  
  pg.beginDraw();
  pg.background(0, 0);
  pg.fill(255);
  
  pg.ellipse(10, 10, 10, 10);
  pg.endDraw();
  
  image(pg, 300, 250);
  set(200, 250, pg.get());
}
