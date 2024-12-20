/*i need to comment this sketch,
it's full of magic constants,
the math is fairly heavy and it takes
too long to understand how it works*/

void setup() {
  size(700, 500);
  smooth();

  frameRate(15);
}


void draw() {

  //fill(0, 25);
  //rect(0, 0, width, height);
  background(0);
  
  drawBranch(0, height, .85*width, .3*height, 8, 
  .015, .75, .4, 3, 5, 3, 1*( -.5 + noise(frameCount*.025) ) );
  
  drawBranch(width/3, 0, .85*width, .8*height, 4, 
  -.03, 1, .35, 2, 8, 4, 2*sq( -.5 + noise(0, frameCount*.025) ) );
} 



/*use this to recursively draw branches with leaves coming off the end
 of them*/

void drawBranch(float x, float y, float x1, float y1, float w, 
float curvature, float sway, float lenFrac,
int joints, float numBranches, float numLeaves, float noize)
{
  float len=dist(x, y, x1, y1);
  drawBranchT(x, y, x1, y1, len, w, 
  curvature, sway, lenFrac,
  joints, numBranches, numLeaves, noize);
}
void drawBranchT(float x, float y, float x1, float y1, float len, float w, 
float curvature, float sway, float lenFrac,
int joints, float numBranches, float numLeaves, float noize)
{


  float xx1=.75*x+.25*x1;
  float xx2=.25*x+.75*x1;
  float yy1=.75*y+.25*y1;
  float yy2=.25*y+.75*y1;
  float co=(y1-y)/dist(x, y, x1, y1), si=-(x1-x)/dist(x, y, x1, y1);

  float x11=x1+noize*sway*len*co;
  float y11=y1+noize*sway*len*si;
  float c=curvature*len;

  noFill();
  stroke(215, 180, 37, 200);
  strokeWeight(w);

  bezier(x, y, 
  xx1+co*c, yy1+si*c, 
  xx2+co*c, yy2+si*c, 
  x11, y11);



  if (joints>1) {
    joints--;

    for (int i=0; i<(int)numBranches; i++) {

      float xt=bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      (i+1)/ (numBranches+1));
      float yt=bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      (i+1)/ (numBranches+1));
      float a=atan2( bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      .001+(i+1)/ (numBranches+1)) - yt, 
      bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      .001+(i+1)/ (numBranches+1)) - xt );

      float lent=len*lenFrac/pow( (float)i + 1, .5);
      a+=PI/4;

      drawBranch(xt, yt, xt+lent*cos(a), 
      yt+lent*sin(a), .5*w, 
      .5*curvature, sway, lenFrac, joints, numBranches, numLeaves,
      .5*noize+.5*(-.5+noise(.1*joints, .05*i)) );

      a-=PI/2;

      drawBranch(xt, yt, xt+lent*cos(a), 
      yt+lent*sin(a), .5*w, 
      -.5*curvature, sway, lenFrac, joints, numBranches, numLeaves,
      .5*noize+.5*(-.5+noise(.1*joints, .05*i)) );
    }
  } 

  else if (joints==1) {

    noStroke();
    fill(0, 255, 0, 150);

    for (int i=0; i<(int)numLeaves; i++) {

      float xt=bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      (i+1)/ (numLeaves+1));
      float yt=bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      (i+1)/ (numLeaves+1));
      float a=atan2( bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      .001+(i+1)/ (numLeaves+1)) - yt, 
      bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      .001+(i+1)/ (numLeaves+1)) - xt );

      float sizeLeaf=20/pow( (float)i + .5, .25);
      float wl=5; //width of leaf
      float c1=sizeLeaf*.015, c2=sizeLeaf*(-.015);

      for (int j=0; j<2; j++) {

        if (j==0) a+=PI/4;
        if (j==1) a-=PI/2;

        float x1l=xt+sizeLeaf*cos(a), y1l=yt+sizeLeaf*sin(a);
        float xx1l=.75*xt+.25*x1l, xx2l=.25*xt+.75*x1l;
        float yy1l=.75*yt+.25*y1l, yy2l=.25*yt+.75*y1l;
        co=(y1l-yt)/dist(xt, yt, x1l, y1l);
        si=-(x1l-xt)/dist(xt, yt, x1l, y1l);



        beginShape();

        vertex(xt+co*wl/4, yt+si*wl/4);
        bezierVertex(
        xx1l+co*(c1+wl), yy1l+si*(c1+wl), 
        xx2l+co*(c1+wl/.75), yy2l+si*(c1+wl/.75), 
        x1l, y1l);
        bezierVertex(
        xx2l+co*(c2-wl/.75), yy2l+si*(c2-wl/.75), 
        xx1l+co*(c2-wl), yy1l+si*(c2-wl), 
        xt-co*wl/4, yt-si*wl/4);
        endShape(CLOSE);
      }
    }
  }
}
