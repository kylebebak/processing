PShape logo;
PShape current;

float lowerbound;
float upperbound;

void setup() {
  size(215,270); 
  logo = loadShape("logo.svg"); 
  smooth();
}

void draw() {
  background(22,22,22,22);
  //logo = loadShape("logo.svg");
  
  upperbound = dist(mouseX, mouseY, width/2, height/2) / 50;
  
  for (int i = 0; i < logo.getChildCount(); i = i + 1) {
    
    current = logo.getChild(i);
    
    pushMatrix();
    
    //current.translate(random(-upperbound, upperbound), random(-upperbound, upperbound));
    translate(random(-upperbound, upperbound), random(-upperbound, upperbound));
    shape(current);
    
    popMatrix();
  }
  
  println(frameRate);
  
}
