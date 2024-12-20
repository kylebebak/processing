PShape sh;
PShape ch;

void setup() {
  size(1200, 700);
  smooth();
  sh = loadShape("map.svg");
  println(sh.getVertexCount());
  ch=sh.getChild("OR");
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


  ch=sh.getChild("CA");
  ch.disableStyle();
  fill(0, 0, 255);
  shape(ch, 500, 0);
  ch=sh.getChild("OH");
  ch.disableStyle();
  fill(255, 0, 0);
  shape(ch, 0, 0);
}

