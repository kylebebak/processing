PImage img;
float x, y, r;

void setup() {
  background(0);
  size(800, 600);
  smooth();
  fill(0, 255, 255, 1);
  stroke(0, 255, 255, 35);

  x=random(0, width);
  y=random(0, height);
  for (int i=0; i<2500; i++) {
    r=random(20, 200);
    x+=random(-r, r);
    y+=random(-r, r);
    x=constrain(x, 0, width);
    y=constrain(y, 0, height);
    ellipse(x, y, r, r);
  }
  img=get();
  noFill();
  stroke(255,255,0);
  imageMode(CENTER);
}

void draw() {
  if ( frameCount % 10 == 0 ) {
  background(img);
 image(img, width/2, height/2, 200, 200);
  }
 
rect(random(0,width),random(0,height),random(5,25),random(5,25));
  
}
