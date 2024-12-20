//dropPalette class
class Palette {
  //int topcornerx, topcornery, tabcornerx, tabcornery; //location, width and height
  int dimx, dimy, tabdimx, tabdimy; //location of tab, width and height
  float minxpos, maxxpos, minypos, maxypos;
  float minxpostab, maxxpostab, minypostab, maxypostab;
  PImage palette1, palette2; //one discrete, one continuous, toggle with "p"
  boolean paletteSwitch;
  boolean overtab, lockouttab, dropdown, toggleMove;
  float r, g, b;
  color c;
  //display must be called before update
  //check in draw if active is true before calling returnRGB
  //call changePalette() in void keyReleased()

  Palette (int ttopcornerx, int ttopcornery, int tdimx, int tdimy, 
  int ttabcornerx, int ttabcornery, int ttabdimx, int ttabdimy) {
    minxpos=ttopcornerx; 
    minypos=ttopcornery;
    dimx=tdimx;
    dimy=tdimy;
    maxxpos=minxpos+dimx; 
    maxypos=minypos+dimy;

    minxpostab=ttabcornerx;
    minypostab=ttabcornery;
    tabdimx=ttabdimx;
    tabdimy=ttabdimy;
    maxxpostab=minxpostab+tabdimx; 
    maxypostab=minypostab+tabdimy;


    //draw and load palette images
    if (width<dimx || height<dimy) size(max(dimx, width), max(dimy, height));
    int W=dimx;
    int H=dimy;

    noStroke();
    colorMode(HSB, W, H, H);
    for (int i = 0; i < W; i++) {
      for (int j = 0; j < 4*H/5; j++) {
        stroke(i, H*pow( (float)j / (4*(float)H/5), .65 ), 
        H*pow( (float)j / (4*(float)H/5), .65 ));
        point(i, j);
      }
      for (int j = 4*H/5; j < H; j++) {
        stroke(i, H-(j-4*H/5)*5, H);
        point(i, j);
      }
    }

    palette1=get(0, 0, W, H);

    float Wi=(float)dimx;
    float Hi=(float)dimy;
    int numc=7;

    noStroke();
    colorMode(RGB, 255);
    for (int j=0; j<numc; j++) {
      fill(j*255/(numc-1));
      rect(j*Wi/numc, 0, Wi/numc, Hi/4);
    }

    colorMode(HSB, 360, 100, 100);
    for (int j=0; j<numc; j++) {
      fill(j*360/numc, 100, 50); 
      rect(j*Wi/numc, Hi/4, Wi/numc, Hi/4);
    }
    for (int j=0; j<numc; j++) {
      fill(j*360/numc, 100, 100); 
      rect(j*Wi/numc, 2*Hi/4, Wi/numc, Hi/4);
    }
    for (int j=0; j<numc; j++) {
      fill(j*360/numc, 50, 100); 
      rect(j*Wi/numc, 3*Hi/4, Wi/numc, Hi/4);
    }

    palette2=get(0, 0, (int)Wi, (int)Hi);
    colorMode(RGB, 255);
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

      if (mouseX>minxpos && mouseX<maxxpos && mouseY>minypos && mouseY<maxypos) {
        c=get(mouseX, mouseY);
        r= c >> 16 & 0xFF;
        //this code extracts the red value (from 0 to 255) from the color c
        //it's equivalent to     r=red(c);         only it's faster
        g= c >> 8 & 0xFF;
        b= c & 0xFF;
      }
    }
  }



  void display() {

    if (!dropdown) {
      stroke(0);
      rectMode(CORNER);
      fill(255, 100);
      rect(minxpostab, minypostab, tabdimx, tabdimy);
    } 
    else {
      if (paletteSwitch) set((int)minxpos, (int)minypos, palette2);
      else set((int)minxpos, (int)minypos, palette1);
    }
  }

  void displaySample() {
    if (dropdown) {
      rectMode(CORNER);
      fill(c);
      rect(maxxpos, maxypos-dimy/5, dimx/5, dimy/5);
    }
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
