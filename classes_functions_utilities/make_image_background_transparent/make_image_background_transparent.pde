//takes an image and makes all the black or white space totally transparent
//and then outputs this image to a new file called "transparent_image.png"

PImage img;
PGraphics transparent_pg;
color transparentWhite;

void setup() {

  transparentWhite = color(255, 0);
  
  img = loadImage("leaves.png");
  transparent_pg = createGraphics(img.width, img.height);
  transparent_pg.image(img, 0, 0);
  size(img.width, img.height);
  
  transparent_pg.loadPixels();
  
  color tc;
   for (int i=0; i<img.width; i++) {
    for (int j=0; j<img.height; j++) {
      tc = transparent_pg.pixels[i + j*img.width];
      if (red(tc) > 200 && blue(tc) > 200 && green(tc) > 200) 
      transparent_pg.pixels[i+j*width] = transparentWhite;
    }
  }
  
  transparent_pg.updatePixels();
  
  transparent_pg.save("transparent_image.png");
  background(255, 0, 0);
  image(transparent_pg, 0, 0);
  
}

////leaves images is 6*6 sprites, total dimension is 804 x 750, each sprite has dimension
////of 134 x 125

