/*ToggleButton returns true or false and that's it
 */

ToggleButton test, test2;

void setup() {

  smooth();
  size(500, 500);
  test=new ToggleButton(50, 100, 10, 30, "wank", true);
  test2=new ToggleButton(100, 50, 100, 20, "spank", false);
}

void draw() {

  background(0);

  test.update();
  test2.update();

  if (test.toggle) fill(255);
  else fill(255, 0, 0);

  if (test2.toggle) rect(50, 300, 50, 50);
  else rect(300, 50, 50, 50);

  test.display();
  test2.display();
}

void mouseReleased() {
  test.mouseButtonReleased();
  test2.mouseButtonReleased();
}

//ToggleButton class
class ToggleButton {
  int topcornerx, topcornery; //location of button
  int dimx, dimy, dim; //width and height, dim is the bigger of the two
  float minxpos, maxxpos, minypos, maxypos, buttonsizex, buttonsizey, onpos;
  color colorbox, colorbutton, coloractive, textcolor;
  boolean over, lockout;
  PFont buttonfont; //default color is white, can be changed by calling changeTextColor
  String name;
  boolean toggle;
  //mouseButtonReleased must be called in void mouseReleased()

  ToggleButton (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, String tname, boolean ttoggle) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;  
    name=tname;

    toggle=ttoggle;
    over=false;

    dim=max(dimx, dimy);

    if (dimx>=dimy) {
      buttonsizex=2*dimx/3;
      buttonsizey=dimy;
      minxpos=topcornerx;
      maxxpos=topcornerx+dimx;
      minypos=topcornery; 
      maxypos=topcornery+buttonsizey;
      onpos=topcornerx+dimx/3;
    } 
    else {
      buttonsizex=dimx;
      buttonsizey=2*dimy/3;
      minxpos=topcornerx; 
      maxxpos=topcornerx+buttonsizex;
      minypos=topcornery; 
      maxypos=topcornery+dimy;
      onpos=topcornery+dimy/3;
    }

    colorbox=#0093CB; 
    colorbutton=#FFFFFF;
    coloractive=#00FFFD; 
    textcolor=(255);
    buttonfont=loadFont("EurostileBold-48.vlw");
  }

  void update() {

    if (mouseX>minxpos && mouseX<maxxpos &&
      mouseY>minypos && mouseY<maxypos) over=true;  
    else over=false;

    if (mousePressed && !over) lockout=true;
    if (mousePressed==false) lockout=false;
  }


  void display() {
    stroke(0);
    rectMode(CORNER);

    if (over && !lockout) fill(coloractive);
    else fill(colorbox);

    if (dimx>=dimy) rect(topcornerx, topcornery, dim, buttonsizey);
    else rect(topcornerx, topcornery, buttonsizex, dim);

    fill(colorbutton, 200);
    if (dimx>=dimy) {
      if (toggle) rect(onpos, topcornery, buttonsizex, buttonsizey);
      else rect(topcornerx, topcornery, buttonsizex, buttonsizey);
    } 
    else {
      if (toggle) rect(topcornerx, onpos, buttonsizex, buttonsizey);
      else rect(topcornerx, topcornery, buttonsizex, buttonsizey);
    }

    textFont(buttonfont, 12);
    fill(textcolor);
    if (dimx>dimy) text(name, topcornerx, topcornery-2);
    else text(name, topcornerx, topcornery-2);
  }


  void changeTextColor(color c) {
    textcolor=c;
  }

  void changeButtonColor(color cbox, color cbutton, color cactive) {
    colorbox=cbox; 
    colorbutton=cbutton;
    coloractive=cactive;
  }

  void mouseButtonReleased() {
    if (over && !lockout) toggle=!toggle;
  }

  boolean returnState() {
    boolean truefalse=toggle;
    return truefalse;
  }
}
