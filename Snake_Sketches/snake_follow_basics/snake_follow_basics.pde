float len=20;
float baseLength=len;
int segs=15;

float x0, y0;
float[] x=new float[segs];
float[] y=new float[segs];
float angle;

boolean dragged;
float easing=.05;
float baseEasing=easing;



void setup() {
  size(1200, 600);
  smooth();

  x0=random(0, width);
  x[0]=x0;
  y0=random(0, height);
  y[0]=y0;
}



void draw() {

  fill(0, 75);
  noStroke();
  rect(0, 0, width, height);

  strokeWeight(10);
  stroke(0, 255, 255, 50);

  angle = atan2(mouseY-y[0], mouseX-x[0]);

  if (!mousePressed) {
    dragged=false;
    len = baseLength;
    easing = baseEasing;
  }

  if (dragged) {
    x0=mouseX-len*cos(angle);
    y0=mouseY-len*sin(angle);
    float speed=dist(mouseX, mouseY, pmouseX, pmouseY);
    speed=sqrt(speed);
    len += .2 * speed;
    easing = baseEasing + .005 * speed;

    float proximity=dist(x0, y0, x[0], y[0]);
    if (proximity < 200) len -= 5  /  sqrt(proximity);

    len=max(baseLength, len);
  }


  x[0] += easing * (x0-x[0]);
  y[0] += easing * (y0-y[0]);
  if (abs(x0-x[0]) < 2 ) x[0]=x0;
  if (abs(y0-y[0]) < 2 ) y[0]=y0;


  pushMatrix();
  translate(x[0], y[0]);
  rotate(angle);
  line(0, 0, len, 0);
  popMatrix();

  for (int i=0; i<segs-1; i++) {

    angle = atan2(y[i]-y[i+1], x[i]-x[i+1]);

    x[i+1]=x[i]-len*cos(angle);
    y[i+1]=y[i]-len*sin(angle);

    pushMatrix();
    translate(x[i+1], y[i+1]);
    rotate(angle);
    line(0, 0, len, 0);
    popMatrix();
  }
}

void mouseDragged() {
  dragged=true;
}

void mouseReleased() {
  x0=mouseX-len*cos(angle);
  y0=mouseY-len*sin(angle);
}

