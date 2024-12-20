//make piles only on their own colors

int numTermites=3;
float[] x, y;
int xi, yi; //positions of invisible termites piling things up
int x10, x11, x20, x22, x30, x33, y10, y11, y20, y22, y30, y33;
//temporary looping integers
float[] vx, vy; //velocity of termites
float sp, ang; //random variables to make them move around the map
boolean[] carry=new boolean[numTermites]; //are they carrying wood chips or not

color[] colors= {
  #FF0000, #CF00FF, #02FFDF
};
String[] colorNames= {
  "red", "magenta", "teal"
};
//make sure colors and colorNames are the same size as numTermites
color woodColor1=#FFFFFF;
color woodColor2=#050505; //almost black, invisible but distinguishable from background
color woodColor=woodColor1;
color backgroundColor=#000000;


int xt, yt; //temporary integers for populating screen with wood chips

int startvalue=5000; //number of chips of each color at the start or after a reset
int newChips=20; //number of new wood chips per frame
int iterations=2000; //number of times termites move per frame
float shake=0; //for shaking the screen up and unpiling the wood chips
float R=50;
float distR, wratio, hratio, mx, my; //for corralling one one of the termites, make this interactive
boolean mouseCenter;

float shakex=0;
float shakey=0;

PFont font;

PGraphics pg;
PImage img;



void setup() {
  size(800, 600);
  background(backgroundColor);

  x=new float[numTermites];
  y=new float[numTermites];
  vx=new float[numTermites];
  vy=new float[numTermites];

  pg = createGraphics(400, 300, P2D);
  pg.background(backgroundColor);

  pg.loadPixels();

  for (int k=0; k<colors.length; k++) {
    for (int i=0; i<startvalue; i++) {
      xt=(int)random(0, pg.width);
      yt=(int)random(0, pg.height);
      pg.pixels[xt+yt*pg.width] = colors[k];
    }
  }

  pg.updatePixels();

  for (int i=0; i<x.length; i++) {
    x[i]=random(0, width);
    y[i]=random(0, height);
    sp=random(.5, 1.5);
    ang=random(0, 2*PI);
    vx[i]=sp*cos(ang);
    vy[i]=sp*sin(ang);
  }

  wratio=width/(float)pg.width;
  hratio=height/(float)pg.height;

  font=loadFont("EurostileBold-48.vlw");
}



void draw() {

  if (keyPressed) {
    if (key == '=') newChips+=1;
    if (key == '-') newChips-=1;
    if (key == '0') newChips=0;
  }

  if (newChips>=0) for (int c=0; c<newChips; c++)
    pg.set((int)random(0, pg.width), (int)random(0, pg.height), woodColor);
  else for (int c=0; c<abs(newChips); c++)
    pg.set((int)random(0, pg.width), (int)random(0, pg.height), backgroundColor);


  if (mousePressed) if (mouseEvent.getButton()==MouseEvent.BUTTON3) { 
    mx=mouseX/wratio;
    my=mouseY/hratio;
    mouseCenter=true;
  }


  for (int c=0; c<iterations; c++) {


    if (mouseCenter) {
      if ( dist(mx, my, x[0], y[0]) - R > 0) {
        y[0]=mx;
        x[0]=my;
      }
    }


    for (int i=0; i<x.length; i++) {
      x[i]+=vx[i];
      y[i]+=vy[i];
      if (x[i]>=pg.width) x[i]=0;
      if (x[i]<0) x[i]=pg.width-1;
      if (y[i]>=pg.height) y[i]=0;
      if (y[i]<0) y[i]=pg.height-1;


      xi=constrain(round(x[i]), 0, pg.width-1);
      yi=constrain(round(y[i]), 0, pg.height-1);

      color ct=pg.get(xi, yi);
      if ( !carry[i] && ct != backgroundColor ) {
        if (ct == woodColor1 || ct == woodColor2 || ct == colors[i]) {
          pg.set(xi, yi, backgroundColor);
          carry[i]=true;
        }
        else for (int k=0; k<colors.length; k++) {
          if (k != i && ct == colors[k]) {
            int neighbors=0;

            x10=looper(xi-1, pg.width);
            x11=looper(xi+1, pg.width);
            x20=looper(xi-2, pg.width);
            x22=looper(xi+2, pg.width);
            y10=looper(yi-1, pg.height);
            y11=looper(yi+1, pg.height);
            y20=looper(yi-2, pg.height);
            y22=looper(yi+2, pg.height);

            if (pg.get(x10, yi) == colors[k]) neighbors+=1;
            if (pg.get(x11, yi) == colors[k]) neighbors+=1;
            if (pg.get(xi, y10) == colors[k]) neighbors+=1;
            if (pg.get(xi, y11) == colors[k]) neighbors+=1;
            if (pg.get(x10, y10) == colors[k]) neighbors+=1;
            if (pg.get(x11, y10) == colors[k]) neighbors+=1;
            if (pg.get(x10, y11) == colors[k]) neighbors+=1;
            if (pg.get(x11, y11) == colors[k]) neighbors+=1;

            if (pg.get(x20, yi) == colors[k]) neighbors+=1;
            if (pg.get(x22, yi) == colors[k]) neighbors+=1;
            if (pg.get(xi, y20) == colors[k]) neighbors+=1;
            if (pg.get(xi, y22) == colors[k]) neighbors+=1;

            if ( (random(0, 1) / (neighbors+1)) > .1 ) {
              pg.set(xi, yi, backgroundColor);
              carry[i]=true;
            }
          }
        }

        sp=random(.5, 1.5);
        ang=random(0, 2*PI);
        vx[i]=sp*cos(ang);
        vy[i]=sp*sin(ang);
      }


      if (carry[i]) {
        x10=looper(xi-1, pg.width);
        x11=looper(xi+1, pg.width);
        x20=looper(xi-2, pg.width);
        x22=looper(xi+2, pg.width);
        x30=looper(xi-3, pg.width);
        x33=looper(xi+3, pg.width);

        y10=looper(yi-1, pg.height);
        y11=looper(yi+1, pg.height);
        y20=looper(yi-2, pg.height);
        y22=looper(yi+2, pg.height);
        y30=looper(yi-3, pg.height);
        y33=looper(yi+3, pg.height);

        if ( pg.get(x10, yi) == colors[i] ||
          pg.get(x11, yi) == colors[i] ||
          pg.get(xi, y10) == colors[i] ||
          pg.get(xi, y11) == colors[i] ) {

          if ( pg.get(x20, yi) == colors[i] ||
            pg.get(x22, yi) == colors[i] ||
            pg.get(xi, y20) == colors[i] ||
            pg.get(xi, y22) == colors[i] || 
            pg.get(x10, y10) == colors[i] ||
            pg.get(x11, y10) == colors[i] ||
            pg.get(x10, y11) == colors[i] ||
            pg.get(x11, y11) == colors[i] ) { 

            if ( pg.get(x30, yi) == colors[i] ||
              pg.get(x33, yi) == colors[i] ||
              pg.get(xi, y30) == colors[i] ||
              pg.get(xi, y33) == colors[i] ||

              pg.get(x20, y10) == colors[i] ||
              pg.get(x20, y11) == colors[i] ||
              pg.get(x22, y10) == colors[i] ||
              pg.get(x22, y11) == colors[i] ||

              pg.get(x10, y20) == colors[i] ||
              pg.get(x11, y20) == colors[i] ||
              pg.get(x10, y22) == colors[i] ||
              pg.get(x11, y22) == colors[i] ) { 

              pg.set(xi, yi, colors[i]);
              carry[i]=false;


              sp=random(.5, 1.5);
              ang=random(0, 2*PI);
              vx[i]=sp*cos(ang);
              vy[i]=sp*sin(ang);
            }
          }
        }
      }
    }
  }
  
  mouseCenter=false;

  img=pg.get();
  background(backgroundColor);

  image(img, shakex, shakey, width, height);


  if (mousePressed) if (mouseEvent.getButton()==MouseEvent.BUTTON3) {
    smooth();
    noFill();
    stroke(255);
    ellipse(mouseX, mouseY, 2*R*wratio, 2*R*hratio);
    noSmooth();
  }


  textFont(font, 16);
  fill(0);
  textAlign(CENTER, CENTER);
  text(newChips, width-51, height-50);
  text(newChips, width-50, height-51);
  text(newChips, width-49, height-50);
  text(newChips, width-50, height-49);
  fill(255);
  text(newChips, width-50, height-50);

  shake-=5;
  shake=max(shake, 0);

  if (shakex>0) shakex=max(0, shakex-.5);
  if (shakex<0) shakex=min(0, shakex+.5);
  if (shakey>0) shakey=max(0, shakey-.5);
  if (shakey<0) shakey=min(0, shakey+.5);
}



void mouseDragged() {
  shake+=dist(mouseX, mouseY, pmouseX, pmouseY) / 5;
  shakex+=(mouseX-pmouseX)/10;
  shakey+=(mouseY-pmouseY)/10;
  shakex=constrain(shakex, -20, 20);
  shakey=constrain(shakey, -20, 20);
}



void mouseReleased() {
  pg.loadPixels();

  int counter=0;
  float prob=shake/300;

  println("shake % = " + 100*shake/300);

  for (int i=0; i<pg.width; i++) {
    for (int j=0; j<pg.height; j++) {

      if ( pg.pixels[i+j*pg.width] != backgroundColor ) {
        if ( prob > random(0, 1) ) {
          pg.pixels[i+j*pg.width]=backgroundColor;
          counter+=1;
        }
      }
    }
  }

  for (int i=0; i<counter; i++) {
    xt=(int)random(0, pg.width);
    yt=(int)random(0, pg.height);
    pg.pixels[xt+yt*pg.width] = woodColor;
  }

  pg.updatePixels();
  shake=0;
  shakex=0;
  shakey=0;
}



void keyReleased() {
  if (key == 'q') {
    int[] counter=new int[numTermites];
    int pixelNum;

    pg.loadPixels();
    for (int i=0; i<pg.width; i++) for (int j=0; j<pg.height; j++) {
      pixelNum=i+j*pg.width;

      for (int k=0; k<colors.length; k++)
        if ( pg.pixels[pixelNum] == colors[k] ) counter[k]+=1;
    }

    for (int k=0; k<colors.length; k++)
      println("# " + colorNames[k] + " = " + counter[k]);
  }

  if (key == 'r') {
    pg.background(backgroundColor);

    for (int k=0; k<colors.length; k++) {
      for (int i=0; i<startvalue; i++) {
        xt=(int)random(0, pg.width);
        yt=(int)random(0, pg.height);
        pg.set(xt, yt, colors[k]);
      }
    }
  }

  if (key == 't') {
    if (woodColor == woodColor1) woodColor=woodColor2;
    else woodColor = woodColor1;
  }
}



int looper(int pos, int dim) {
  if (pos>=dim) pos=0;
  if (pos<0) pos=dim-1;
  return pos;
}

