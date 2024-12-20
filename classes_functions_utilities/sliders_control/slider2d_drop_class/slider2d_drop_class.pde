float x=300;
float y=1;
float x1=0;
float y1=0;
Slider2D wave, displace;
//these are only variables that need initializing, toggleMove, xval, and yval for each individual slider

void setup() {
  size(500, 500);
  smooth();
  wave=new Slider2D(50, 50, 100, 150, 50, 50, 7, 25,
  50, 500, .2, 5, x, y, 
  1, 2, "wave");
  displace=new Slider2D(50, 300, 100, 150, 50, 300, 30, 10,
  -100, 100, -50, 50, x1, y1, 
  1, 2, "shift");
}


void draw() {

  background(0);

  x=wave.returnvalues()[0];
  y=wave.returnvalues()[1];

  x1=displace.returnvalues()[0];
  y1=displace.returnvalues()[1];

  float[] cosval=new float[150];
  cosval[0]=375+x/10;
  rectMode(CORNER);
  fill(0);
  stroke(255);
  rect(300, 300, 150, 150);
  stroke(255, 0, 0);
  for (int i=2; i<150; i++) {
    cosval[i]=y1+x/10*cos(y*i/10-x1/10);
    line(300+i, 375+cosval[i], 300+(i-1), 375+cosval[i-1]);
  }

  wave.update();
  wave.display();

  displace.update();
  displace.display();
}

void keyPressed() {
  wave.arrowKeysPressed();
  displace.arrowKeysPressed();
}

void keyReleased() {
  wave.arrowKeysReleased();
  displace.arrowKeysReleased();
}


//Slider2D class
class Slider2D {
  int topcornerx, topcornery, tabcornerx, tabcornery; //location, width and height
  int dimx, dimy, dim, tabdimx, tabdimy; //location of tab, width and height
  int precisionx, precisiony; //decimal precision of values displayed
  float xmin, xmax, ymin, ymax; //min and max values of x and y values
  float xval, yval, xbutton, ybutton; //x and y values returned by slider
  float ratiox, ratioy; //computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize;
  float minxpostab, maxxpostab, minypostab, maxypostab;
  color colorbox, coloractive, colorbutton, textcolor, tabcolor;
  int tabtransparency;
  boolean toggleMove; //lockout prevents 2 sliders from being activated at once
  boolean[] arrowkeys; //arrowKeysPressed/Released must be called in void keyPressed/Released()
  PFont sliderfont; //default color is white, can be changed by calling changeTextColor
  String slidername;

  boolean overtab, lockouttab, dropdown;

  Slider2D (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
  int ttabcornerx, int ttabcornery, int ttabdimx, int ttabdimy, 
  float txmin, float txmax, float tymin, float tymax, float txval, float tyval, 
  int tprecisionx, int tprecisiony, String tslidername) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;
    precisionx=tprecisionx; 
    precisiony=tprecisiony;
    xmin=txmin; 
    xmax=txmax; 
    ymin=tymin; 
    ymax=tymax;
    xval=txval; 
    yval=tyval;
    slidername=tslidername;
    tabcornerx=ttabcornerx;
    tabcornery=ttabcornery;
    tabdimx=ttabdimx;
    tabdimy=ttabdimy;

    dropdown=false;
    overtab=false;

    arrowkeys = new boolean[4];
    buttonsize=12;
    colorbox=#0093CB; 
    coloractive=#00FFFD; 
    colorbutton=#FFFFFF;
    textcolor=(255);
    tabcolor=(255);
    tabtransparency=100;
    ratiox=(xmax-xmin)/(dimx); 
    ratioy=(ymax-ymin)/(dimy);
    minxpos=topcornerx-buttonsize/2; 
    maxxpos=topcornerx+dimx+buttonsize/2;
    minypos=topcornery-buttonsize/2; 
    maxypos=topcornery+dimy+buttonsize/2;
    xbutton=topcornerx+round(dimx*(xval-xmin)/(xmax-xmin));
    ybutton=topcornery+round(dimy*(yval-ymin)/(ymax-ymin));
    sliderfont=loadFont("EurostileBold-48.vlw");

    minxpostab=tabcornerx; 
    maxxpostab=tabcornerx+tabdimx;
    minypostab=tabcornery; 
    maxypostab=tabcornery+tabdimy;
  }

  void update() {

    if (mouseX>minxpostab && mouseX<maxxpostab &&
      mouseY>minypostab && mouseY<maxypostab) overtab=true;  
    else overtab=false;

    if (mousePressed && !overtab) lockouttab=true;
    if (mousePressed==false) {
      lockouttab=false;
      toggleMove=false;
    }
    if (!dropdown && !lockouttab && overtab) dropdown=true;


    if (dropdown) {

      if (mousePressed) toggleMove=true;

      if ((mouseX<minxpos || mouseX>maxxpos ||
        mouseY<minypos || mouseY>maxypos) && !toggleMove) dropdown=false;
    }

    if (toggleMove) {
      xbutton=constrain(mouseX, topcornerx, topcornerx+dimx);
      ybutton=constrain(mouseY, topcornery, topcornery+dimy);
    }

    if (dropdown) {
      if (arrowkeys[0]) xbutton=max(topcornerx, xbutton-1);
      if (arrowkeys[1]) xbutton=min(topcornerx+dimx, xbutton+1);
      if (arrowkeys[2]) ybutton=max(topcornery, ybutton-1);
      if (arrowkeys[3]) ybutton=min(topcornery+dimy, ybutton+1);
    }

    xval=xmin+(xbutton-topcornerx)*ratiox;
    yval=ymin+(ybutton-topcornery)*ratioy;
  }

  void display() {

    stroke(0);
    rectMode(CORNER);

    if (!dropdown) {
      fill(tabcolor, tabtransparency);
      rect(tabcornerx, tabcornery, tabdimx, tabdimy);
    } 
    else {

      if (toggleMove) fill(coloractive);
      else fill(colorbox);

      rect(topcornerx-buttonsize/2, topcornery-buttonsize/2, dimx+buttonsize, dimy+buttonsize);

      rectMode(CENTER);
      fill(colorbutton, 185);
      rect(xbutton, ybutton, buttonsize, buttonsize);

      textFont(sliderfont, 12);
      fill(textcolor);
      text(slidername + "  " + nf(xval, 1, precisionx) + " ,  " + nf(yval, 1, precisiony), 
      minxpos, minypos-2);
    }
  }

  void equalize() {
    if (dropdown) {
      yval=xval;
      xbutton=topcornerx+round(dimx*(xval-xmin)/(xmax-xmin));
      ybutton=topcornery+round(dimy*(yval-ymin)/(ymax-ymin));
    }
  }

  void changeTextColor(color c) {
    textcolor=c;
  }

  void changeSliderColor(color cbox, color cactive, color cbutton) {
    colorbox=cbox; 
    coloractive=cactive; 
    colorbutton=cbutton;
  }

  float[] returnvalues() {
    float[] values= {
      xval, yval
    };
    return values;
  }

  void arrowKeysPressed() {
    if (dropdown) {
      if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=true;
      if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=true;
      if (keyCode == KeyEvent.VK_UP) arrowkeys[2]=true;
      if (keyCode == KeyEvent.VK_DOWN) arrowkeys[3]=true;
    }
  }

  void arrowKeysReleased() {
    if (dropdown) { 
      if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=false;
      if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=false;
      if (keyCode == KeyEvent.VK_UP) arrowkeys[2]=false;
      if (keyCode == KeyEvent.VK_DOWN) arrowkeys[3]=false;
    }
  }
}

