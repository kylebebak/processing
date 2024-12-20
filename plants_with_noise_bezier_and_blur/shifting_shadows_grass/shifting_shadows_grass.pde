PGraphics pg;
PImage img;


void setup() {
  img=loadImage("grass.jpeg");
  int w=600;
  size(w, w*img.height/img.width);

  //size(500, 500);
  img.resize(width, height);

  smooth();

  pg=createGraphics(width/2, height/2, JAVA2D);
  /*this PGraphics gets resized when it's called as an image.
   the smaller it is here the less slowdown there is
   when the gaussian blur gets called. even though i'm only
   interested in blurring the branches, the blur function blurs
   the whole image, most of which is just a homogenous background...
   if i wanted to optimize i could maybe make a blur function
   which ignored pixels whose color is the same as the background
   and effectively just blur the branches*/
  
  /*
  copy(img, 0, height/4, width, 3*height/4, 
  0, 0, width, height);
  img=get();
  */
}


void draw() {



  pg.beginDraw();

  pg.background(0, 0);
  /*when background is called, it's not equivalent to calling a
   a rectangle with the width and height of the screen. rather, i think
   it sets the color information of all the pixels on the screen
   to whatever color is specified in the background call.
   JAVA2D is used as the renderer for the PGraphics in this sketch because P2D
   ignores alpha values for background calls*/
   

  /*void drawBranch(float x, float y, float x1, float y1, float w, 
   float curvature, float sway, float n,
   int joints, float numBranches, float numLeaves, float leafSize, PGraphics pg)*/


  drawBranch(-.5*pg.width, .65*pg.height, .9*pg.width, .2*pg.height, 5, 
  -.03, 1, 2*sq( -.5 + noise(0, 0, frameCount*.025) ), 
  2, 5, 4, 20, pg );
  pg.filter(BLUR, 1);
  drawBranch(-.2*pg.width, .9*pg.height, .7*pg.width, .65*pg.height, 3, 
  .02, 1.25, .5*( -.5 + noise(0, frameCount*.025) ), 
  2, 4, 3, 15, pg );
  pg.filter(BLUR, 1);
  drawBranch(-.1*pg.width, .3*pg.height, .6*pg.width, .5*pg.height, 1.5, 
  -.025, 1.5, .5*( -.5 + noise(frameCount*.025) ), 
  2, 3, 2, 12, pg );
  drawBranch(.2*pg.width, 1.2*pg.height, .5*pg.width, .5*pg.height, 1.5, 
  .025, 1.5, .5*( -.5 + noise(frameCount*.025, frameCount*.025) ), 
  2, 3, 3, 10, pg );
  /*bigger shadows are blurred more, correspdoding to branches
   higher up in the tree. smaller shadows are sharper, corresponding
   to branches/reeds/whatever that are closer to the ground.
   the biggest branches are drawn first and the smaller ones later on,
   and blur filters are progessively to so that the branches
   drawn first are blurred more times than the ones drawn later*/

  pg.endDraw();


  background(img); //equivalent to calling set(0, 0, img);
  image(pg, 0, 0, width, height);
}








/*use this to recursively draw branches with leaves coming off the end
 of them*/

void drawBranch(float x, float y, float x1, float y1, float w, 
float curvature, float sway, float n, 
int joints, float numBranches, float numLeaves, float leafSize, PGraphics pg)
{
  float len=dist(x, y, x1, y1);
  drawBranchT(x, y, x1, y1, len, w, 
  curvature, sway, n, joints, numBranches, numLeaves, leafSize, pg);
}
void drawBranchT(float x, float y, float x1, float y1, float len, float w, 
float curvature, float sway, float n, 
int joints, float numBranches, float numLeaves, float leafSize, PGraphics pg)
{
  pg.smooth();

  float xx1=.75*x+.25*x1;
  float xx2=.25*x+.75*x1;
  float yy1=.75*y+.25*y1;
  float yy2=.25*y+.75*y1;
  float co=(y1-y)/dist(x, y, x1, y1), si=-(x1-x)/dist(x, y, x1, y1);

  float x11=x1+n*sway*len*co;
  float y11=y1+n*sway*len*si;
  float c=curvature*len;

  pg.noFill();
  pg.stroke(0, 130);
  pg.strokeWeight(w);

  pg.bezier(x, y, 
  xx1+co*c, yy1+si*c, 
  xx2+co*c, yy2+si*c, 
  x11, y11);



  if (joints>1) {
    joints--;

    float lenFrac=.40;
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
      .5*curvature, sway, .5*n+.5*(-.5+noise(.1*joints, .05*i)), 
      joints, numBranches, numLeaves, leafSize, pg );

      a-=PI/2;

      drawBranch(xt, yt, xt+lent*cos(a), 
      yt+lent*sin(a), .5*w, 
      -.5*curvature, sway, .5*n+.5*(-.5+noise(.1*joints, .05*i)), 
      joints, numBranches, numLeaves, leafSize, pg );
    }
  } 

  else if (joints==1) {

    pg.noStroke();
    pg.fill(0, 85);

    for (int i=0; i<(int)numLeaves; i++) {

      float xt=bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      (i+1)/ (numLeaves+1));
      float yt=bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      (i+1)/ (numLeaves+1));
      float a=atan2( bezierPoint(y, yy1+si*c, yy2+si*c, y11, 
      .001+(i+1)/ (numLeaves+1)) - yt, 
      bezierPoint(x, xx1+co*c, xx2+co*c, x11, 
      .001+(i+1)/ (numLeaves+1)) - xt );

      float sizeLeaf=leafSize/pow( (float)i + .5, .5);
      float wl=sizeLeaf/5; //width of leaf
      float c1=sizeLeaf*.015, c2=sizeLeaf*(-.015);

      for (int j=0; j<2; j++) {

        if (j==0) a+=PI/4;
        if (j==1) a-=PI/2;

        float x1l=xt+sizeLeaf*cos(a), y1l=yt+sizeLeaf*sin(a);
        float xx1l=.75*xt+.25*x1l, xx2l=.25*xt+.75*x1l;
        float yy1l=.75*yt+.25*y1l, yy2l=.25*yt+.75*y1l;
        co=(y1l-yt)/dist(xt, yt, x1l, y1l);
        si=-(x1l-xt)/dist(xt, yt, x1l, y1l);



        pg.beginShape();

        pg.vertex(xt+co*wl/4, yt+si*wl/4);
        pg.bezierVertex(
        xx1l+co*(c1+wl), yy1l+si*(c1+wl), 
        xx2l+co*(c1+wl/.75), yy2l+si*(c1+wl/.75), 
        x1l, y1l);
        pg.bezierVertex(
        xx2l+co*(c2-wl/.75), yy2l+si*(c2-wl/.75), 
        xx1l+co*(c2-wl), yy1l+si*(c2-wl), 
        xt-co*wl/4, yt-si*wl/4);
        pg.endShape(CLOSE);
      }
    }
  }
}

