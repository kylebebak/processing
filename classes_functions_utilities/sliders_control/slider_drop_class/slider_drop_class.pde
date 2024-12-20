DropSlider check, check2;
float value=width/2;
float value2=25;

void setup() {

  smooth();
  size(500, 500);

  check=new DropSlider(170, height-150, 50, 80, 170, height-150, 10, 15, 
  0, width, value, 2, "pos");
  check.setTicks(5);
  check.changeTextColor(color(255, 0, 0));
  check2=new DropSlider(width-200, 100, 80, 20, width-200, 100, 15, 10, 
  0, width/2, value2, 1, "size");
}

void draw() {
  
  rectMode(CORNER);
  
  background(0);
  check.update();
  check2.update();
  value=check.returnvalue();
  value2=check2.returnvalue();

  fill(255, 0, 255);
  rect(value, value, value2, value2);
  check.display();
  check2.display();
}

void keyPressed() {
  check.arrowKeysPressed();
  check2.arrowKeysPressed();
}

void keyReleased() {
  check.arrowKeysReleased();
  check2.arrowKeysReleased();
}


//Slider class
class DropSlider {
  int topcornerx, topcornery, tabcornerx, tabcornery; //location of slider
  int dimx, dimy, dim, tabdimx, tabdimy; //width and height, slider horizontal if dim bigger
  int precision, ticks, tickval; //decimal precision of value displayed, number of ticks
  float vmin, vmax; //min and max value of slider
  float val, xbutton, ybutton; //value returned by slider, button position
  float ratio, tickspacing, tickspacingclick; //computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize, buttonsizex, buttonsizey, ticksize;
  float minxpostab, maxxpostab, minypostab, maxypostab;
  color colorbox, coloractive, colorbutton, textcolor, tabcolor;
  int tabtransparency;
  boolean toggleMove, toggleTicks; //lockout prevents 2 sliders from being activated at once

  //probably don't need over and lockout, toggleMove will handle a lock function for the slider?

  boolean overtab, lockouttab, dropdown;
  boolean[] arrowkeys; //arrowKeysPressed/Released must be called in void keyPressed/Released()
  PFont sliderfont; //default color is white, can be changed by calling changeTextColor
  String slidername;

  DropSlider (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
  int ttabcornerx, int ttabcornery, int ttabdimx, int ttabdimy, 
  float tvmin, float tvmax, float tval, int tprecision, String tslidername) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;
    precision=tprecision;
    vmin=tvmin; 
    vmax=tvmax; 
    val=tval; 
    slidername=tslidername;
    buttonsize=12;
    tabcornerx=ttabcornerx;
    tabcornery=ttabcornery;
    tabdimx=ttabdimx;
    tabdimy=ttabdimy;

    dropdown=false;
    overtab=false;

    dim=max(dimx, dimy);
    ratio=(vmax-vmin)/(dim);

    if (dimx>=dimy) {
      buttonsizex=buttonsize;
      buttonsizey=dimy;
      minxpos=topcornerx-buttonsizex/2;
      maxxpos=topcornerx+dimx+buttonsizex/2;
      minypos=topcornery; 
      maxypos=topcornery+buttonsizey;
      xbutton=topcornerx+round(dim*(val-vmin)/(vmax-vmin));
      ybutton=topcornery+buttonsizey/2;
    } 
    else {
      buttonsizex=dimx;
      buttonsizey=buttonsize;
      minxpos=topcornerx; 
      maxxpos=topcornerx+buttonsizex;
      minypos=topcornery-buttonsizey/2; 
      maxypos=topcornery+dimy+buttonsizey/2;
      xbutton=topcornerx+buttonsizex/2;
      ybutton=topcornery+round(dim*(val-vmin)/(vmax-vmin));
    }

    minxpostab=tabcornerx; 
    maxxpostab=tabcornerx+tabdimx;
    minypostab=tabcornery; 
    maxypostab=tabcornery+tabdimy;

    arrowkeys=new boolean[4];
    colorbox=#0093CB; 
    coloractive=#00FFFD; 
    colorbutton=#FFFFFF;
    textcolor=(255);
    sliderfont=loadFont("EurostileBold-48.vlw");
    tabcolor=(255);
    tabtransparency=100;
  }

  void setTicks(int tticks) {
    toggleTicks=true;
    ticks=tticks; 
    tickspacing=dim/(ticks-1);
    tickspacingclick=dim/ticks;
    tickval=constrain(floor((val-topcornerx)/tickspacingclick), 0, ticks-1);
    if (dimx>=dimy) {
      xbutton=topcornerx+tickval*tickspacing;
      ticksize=dimy/5;
    }
    else {
      ybutton=topcornery+tickval*tickspacing;
      ticksize=dimx/5;
    }
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
      if (!toggleTicks) {
        if (dimx>=dimy) xbutton=constrain(mouseX, topcornerx, topcornerx+dim);
        else ybutton=constrain(mouseY, topcornery, topcornery+dim);
      } 
      else {
        if (dimx>=dimy) {
          tickval=constrain(floor((mouseX-topcornerx)/tickspacingclick), 0, ticks-1);
          xbutton=topcornerx+tickval*tickspacing;
        }
        else {
          tickval=constrain(floor((mouseY-topcornery)/tickspacingclick), 0, ticks-1);
          ybutton=topcornery+tickval*tickspacing;
        }
      }
    }

    if (dropdown) {
      if (dimx>=dimy) {
        if (arrowkeys[0]) xbutton=max(topcornerx, xbutton-1);
        if (arrowkeys[1]) xbutton=min(topcornerx+dimx, xbutton+1);
      } 
      else {
        if (arrowkeys[2]) ybutton=min(topcornery+dimy, ybutton+1);
        if (arrowkeys[3]) ybutton=max(topcornery, ybutton-1);
      }
    } 

    if (dimx>=dimy) val=vmin+(xbutton-topcornerx)*ratio;
    else val=vmin+(ybutton-topcornery)*ratio;
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

      if (dimx>=dimy) rect(topcornerx-buttonsizex/2, topcornery, dim+buttonsizex, buttonsizey);
      else rect(topcornerx, topcornery-buttonsizey/2, buttonsizex, dim+buttonsizey);

      rectMode(CENTER);
      fill(colorbutton, 185);
      rect(xbutton, ybutton, buttonsizex, buttonsizey);

      textFont(sliderfont, 12);
      fill(textcolor);
      text(slidername + "  " + nf(val, 1, precision), 
      minxpos, minypos-2);

      if (toggleTicks) {
        stroke(255);
        if (dimx>=dimy) {
          for (int i=0; i<ticks; i++) {
            line(topcornerx+i*tickspacing, maxypos, topcornerx+i*tickspacing, maxypos-ticksize);
          }
        } 
        else {
          for (int i=0; i<ticks; i++) {
            line(maxxpos, topcornery+i*tickspacing, maxxpos-ticksize, topcornery+i*tickspacing);
          }
        }
      }
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

  float returnvalue() {
    return val;
  }

  void arrowKeysPressed() {
    if (!toggleTicks && dropdown) {
      if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=true;
      if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=true;
      if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=true;
      if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=true;
    }
  }

  void arrowKeysReleased() {
    if (!toggleTicks && dropdown) {
      if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=false;
      if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=false;
      if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=false;
      if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=false;
    } 
    else {
      if (dropdown) {
        if (dimx>=dimy) {
          if (keyCode == KeyEvent.VK_LEFT) xbutton=max(topcornerx, xbutton-tickspacing);
          if (keyCode == KeyEvent.VK_RIGHT) xbutton=min(topcornerx+dimx, xbutton+tickspacing);
        } 
        else {
          if (keyCode == KeyEvent.VK_DOWN) ybutton=min(topcornery+dimy, ybutton+tickspacing);
          if (keyCode == KeyEvent.VK_UP) ybutton=max(topcornery, ybutton-tickspacing);
        }
      }
    }
  }
}

