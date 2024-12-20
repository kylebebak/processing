Palette palette;

int num=10000;
float[] xp=new float[num];
float[] yp=new float[num];
float[] dx=new float[num];
float[] dy=new float[num];
float sp=5;

int backgroundColor;
color particleColor;

float w, h, x, y;
//for zoom and panning

void setup() {

  size(750, 750);

  palette=new Palette(50, height-130, 80, 80);

  for (int i=0; i<num; i++) {
    xp[i]=width/2;
    yp[i]=height/2;
  }
  
  w=width;
  h=height;
}

void draw() {

  palette.display();
  palette.update();
  
  scale( width / w, height / h);
  translate(-x, -y);

  noStroke();
  fill(backgroundColor, 10);
  rect(0, 0, width, height);

  particleColor=palette.returnColor();
  stroke(particleColor);
  for (int i=0; i<num; i++) {
    dx[i]=random(-sp, sp);
    dy[i]=random(-sp, sp);
    line(xp[i], yp[i], xp[i]+dx[i], yp[i]+dy[i]);
    xp[i]+=dx[i];
    yp[i]+=dy[i];
  }

  if (keyPressed) {
    if (key == '=' || key == '+') sp=min(50, sp + .1);
    if (key == '-' || key == '_') sp=max(0, sp - .1);
    if (key == 'r' || key == 'R') for (int i=0; i<num; i++) {
      xp[i]=width/2;
      yp[i]=height/2;
    }

    //= and - to zoom in and out on center of screen
    if (key == '1') {
      float zoom=.95; 
      x += .5 * w * ( 1 - 1 / zoom );
      y += .5 * h * ( 1 - 1 / zoom );
      w *= 1 / zoom;
      h *= 1 / zoom;
    }
    if (key == '2') {
      float zoom=1.05;
      x += .5 * w * ( 1 - 1 / zoom );
      y += .5 * h * ( 1 - 1 / zoom );
      w *= 1 / zoom;
      h *= 1 / zoom;
    }
  }
}

void keyReleased() {
  if (key == 'b' || key =='B') {
    if (backgroundColor == 0) backgroundColor=255;
    else backgroundColor=0;
  }

  palette.changePalette();
}






//Palette class
class Palette {
  int topcornerx, topcornery;
  int dimx, dimy;
  float maxxpos, maxypos;
  PImage palette1, palette2;
  boolean paletteSwitch, active;
  float r, g, b;
  color c=#FF0303;
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
    rectMode(CORNER);
    if (paletteSwitch) image(palette2, topcornerx, topcornery, dimx, dimy);
    else image(palette1, topcornerx, topcornery, dimx, dimy);
  }

  void displaySample() {
    rectMode(CORNER);
    fill(c);
    rect(maxxpos, maxypos-dimy/5, dimx/5, dimy/5);
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

