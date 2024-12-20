import processing.pdf.*;

PImage bg;
PImage img;
int targetDim = 2000;

int w, h;

void setup() {
  bg = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img_no_mask/bg.png");
  img = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img_no_mask/img.png");

  if (img.width > img.height) {
    img.resize(targetDim, 0);
  } 
  else {
    img.resize(0, targetDim);
  }

  w = img.width;
  h = img.height;

  bg = bg.get(0, 0, w, h);


  smooth();
  size(w, h);
//  "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img/output.pdf"

  background(0);



  loadPixels();
  bg.loadPixels();
  img.loadPixels();



  int white = -1;
  int black = -16777216;
  float alphaMultiplier;
  
  color c, bgc;
  int a, r, g, b;

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      bgc = bg.pixels[y * w + x];
      
      if (bgc < white) {
        c = img.pixels[y * w + x];
        
        if (bgc == black) {
          pixels[y * w + x] = c;
        } 
        
        
        else {
          a = (c >> 24) & 0xFF;
          r = (c >> 16) & 0xFF;  // Faster way of getting red(argb)
          g = (c >> 8) & 0xFF;   // Faster way of getting green(argb)
          b = c & 0xFF;
  
          alphaMultiplier = bgc / (float) black;
          a *= alphaMultiplier;
          c = color(r, g, b, a);
          pixels[y * w + x] = c;
        }
        
        
      }
    }
  }

  updatePixels();
}

