/*
brownian motion
 march 2012
 
 m and n  increase/decrease number ot particles
 
 sliders  increase/decrease jump length spread
 increase/decrease mean jump length
 arrow keys to slowly change slider values
 
 r  to reset their positions
 a  to set their positions to a vertical line
 d  to set their positions to a horizontal line
 c  to reset color to bright red
 o  to toggle opaque trails vs transparent trails
 b  to change toggle background color between black and white
 h  to toggle hide on and off, make everything disappear except particles
 w  to toggle walls on and off (if you let them go long enough without walls
 all the particles will diverge from the origin until they're no longer on the screen)
 p  to toggle alternate palette
 e  to set slider y value to slider x value
 */

Slider2D rates, spread, mean;
float ratesx=.75;
float ratesy=20;
float sx=2;
float sy=2;
float ux=0;
float uy=0;

Palette palettes;
//color and color extraction variables, and transparency
color c=color(255, 0, 0);
float rc=255;
float gc=0;
float bc=0;

int num=50;
//number of particles
int fade=20;
//number of frames in which particles continue to be seen

//positions of particles
float[][] x=new float[num][fade];
float[][] y=new float[num][fade];

//temporary variables for resizing x, y and fade
float xt[][];
float yt[][];
int newfade;

int rate=50;
//draw is delayed by this many miliseconds between frames

PFont font;

//keyboard controlled booleans, transparency variable for transparent fade
boolean toggleWalls=true;
boolean toggleBackground=false;
boolean toggleOpaque=true;
boolean toggleHide=false;
float transparency;

//for generating random variables  
float range=100;
//range just needs to be significant bigger than s, the jump length
//this is a bell curve that drops off like exp(-x)...
//not the typical gaussian brownian motion bot close enough
float bellx=pow(1+exp(-(1/sx)*(range-ux)), -1);
float bell0x=pow(1+exp(-(1/sx)*(0-ux)), -1);
float belly=pow(1+exp(-(1/sy)*(range-uy)), -1);
float bell0y=pow(1+exp(-(1/sy)*(0-uy)), -1);
float r;
float rr;


void setup() {

  smooth();
  size(1000, 750);

  font=loadFont("EurostileBold-48.vlw");

  palettes=new Palette(70, height-150, 80, 80);

  rates=new Slider2D(170, height-150, 80, 80, .05, 1, 2, 100, ratesx, ratesy, 
  2, 1, "F-Rate, Fade");

  spread=new Slider2D(width-150, 50, 80, 80, .001, 15, .001, 15, sx, sy, 
  2, 2, "spread: sx, sy");
  //strange bug where s can't go to zero if mean is zero, so i've set mins to just above zero

  mean=new Slider2D(width-150, 170, 80, 80, 0, 20, 0, 20, ux, uy, 
  2, 2, "mean: ux, uy");

  for (int i=0; i<num; i++) {
    for (int j=0; j<fade; j++) {
      x[i][j]=width/2; 
      y[i][j]=height/2;
    }
  }
}

void draw() {

  if (toggleBackground) {
    background(255);
  } 
  else {
    background(0);
  }

  //disable rates because they're right next to palette,
  //to be able to change color when hide is toggled without worrying about changing rates
  if (!toggleHide) {
    rates.update();
    rates.display();
  }

  //keyboard and mouse controls for changing particles' speed, 
  //resetting position, resetting color, changing number of particles, 
  //changing color, changing f-rate and fade, changing mean of distribution

  if (keyPressed) {

    if (key=='c') {
      c=color(255, 0, 0);
      rc=255;
      gc=0;
      bc=0;
    }


    if (key=='r') {
      for (int i=0; i<num; i++) {
        for (int j=0; j<fade; j++) {
          x[i][j]=width/2;
          y[i][j]=height/2;
        }
      }
    }

    if (key=='d') {
      for (int i=0; i<num; i++) {
        for (int j=0; j<fade; j++) {
          float rplacement=random(-3*height/8, 3*height/8);
          x[i][j]=width/2;
          y[i][j]=height/2+rplacement;
        }
      }
    }

    if (key=='a') {
      for (int i=0; i<num; i++) {
        for (int j=0; j<fade; j++) {
          float rplacement=random(-3*width/8, 3*width/8);
          x[i][j]=width/2+rplacement;
          y[i][j]=height/2;
        }
      }
    }


    //adding and subtracting to arrays, i should make this a class
    if (key=='m') {
      num=min(100, num+1);

      xt=new float[num][fade];
      yt=new float[num][fade];

      for (int j=0; j<fade; j++) {
        for (int i=0; i<num-1; i++) {
          xt[i][j]=x[i][j];
          yt[i][j]=y[i][j];
        }

        xt[num-1][j]=width/2;
        yt[num-1][j]=height/2;
      }

      x=new float[num][fade];
      y=new float[num][fade];

      for (int j=0; j<fade; j++) {
        for (int i=0; i<num; i++) {
          x[i][j]=xt[i][j];
          y[i][j]=yt[i][j];
        }
      }
    }

    if (key=='n') {
      num=max(1, num-1);

      xt=new float[num][fade];
      yt=new float[num][fade];

      for (int j=0; j<fade; j++) {
        for (int i=0; i<num; i++) {
          xt[i][j]=x[i][j];
          yt[i][j]=y[i][j];
        }
      }

      x=new float[num][fade];
      y=new float[num][fade];

      for (int j=0; j<fade; j++) {
        for (int i=0; i<num; i++) {
          x[i][j]=xt[i][j];
          y[i][j]=yt[i][j];
        }
      }
    }
  }

  //update and display sliders, palette

  //display must be called before update
  palettes.display();
  palettes.update();

  spread.update();
  spread.display();

  mean.update();
  mean.display();

  if (palettes.active) {
    rc=palettes.returnRGB()[0];
    gc=palettes.returnRGB()[1];
    bc=palettes.returnRGB()[2];
    c=palettes.returnColor();
  }

  //slider controls
  ratesx=rates.returnvalues()[0];
  ratesy=rates.returnvalues()[1];
  rate=int(10/ratesx);
  newfade=(int)ratesy;

  sx=spread.returnvalues()[0];
  sy=spread.returnvalues()[1];

  ux=mean.returnvalues()[0];
  uy=mean.returnvalues()[1];

  if (keyPressed) {
    if (key=='e') {
      spread.equalize();
      mean.equalize();
    }
  }

  if (spread.toggleMove==true || mean.toggleMove==true) {
    bellx=pow(1+exp(-(1/sx)*(range-ux)), -1);
    bell0x=pow(1+exp(-(1/sx)*(0-ux)), -1);
    belly=pow(1+exp(-(1/sy)*(range-uy)), -1);
    bell0y=pow(1+exp(-(1/sy)*(0-uy)), -1);
  }

  if (fade!=newfade) {
    xt=new float[num][newfade];
    yt=new float[num][newfade];

    if (fade>newfade) {
      for (int i=0; i<num; i++) {
        for (int j=0; j<newfade; j++) {
          xt[i][j]=x[i][j];
          yt[i][j]=y[i][j];
        }
      }
    }

    if (fade<newfade) {
      for (int i=0; i<num; i++) {
        for (int j=0; j<fade; j++) {
          xt[i][j]=x[i][j];
          yt[i][j]=y[i][j];
        }
      }
    }

    x=new float[num][newfade];
    y=new float[num][newfade];

    for (int i=0; i<num; i++) {
      for (int j=0; j<newfade; j++) {
        x[i][j]=xt[i][j];
        y[i][j]=yt[i][j];
      }
    }
  }

  fade=newfade;

  //implementation of fade, moving each position in array to a higher index
  for (int j=fade-1; j>0; j--) {
    for (int i=0; i<num; i++) {
      x[i][j]=x[i][j-1];
      y[i][j]=y[i][j-1];
    }
  }

  //movement, dx and dy are chosen from a bell shaped random variable with mean u
  //and width s
  for (int i=0; i<num; i++) {

    r=ux-sx*log(-1+1/ (random(bell0x, bellx)));
    rr=random(0, 1);
    if (rr>.5) {
      x[i][0]+=r;
    } 
    else {
      x[i][0]-=r;
    }

    r=uy-sy*log(-1+1/ (random(bell0y, belly)));
    rr=random(0, 1);
    if (rr>.5) {
      y[i][0]+=r;
    } 
    else {
      y[i][0]-=r;
    }
  }

  //cover everything with background, tell text to disappear below
  if (toggleHide) {
    if (toggleBackground) {
      background(255);
    } 
    else {
      background(0);
    }
  }


  //drawing particles, lines between current position and previous positions
  for (int i=0; i<num; i++) {
    for (int j=0; j<fade-1; j++) {

      if (x[i][j+1]!=0 && y[i][j+1]!=0) {
        if (!toggleOpaque) {
          transparency=255/pow(j+1, .5);
          stroke(c, transparency);
        } 
        else {
          if (toggleBackground) {
            stroke(rc+(255-rc)*j/fade, gc+(255-gc)*j/fade, bc+(255-bc)*j/fade);
          } 
          else {
            stroke(rc-rc*j/fade, gc-gc*j/fade, bc-bc*j/fade);
          }
        }
        line(x[i][j], y[i][j], x[i][j+1], y[i][j+1]);
      }
    }

    //particles bounce off the walls if walls is toggled, otherwise they diverge
    if (toggleWalls) {
      if (x[i][0]<0) x[i][0]=-x[i][0];
      if (x[i][0]>width) x[i][0]=2*width-x[i][0];
      if (y[i][0]<0) y[i][0]=-y[i][0];
      if (y[i][0]>height) y[i][0]=2*height-y[i][0];
    }
  }

  //text has to be called outside of the previous for loops
  if (!toggleHide) {
    textFont(font, 12);
    if (toggleBackground) {
      fill(0);
    } 
    else {
      fill(255);
    }
    text("n=" + num, 20, 25);

    if (toggleWalls) text("walls", 20, 45);

    if (toggleOpaque) text("opaque", 20, 65);
  }

  //delay in miliseconds before drawing next frame
  delay(rate);
}

void keyPressed() {

  rates.arrowKeysPressed();
  spread.arrowKeysPressed();
  mean.arrowKeysPressed();
}

//keyboard controls for hard toggling of walls, opacity, background
void keyReleased() {

  rates.arrowKeysReleased();
  spread.arrowKeysReleased();
  mean.arrowKeysReleased();

  if (key=='w') toggleWalls=!toggleWalls;

  if (key=='o') toggleOpaque=!toggleOpaque;

  if (key=='b') {
    toggleBackground=!toggleBackground;
    if (toggleBackground) {
      rates.changeTextColor(color(0));
      spread.changeTextColor(color(0));
      mean.changeTextColor(color(0));
    } 
    else {
      rates.changeTextColor(color(255));
      spread.changeTextColor(color(255));
      mean.changeTextColor(color(255));
    }
  }

  if (key=='h') toggleHide=!toggleHide;

  palettes.changePalette();
}





//Palette class
class Palette {
  int topcornerx, topcornery;
  int dimx, dimy;
  float maxxpos, maxypos;
  PImage palette1, palette2;
  boolean paletteSwitch, active;
  float r, g, b;
  color c;
  //display must be called before update
  //check in draw if active is true before calling returnRGB
  //call changePalette() in void keyReleased()

  Palette (int ttopcornerx, int ttopcornery, int tdimx, int tdimy) {
    topcornerx=ttopcornerx; 
    topcornery=ttopcornery;
    dimx=tdimx; 
    dimy=tdimy;
    maxxpos=topcornerx+dimx; 
    maxypos=topcornery+dimy;
    //can display one of 2 palettes, one with the whole visible spectrum and one more binary
    palette1 = loadImage("palette_97x97.jpg");
    palette2 = loadImage("visible_spectrum.jpg");
  }

  void update() {

    if (mousePressed) {

      if (mouseX>topcornerx && mouseX<maxxpos && mouseY>topcornery && mouseY<maxypos) {
        active=true;
        c=get(mouseX, mouseY);
        r= c >> 16 & 0xFF;
        //this code extracts the red value (from 0 to 255) from the color c
        //it's equivalent to     r=red(c);         only it's faster
        g= c >> 8 & 0xFF;
        b= c & 0xFF;
      }
    } 
    else {
      active=false;
    }
  }

  void display() {
    if (paletteSwitch) image(palette2, topcornerx, topcornery, dimx, dimy);
    else image(palette1, topcornerx, topcornery, dimx, dimy);
  }

  void changePalette() {
    if (key=='p') paletteSwitch=!paletteSwitch;
  }

  float[] returnRGB() {
    float[] RGBvalues= {
      r, g, b
    };
    return RGBvalues;
  }

  color returnColor() {
    return c;
  }
}





//Slider2D class
class Slider2D {
  int topcornerx, topcornery; //location of slider
  int dimx, dimy; //width and height
  int precisionx, precisiony; //decimal precision of values displayed
  float xmin, xmax, ymin, ymax; //min and max values of x and y values
  float xval, yval, xbutton, ybutton; //x and y values returned by slider
  float ratiox, ratioy; //computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize;
  color colorbox, coloractive, colorbutton, textcolor;
  boolean toggleMove, over, lockout; //lockout prevents 2 sliders from being activated at once
  boolean[] arrowkeys; //arrowKeysPressed/Released must be called in void keyPressed/Released()
  PFont sliderfont; //default color is white, can be changed by calling changeTextColor
  String slidername;

  Slider2D (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
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

    arrowkeys = new boolean[4];
    buttonsize=12;
    colorbox=#0093CB; 
    coloractive=#00FFFD; 
    colorbutton=#FFFFFF;
    textcolor=(255);
    ratiox=(xmax-xmin)/(dimx); 
    ratioy=(ymax-ymin)/(dimy);
    minxpos=topcornerx-buttonsize/2; 
    maxxpos=topcornerx+dimx+buttonsize/2;
    minypos=topcornery-buttonsize/2; 
    maxypos=topcornery+dimy+buttonsize/2;
    xbutton=topcornerx+round(dimx*(xval-xmin)/(xmax-xmin));
    ybutton=topcornery+round(dimy*(yval-ymin)/(ymax-ymin));
    sliderfont=loadFont("EurostileBold-48.vlw");
  }

  void update() {
    if (mouseX>minxpos && mouseX<maxxpos &&
      mouseY>minypos && mouseY<maxypos) over=true; 
    else over=false;

    if (over && mousePressed && !lockout) toggleMove=true;

    if (mousePressed && !over && toggleMove==false) lockout=true;

    if (mousePressed==false) {
      toggleMove=false;
      lockout=false;
    }

    if (toggleMove) {
      xbutton=constrain(mouseX, topcornerx, topcornerx+dimx);
      ybutton=constrain(mouseY, topcornery, topcornery+dimy);
    }

    if (over && !lockout) {
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

    if ((over || toggleMove) && !lockout) fill(coloractive);
    else fill(colorbox);

    rect(topcornerx-buttonsize/2, topcornery-buttonsize/2, dimx+buttonsize, dimy+buttonsize);

    rectMode(CENTER);
    fill(colorbutton,200);
    rect(xbutton, ybutton, buttonsize, buttonsize);

    textFont(sliderfont, 12);
    fill(textcolor);
    text(slidername + "  " + nf(xval, 1, precisionx) + " ,  " + nf(yval, 1, precisiony), 
    minxpos, minypos-2);
  }

  void equalize() {
    if (over) {
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
    if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=true;
    if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=true;
    if (keyCode == KeyEvent.VK_UP) arrowkeys[2]=true;
    if (keyCode == KeyEvent.VK_DOWN) arrowkeys[3]=true;
  }

  void arrowKeysReleased() { 
    if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=false;
    if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=false;
    if (keyCode == KeyEvent.VK_UP) arrowkeys[2]=false;
    if (keyCode == KeyEvent.VK_DOWN) arrowkeys[3]=false;
  }
}

