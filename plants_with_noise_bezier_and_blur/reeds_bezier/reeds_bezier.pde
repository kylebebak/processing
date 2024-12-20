PImage img;
float[] x, h, curvature, sway;
float n;
color reedColor;
int num=75;



void setup() {
  size(500, 500);
  smooth();
  noStroke();


  colorMode(HSB, 360, 100, 100);
  float H0=250, dH=135;
  float sx=.5*width, sy=height;

  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {

      float h=(H0+j*dH/height) % 360 ;
      float b=dist( (float)i, (float)j, sx, sy );
      b=90-65*b/height;
      color c=color(h, 100, b);
      set(i, j, c);
    }
  }
  
  img=get();


  colorMode(RGB, 255);
  reedColor=color(10, 25, 10);

  x=new float[num];
  h=new float[num];
  sway=new float[num];
  curvature=new float[num];

  for (int i=0; i<num; i++) {
    x[i]=random(.05*width, .95*width);
    h[i]=random(.15*height, .8*height);
    curvature[i]=random(.025, .075);
    sway[i]=random(.25, .75);
  }
}



void draw() {

  set(0, 0, img);

  translate(0, height);
  scale(1, -1);
  /*invert y axis, starts at bottom going up*/

  n=-.5+noise(frameCount*.005);

  for (int i=0; i<num; i++) {
    
    float dn=(x[i]-width/2)/width;
    float nn=(-.5*noise(.05*i, .005*frameCount))/1.5;
    
    drawReed(n+dn+nn, x[i], h[i],
    curvature[i], sway[i],
    reedColor);
  }
}



void drawReed(float n, float x, float h, 
float curvature, float sway, 
color col) {
  /*curvature should be between -.2 and .2, more or less
   sway should be between 0 and 1
   n should be noise, shifted so that is oscillates between -.5 and .5
   x is horizontal location, h is height, col is color of reed
   
   translate(0, height);
   scale(1, -1);
   
   this above code must be used to invert y axis when using drawReed*/

  fill(col);
  float x1=x+n*sway*h;
  float c=curvature*h;

  beginShape();

  vertex(x, 0);
  bezierVertex(
  x+c, h/4, 
  x+c, 3*h/4, 
  x1, h);
  bezierVertex(
  x+c/2, 3*h/4, 
  x+c/2, h/4, 
  x-c/2, 0);

  endShape(CLOSE);
}

