size(500, 500);

colorMode(HSB, 360, 100, 100);
float H0=250, dH=135;
float sx=.5*width, sy=height;


for (int j=0; j<height; j++) {
  for (int i=0; i<width; i++) {

    float h=(H0+j*dH/height) % 360 ;
    float b=dist( (float)i, (float)j, sx, sy );
    b=90-65*b/height;
    color c=color(h, 100, b);
    set(i, j, c);
  }
}


/*H starts at 250 and increases to 250 from bottom of screen to top
S is full
B is calculated based on distance from source, decreases radially
away from source*/

