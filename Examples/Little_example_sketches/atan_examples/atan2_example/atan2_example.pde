void draw() {
  background(0);
  float a = atan2(mouseY-height/2, mouseX-width/2);
  float b = atan2(mouseY, mouseX);
  
  
  translate(width/2, height/2);
  
  if (mousePressed) println(b);
  
  rotate(a);
  rect(-12, -5, 24, 10);
  
}
