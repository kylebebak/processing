PShape sh;
PShape ch;

void setup() {
  size(1200, 700);
  smooth();
  sh = loadShape("man.svg");
  println(sh.getVertexCount());
  ch=sh.getChild(1);
  println(ch.getVertexCount());
}

void draw() {

  background(204);
  float zoom=abs(mouseX-width/2);
  zoom=map(zoom, 0, width, .1, 5);
  //sh.disableStyle();
  //fill(255, 0, 0);
  shapeMode(CENTER);
  
  pushMatrix();
  translate(width/2, height/2);
  scale(zoom);
  shape(sh);
  popMatrix();


  ch.disableStyle();
  fill(255, 0, 0);
  shape(ch, width*noise(.01*frameCount), height*noise(.01*frameCount,.01*frameCount));
}

