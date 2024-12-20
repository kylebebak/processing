float n;

void setup() {
  size(1200, 700);
  smooth();
}


void draw() {

  //fill(0, 25);
  //rect(0, 0, width, height);
  background(0);

  n=-.5+noise(frameCount*.005);

  drawFern(0, height, .85*width, .3*height, 15, 
  .015, -.015, .75, 4, .75*( -.5 + noise(frameCount*.025) ) );

  drawFern(width, height, .6*width, .15*height, 25, 
  .015, .015, 1.25, 4, 1.0*( -.5 + noise(frameCount*.025) ) );


  println("frameRate = " + frameRate);
} 



/*use this to recursively draw ferns, or plantlike shapes with curvey
 stems that can move*/

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
  fill(0, 255-30*joints, 0, 100+30*joints);
  beginShape();

  vertex(x+co*w/2, y+si*w/2);
  bezierVertex(
  xx1+co*(c1+w/3), yy1+si*(c1+w/3), 
  xx2+co*(c1+w/4), yy2+si*(c1+w/4), 
  x11, y11);
  bezierVertex(
  xx2+co*(c2-w/4), yy2+si*(c2-w/4), 
  xx1+co*(c2-w/3), yy1+si*(c2-w/3), 
  x-co*w/2, y-si*w/2);
  endShape(CLOSE);



  if (joints > 1) {
    joints--;

    float num=12;
    float lenFrac=.5;
    for (int i=0; i<(int)num; i++) {

      float xt=bezierPoint(x, xx1+co*(c1+c2)/2, xx2+co*(c1+c2)/2, x11, 
      (i+1)/ (num+1));
      float yt=bezierPoint(y, yy1+si*(c1+c2)/2, yy2+si*(c1+c2)/2, y11, 
      (i+1)/ (num+1));
      float a=atan2( bezierPoint(y, yy1+si*(c1+c2)/2, yy2+si*(c1+c2)/2, y11, 
      .005+(i+1)/ (num+1)) - yt, 
      bezierPoint(x, xx1+co*(c1+c2)/2, xx2+co*(c1+c2)/2, x11, 
      .005+(i+1)/ (num+1)) - xt );

      float lent=len*lenFrac/sqrt( (float)i + .5);
      a+=PI/2;


      drawFern(xt, yt, xt+lent*cos(a)*oneOrMinusOne(i), 
      yt+lent*sin(a)*oneOrMinusOne(i), .5*w, 
      curvature1, curvature2, sway, joints, n+.5*(-.5+noise(.1*joints, .05*i)) );

      /*
      drawFern(xt, yt, xt-lent*cos(a)*oneOrMinusOne(i),
       yt-lent*sin(a)*oneOrMinusOne(i), .5*w, 
       curvature1, curvature2, sway, joints, n+.5*(-.5+noise(.1*joints, .05*i)) );
       */
    }
  }
}


float oneOrMinusOne(int i) {
  if (i%2==0) return 1;
  else return -1;
}

