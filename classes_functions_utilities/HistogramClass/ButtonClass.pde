
//Button class
class Button {
  int topcornerx, topcornery; //location of button
  int dimx, dimy, dim; //width and height, dim is the bigger of the two
  int nstates, state; //total number of states, current state
  float xbutton, ybutton; //internal toggle button position
  float spacing, spacingclick; //computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize, buttonsizex, buttonsizey;
  color colorbox, coloractive, colorbutton, textcolor;
  boolean over, lockout; //lockout prevents 2 sliders from being activated at once
  PFont buttonfont; //default color is white, can be changed by calling changeTextColor
  String[] statenames;
  boolean[] toggle;
  boolean shiftpressed;
  //arrowKeysReleased must be called in void keyReleased()
  //mouseButtonReleased must be called in void mouseReleased()

  Button (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
  int tnstates, int tstate, String[] tstatenames) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;  
    statenames=tstatenames;
    buttonsize=10;
    nstates=tnstates;
    state=constrain(tstate, 0, nstates-1);
    ;
    toggle=new boolean[nstates];
    toggle[state]=true;
    shiftpressed=false;

    dim=max(dimx, dimy);
    spacing=dim/(nstates-1);
    spacingclick=dim/nstates;

    if (dimx>=dimy) {
      buttonsizex=buttonsize;
      buttonsizey=dimy;
      minxpos=topcornerx-buttonsizex/2;
      maxxpos=topcornerx+dimx+buttonsizex/2;
      minypos=topcornery; 
      maxypos=topcornery+buttonsizey;
      xbutton=topcornerx+state*spacing;
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
      ybutton=topcornery+state*spacing;
    }

    colorbox=#0093CB; 
    coloractive=#00FFFD; 
    colorbutton=#FFFFFF;
    textcolor=(255);
    buttonfont=createFont("EurostileBold", 48);
  }

  void update() {
    if (mouseX>minxpos && mouseX<maxxpos &&
      mouseY>minypos && mouseY<maxypos) over=true; 
    else over=false;

    if (mousePressed && !over) lockout=true;

    if (mousePressed==false) lockout=false;

    shiftpressed=false;
    if (keyPressed) {
      if (keyCode == KeyEvent.VK_SHIFT) shiftpressed=true;
    }
  }


  void display() {
    stroke(0);
    rectMode(CORNER);

    if (over && !lockout) fill(coloractive);
    else fill(colorbox);

    if (dimx>=dimy) rect(topcornerx-buttonsizex/2, topcornery, dim+buttonsizex, buttonsizey);
    else rect(topcornerx, topcornery-buttonsizey/2, buttonsizex, dim+buttonsizey);

    rectMode(CENTER);
    fill(colorbutton, 185);
    if (dimx>=dimy) {
      for (int i=0; i<nstates; i++) {
        if (toggle[i]) rect(topcornerx+i*spacing, ybutton, buttonsizex, buttonsizey);
      }
    }
    else {
      for (int i=0; i<nstates; i++) {
        if (toggle[i])rect(xbutton, topcornery+i*spacing, buttonsizex, buttonsizey);
      }
    }

    textAlign(RIGHT);
    textFont(buttonfont, 12);
    fill(textcolor);
    if (dimx>dimy) text(statenames[state], topcornerx-buttonsizex/2, topcornery-2);
    else {
      for (int i=0; i<nstates; i++) {
        text(statenames[i], topcornerx-2, topcornery+i*spacing+buttonsize/2);
      }
    }
  }


  void changeTextColor(color c) {
    textcolor=c;
  }

  void changeButtonColor(color cbox, color cactive, color cbutton) {
    colorbox=cbox; 
    coloractive=cactive; 
    colorbutton=cbutton;
  }

  void mouseButtonReleased() {
    if (over && !lockout) {

      if (shiftpressed) {
        if (dimx>=dimy) toggle[constrain(floor((mouseX-topcornerx)/spacingclick), 0, nstates-1)]=
          !toggle[constrain(floor((mouseX-topcornerx)/spacingclick), 0, nstates-1)];
        else toggle[constrain(floor((mouseY-topcornery)/spacingclick), 0, nstates-1)]=
          !toggle[constrain(floor((mouseY-topcornery)/spacingclick), 0, nstates-1)];
      }

      else {
        if (dimx>=dimy) {
          state=constrain(floor((mouseX-topcornerx)/spacingclick), 0, nstates-1);
          if (toggle[state]==true) toggle=new boolean[nstates];
          else {
            toggle=new boolean[nstates];
            toggle[state]=true;
          }
        }
        else {
          state=constrain(floor((mouseY-topcornery)/spacingclick), 0, nstates-1);
          if (toggle[state]==true) toggle=new boolean[nstates];
          else {
            toggle=new boolean[nstates];
            toggle[state]=true;
          }
        }
      }
    }
  }

  void arrowKeysReleased() {
    if (over && !lockout) { 
      if (keyCode == KeyEvent.VK_LEFT || keyCode == KeyEvent.VK_RIGHT ||
        keyCode == KeyEvent.VK_UP || keyCode == KeyEvent.VK_DOWN) {
        toggle=new boolean[nstates];

        if (dimx>=dimy) {
          if (keyCode == KeyEvent.VK_LEFT) state--;
          if (keyCode == KeyEvent.VK_RIGHT) state++;
        } 
        else {
          if (keyCode == KeyEvent.VK_UP) state--;
          if (keyCode == KeyEvent.VK_DOWN) state++;
        }

        if (state>nstates-1) state=0;
        if (state<0) state=nstates-1;
        toggle[state]=true;
      }
    }
  }

  boolean[] returnStates() {
    boolean[] truefalse=toggle;
    return truefalse;
  }
}

