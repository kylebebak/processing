PGraphics normalImage;
PImage glowImage;

void setup() {
  size(500,500);
  normalImage = createGraphics(width,height,JAVA2D);
  normalImage.beginDraw();
  normalImage.smooth();
  normalImage.stroke(255); 
  normalImage.strokeWeight(2); 
  normalImage.endDraw();
}

void draw() {
  background(0);
  glowImage = normalImage.get();
  glowImage.resize(0,width/4);
  glowImage.filter(BLUR,2);
  glowImage.resize(0,width);
  image(glowImage,0,0);
  image(normalImage,0,0);
}

void mouseDragged() {
  normalImage.beginDraw();
  normalImage.line(mouseX,mouseY,pmouseX,pmouseY);
  normalImage.endDraw();
}
