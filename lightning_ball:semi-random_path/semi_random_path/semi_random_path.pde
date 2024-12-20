float x0, y0, x1, y1;
int num=15;

float da=PI/4;

void setup() {
  size(500, 500);
  smooth();
  
  //starting coordinates
  x0=4*width/5;
  y0=2*height/5;
  //target coordinates
  x1=width/5;
  y1=2*height/5;

  fill(255, 0, 0);
  ellipse(x0, y0, 8, 8);
  ellipse(x1, y1, 8, 8);

  strokeWeight(4);
  stroke(0, 100);

  for (int i=0; i<num; i++) {
    float len=dist(x0, y0, x1, y1);
    float a=atan2(y1-y0, x1-x0);
    len=random(len/2, 3*len/2) / (num + 1 -i);
    a=random(a-da, a+da);

    float xx=x0+len*cos(a), yy=y0+len*sin(a);
    line(x0, y0, xx, yy);
    x0=xx;
    y0=yy;
  }
  line(x0, y0, x1, y1);
}

void draw() {
}

