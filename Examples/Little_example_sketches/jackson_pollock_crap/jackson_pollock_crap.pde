float x;
float y;
float r=0;
boolean moved=false;

void setup() {
  size(500, 500);
  smooth();
  background(0);
  
  x=width/2;
  y=height/2;
}


void draw() {

  if (mouseX != pmouseX || mouseY != pmouseY) {
    x=mouseX;
    y=mouseY;
    moved=true;
  }

  r++;

  if ( moved==true ) {
    stroke(175, 0, 0);
    line(pmouseX, pmouseY, mouseX, mouseY);
    stroke(0, 255, 255);
    fill(0, 255, 255, 50);
    //ellipse(x, y, 250*(1-exp(-r/200)), 250*(1-exp(-r/200)));
    ellipse(x, y, pow(r,1.25), pow(r,1.25));
    r=0;
  }
  
  if (mousePressed) background(0);

  moved=false;
}

