StateSlider check, check2;
float value0, value1, value2;

import java.awt.event.KeyEvent;

void setup() {

  smooth();
  size(500, 500);

  /*
  StateSlider (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
   float[] tvmin, float[] tvmax, float[] tval, int[] tprecision, String[] tslidernames, 
   int tnstates, int tstate)
   */

  float[] vmin= {
    0, 0, 20
  };
  float[] vmax= {
    width, height, 500
  };
  float[] val= {
    10, 10, 50
  };
  int[] precision= {
    3, 2, 1
  };
  String[] slidernames= {
    "poop", "stoop", "group"
  };

  check=new StateSlider(170, height-150, 80, 20, 
  vmin, vmax, val, precision, slidernames, 
  3, 1);
  //check2=new StateSlider(width-200, 100, 80, 20, 0, width/2, value2, 1, "size");
}

void draw() {
  background(0);
  check.update();
  //check2.update();
  value0=check.val[0];
  value1=check.val[1];
  value2=check.val[2];

  fill(255, 0, 255);
  rect(value0, value1, value2, value2);
  check.display();
  //check2.display();
}

void mouseReleased() {
  check.mouseButtonReleased();
  //check2.mouseButtonReleased();
}

void keyPressed() {
  check.arrowKeysPressed();
  //check2.arrowKeysPressed();
}

void keyReleased() {
  check.arrowKeysReleased();
  //check2.arrowKeysReleased();
}


//StateSlider class
class StateSlider {
  int topcornerx, topcornery; //location of slider
  int dimx, dimy, dim; //width and height, slider horizontal if dim bigger
  int[] precision; //decimal precision of value displayed
  int state, nstates;
  float[] vmin, vmax, val, ratio; //min and max value of slider
  float[] xbutton, ybutton;
  float xchoose, ychoose; //button positions for slider and selector
  float spacing, spacingclick; //computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize, buttonsizex, buttonsizey;
  float minxtog, minytog;
  color colorbox, coloractive, colorbutton, colortoggle, textcolor;
  boolean toggleMove, over, lockout, overToggle, overboth, dropdown; //lockout prevents 2 sliders from being activated at once
  boolean[] arrowkeys; //arrowKeysPressed/Released must be called in void keyPressed/Released()
  PFont sliderfont; //default color is white, can be changed by calling changeTextColor
  String[] slidernames;

  StateSlider (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
  float[] tvmin, float[] tvmax, float[] tval, int[] tprecision, String[] tslidernames, 
  int tnstates, int tstate) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;
    precision=tprecision;
    vmin=tvmin; 
    vmax=tvmax; 
    val=tval; 
    slidernames=tslidernames;
    buttonsize=12;
    state=tstate;
    nstates=tnstates;
    ratio=new float[nstates];
    xbutton=new float[nstates];
    ybutton=new float[nstates];

    dim=max(dimx, dimy);
    for (int i=0; i<nstates; i++) {
      ratio[i]=(vmax[i]-vmin[i])/(dim);
    }
    spacing=dim/(nstates-1);
    spacingclick=dim/nstates;

    if (dimx>=dimy) {
      buttonsizex=buttonsize;
      buttonsizey=dimy;
      minxpos=topcornerx-buttonsizex/2;
      maxxpos=topcornerx+dimx+buttonsizex/2;
      minypos=topcornery; 
      maxypos=topcornery+buttonsizey;
      minytog=minypos-buttonsizey/2;
      for (int i=0; i<nstates; i++) {
        xbutton[i]=topcornerx+round(dim*(val[i]-vmin[i])/ (vmax[i]-vmin[i]));
        ybutton[i]=topcornery+buttonsizey/2;
      }
      xchoose=topcornerx+state*spacing;
      ychoose=topcornery+buttonsizey/2;
    } 
    else {
      buttonsizex=dimx;
      buttonsizey=buttonsize;
      minxpos=topcornerx; 
      maxxpos=topcornerx+buttonsizex;
      minypos=topcornery-buttonsizey/2; 
      maxypos=topcornery+dimy+buttonsizey/2;
      minxtog=minxpos-buttonsizex/2;
      for (int i=0; i<nstates; i++) {
        xbutton[i]=topcornerx+buttonsizex/2;
        ybutton[i]=topcornery+round(dim*(val[i]-vmin[i])/ (vmax[i]-vmin[i]));
      }
      xchoose=topcornerx+buttonsizex/2;
      ychoose=topcornery+state*spacing;
    }

    arrowkeys = new boolean[4];
    colorbox=#0093CB; 
    coloractive=#00FFFD; 
    colorbutton=#FFFFFF;
    colortoggle=#00FFFD;
    textcolor=(255);
    sliderfont=createFont("Helvetica", 48);
  }

  void update() {
    
    //booleans for toggle box and their logic
    if (dimx>=dimy) {
      if (mouseX>minxpos && mouseX<maxxpos && 
        mouseY>minytog && mouseY<minypos) overToggle=true;
      else overToggle=false;
    } 
    else {
      if (mouseX>minxtog && mouseX<minxpos && 
        mouseY>minypos && mouseY<maxypos) overToggle=true;
      else overToggle=false;
    }
    
    //booleans for slider box
    if (mouseX>minxpos && mouseX<maxxpos && 
      mouseY>minypos && mouseY<maxypos) over=true;
      else over=false;

    if (dimx>=dimy) {
     if (mouseX>minxpos && mouseX<maxxpos && mouseY>minytog && mouseY<maxypos) overboth=true;
     else overboth=false;
    } else {
      if (mouseX>minxtog && mouseX<maxxpos && mouseY>minypos && mouseY<maxypos) overboth=true;
     else overboth=false;
    }

    if (over && mousePressed && !lockout) toggleMove=true;

    if (mousePressed && !over && toggleMove==false) lockout=true;

    if (mousePressed==false) {
      toggleMove=false;
      lockout=false;
    }

    if (toggleMove) {
      if (dimx>=dimy) xbutton[state]=constrain(mouseX, topcornerx, topcornerx+dim);
      else ybutton[state]=constrain(mouseY, topcornery, topcornery+dim);
    }

    //when to toggle dropdown boolean
    if (overboth && !lockout) dropdown=true;
    if (!overboth) dropdown=false;


    if (over && !lockout) {
      if (dimx>=dimy) {
        if (arrowkeys[0]) xbutton[state]=max(topcornerx, xbutton[state]-1);
        if (arrowkeys[1]) xbutton[state]=min(topcornerx+dimx, xbutton[state]+1);
      } 
      else {
        if (arrowkeys[2]) ybutton[state]=min(topcornery+dimy, ybutton[state]+1);
        if (arrowkeys[3]) ybutton[state]=max(topcornery, ybutton[state]-1);
      }
    } 

    if (dimx>=dimy) val[state]=vmin[state]+(xbutton[state]-topcornerx)*ratio[state];
    else val[state]=vmin[state]+(ybutton[state]-topcornery)*ratio[state];
  }

  void display() {

    stroke(0);
    rectMode(CORNER);

    if ((over || toggleMove) && !lockout) fill(coloractive);
    else fill(colorbox);

    //rendering slider box and toggle box
    if (dimx>=dimy) rect(topcornerx-buttonsizex/2, topcornery, dim+buttonsizex, buttonsizey);
    else rect(topcornerx, topcornery-buttonsizey/2, buttonsizex, dim+buttonsizey);

    if (dropdown) {
      if (overToggle && !toggleMove) fill(colortoggle);
      else fill(colorbox);
      if (dimx>=dimy) rect(topcornerx-buttonsizex/2, minytog, dim+buttonsizex, buttonsizey/2);
      else rect(minxtog, topcornery-buttonsizey/2, buttonsizex/2, dim+buttonsizey);
    }

    //rendering slider button and toggle button
    rectMode(CENTER);
    fill(colorbutton, 185);
    rect(xbutton[state], ybutton[state], buttonsizex, buttonsizey);

    if (dropdown) {
      fill(colorbutton, 185);
      if (dimx>=dimy) rect(topcornerx+state*spacing, minypos-buttonsizey/4, buttonsizex, buttonsizey/2);
      else rect(minxpos-buttonsizex/4, topcornery+state*spacing, buttonsizex/2, buttonsizey);
    }


    textFont(sliderfont, 12);
    fill(textcolor);
    if (dimx>=dimy) text(slidernames[state] + "  " + nf(val[state], 1, precision[state]), minxpos, maxypos+10);
    else text(slidernames[state] + "  " + nf(val[state], 1, precision[state]), minxpos, minypos-2);
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
    return val[state];
  }

  void mouseButtonReleased() {

    if (overToggle && dropdown && !toggleMove) {
      if (dimx>=dimy) state=constrain(floor((mouseX-topcornerx)/spacingclick), 0, nstates-1);
      else state=constrain(floor((mouseY-topcornery)/spacingclick), 0, nstates-1);
    }
  }

  void arrowKeysPressed() {
    if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=true;
    if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=true;
    if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=true;
    if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=true;
  }

  void arrowKeysReleased() {

    if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=false;
    if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=false;
    if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=false;
    if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=false;

    if (overToggle && dropdown) {
      if (dimx>=dimy) {
        if (keyCode == KeyEvent.VK_LEFT) state=max(state-1, 0);
        if (keyCode == KeyEvent.VK_RIGHT) state=min(state+1, nstates-1);
      } 
      else {
        if (keyCode == KeyEvent.VK_UP) state=max(state-1, 0);
        if (keyCode == KeyEvent.VK_DOWN) state=min(state+1, nstates-1);
      }
    }
  }
}

