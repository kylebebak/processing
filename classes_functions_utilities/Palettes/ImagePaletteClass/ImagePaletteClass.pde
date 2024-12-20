Palette palette;

void setup() {
  size(500, 500);
  palette=new Palette(200, 200, 100, 100);
  palette.load();
}

void draw() {

  background(0);

  palette.display();
  palette.update();
  palette.displaySample();

  rectMode(CENTER);
  fill(palette.returnColor());
  rect(50, 50, 50, 50);
  fill(255-palette.returnRGB()[0], 255-palette.returnRGB()[1], 255-palette.returnRGB()[2]);
  rect(50, 50, 25, 25);
}

void keyReleased() {
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
  }


  void load() {
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

