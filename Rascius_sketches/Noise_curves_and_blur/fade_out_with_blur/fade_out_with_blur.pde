void setup() {
  background(0);
  size(500, 500);
  frameRate(20);
  rectMode(CENTER);
  rect(width/2,height/2,300,300);
}

void draw() { 
 
 //rect(20, 20, 10, 10);
 filter(BLUR);
}
