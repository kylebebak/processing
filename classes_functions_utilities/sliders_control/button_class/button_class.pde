/*button has a certain number of states
 it has width and height
 one can switch between states
 the name of each state can be displayed, or color of button can be changed depending on state
 when button is pressed the position of the button goes to a certain value. corresponding
 states can be changed by clicking mouse on button (use lockout here)
 or they can be changed with arrow keys, left/right or up/down
 find out how to link button to a slider or especially a color palette
 function "case" may be useful
 */

Button test, test2;
float side=25;

void setup() {

  smooth();
  size(500, 500);

  String[] testnames= {
    "squigglers", "background", "citylights", "disco", "red and whites"
  };
  test=new Button(width-150, height-150, 100, 20, 5, -2, testnames);

  String[] test2names= {
    "kung fu", "squeakerbox", "bear trap", "p diddy"
  };
  test2=new Button(width-150, 150, 10, 87, 4, 2, test2names);
}

void draw() {

  background(0);

  test.update();
  test2.update();

  if (test2.toggle[0]) side+=1;
  if (test2.toggle[1]) side+=3;
  if (test2.toggle[2]) side-=1;
  if (test2.toggle[3]) side-=3;
  side=side%300;

  if (test.toggle[0]) fill(255, 0, 0, 100);
  rect(width/2, height/2, side, side);
  if (test.toggle[1]) fill(0, 255, 0, 100);
  rect(width/2, height/2, side, side);
  if (test.toggle[2]) fill(0, 0, 255, 100);
  rect(width/2, height/2, side, side);
  if (test.toggle[3]) fill(255, 0, 255, 100);
  rect(width/2, height/2, side, side);
  if (test.toggle[4]) fill(0, 255, 255, 100);
  rect(width/2, height/2, side, side);


  test.display();
  test2.display();
}

void mouseReleased() {
  test.mouseButtonReleased();
  test2.mouseButtonReleased();
}

void keyReleased() {
  test.arrowKeysReleased();
  test2.arrowKeysReleased();
}


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
    state=constrain(tstate, 0, nstates-1);;
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
    buttonfont=loadFont("EurostileBold-48.vlw");
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

    textFont(buttonfont, 12);
    fill(textcolor);
    if (dimx>dimy) text(statenames[state], topcornerx-buttonsizex/2, topcornery-2);
    else text(statenames[state], topcornerx, topcornery-buttonsizey/2-2);
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

