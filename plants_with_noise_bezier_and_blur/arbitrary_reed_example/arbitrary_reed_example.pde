float n;

void setup() {
  size(400, 400);
  smooth();
}



void draw() {

  background(0);

  n=-.5+noise(frameCount*.05, frameCount*.05, frameCount*.05);



  drawFern(200, 0, 200, 200, 10, 
  .25, .25, .5, 0, n);

  drawFern(0, 200, 200, 200, 10, 
  -.05, .05, .75, 10, n);
}



void drawFern(float x, float y, float x1, float y1, float w, 
float curvature1, float curvature2, float sway, int joints, float n)
{
  float len=dist(x, y, x1, y1);
  drawFernT(x, y, x1, y1, len, w, 
  curvature1, curvature2, sway, joints, n);
}
void drawFernT(float x, float y, float x1, float y1, float len, float w, 
float curvature1, float curvature2, float sway, int joints, float n)
{


  float xx1=.75*x+.25*x1;
  float xx2=.25*x+.75*x1;
  float yy1=.75*y+.25*y1;
  float yy2=.25*y+.75*y1;
  float co=(y1-y)/dist(x, y, x1, y1), si=-(x1-x)/dist(x, y, x1, y1);

  float x11=x1+n*sway*len*co;
  float y11=y1+n*sway*len*si;
  if (curvature2>curvature1) {
    float ct=curvature2;
    curvature2=curvature1;
    curvature1=ct;
  }
  float c1=curvature1*len;
  float c2=curvature2*len;


  noStroke();
  fill(0, 255, 0);
  beginShape();

  vertex(x+co*w/2, y+si*w/2);
  bezierVertex(
  xx1+co*(c1+w/3), yy1+si*(c1+w/3), 
  xx2+co*(c1+w/4), yy2+si*(c1+w/4), 
  x11, y11);
  bezierVertex(
  xx2+co*(c2-w/3), yy2+si*(c2-w/3), 
  xx1+co*(c2-w/4), yy1+si*(c2-w/4), 
  x-co*w/2, y-si*w/2);
  endShape(CLOSE);
}

