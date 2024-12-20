//PGraphics pg;
PGraphics pg1;
PImage img;
float n;
float bx=.02, by=.01;
//these are for a "breeze" that moves the clouds
float mx, my;
float md=80;


void setup() {
  size(400, 400, P2D);
  //pg = createGraphics(width, height, P2D);
  img = createImage(width, height, ARGB);
  noStroke();

  mx=random(.125*width, .375*width);
  my=random(.125*height, .375*height);
  pg1 = makeTexture( 60 );
  /*input to makeTexture is radius of glowing object*/
}


void draw() {

  background(0);
  
  drawStar( pg1, mx, my);
  
  fill(0, 100);
  rect(0, 0, width, height);

  //pg.beginDraw();
  img.loadPixels();

  for (int j=0; j<img.height; j++) {
    for (int i=0; i<img.width; i++) {

      //n=noise(.02*i, .02*j, frameCount*.02);

      //n=noise(.02*i+random(bx/2, 3*bx/2)*frameCount,
      //.02*j+random(by/2, 3*by/2)*frameCount);

      n=noise(.02*i+bx*frameCount, 
      .02*j+by*frameCount, .007*frameCount);
      /*positive values for bx and by will make pixels
       on the left side and top of the screen get modified
       by the same noise as pixels on the right side and
       bottom of the screen, only at a later time. this causes
       the "clouds" drawn to move left and up with time, i.e.
       there's a breeze in the negative x/negative y direction.
       also, have 3 dimensional noise with the third dimension
       depending only on the frameCount will make the shape
       of the moving clouds change with time*/

      img.pixels[i+j*width] = color(255, 255*n*n*n*n);
      /*for some reason it is MUCH faster to cube the noise
      with n*n*n than to use the function pow(n, 3)*/
    }
  }
  
  println(frameRate);


  img.updatePixels();
  //pg.endDraw();
  image(img, 0, 0);
  /*you can't use set() here, it will simply set all of the pixel
   colors to whatever you have in the graphics buffer. this is why you
   can use alpha values in pixels in an image--the existing pixel data
   is obliterated when you set a new pixel color, and if you set a
   currently black pixel to a mostly transparent white pixels, it will erase
   the black pixel and you will have a transparent white pixel on top
   of nothing and the pixel will appear entirely white. that's also why 
   a graphics buffer is needed if you want to use pixels[] or set()
   to make a transparent layer and put it on top of another layer. a PImage
   or a PGraphics can be used for the pixels buffer. the methods available
   to PImage are very limited--basically all you can do is load and
   update the pixels array, while with PGraphics you can do anything*/
}




void drawStar( PImage img, float x, float y ) {
   blend( img, 0, 0, img.width, img.height,
   int(x) - img.width/2, int(y) - img.height/2,
   img.width, img.height, ADD);
}


/*texture is made in setup, and then blended each frame
in draw*/
PGraphics makeTexture( int r ) {
  PGraphics res = createGraphics( r * 6, r * 6, P2D);
  res.beginDraw();
  res.loadPixels();
    for ( int x = 0; x < res.width; x++) {   
	for( int y = 0; y < res.height; y++ ) {
	  float d = min( 512, 50*  sq( r / sqrt( sq( x - 3 * r) + sq( y - 3 * r))));
	  //if ( d < 10 ) d = 0;
	  res.pixels[y * res.width + x] = color( min(255,d), min(255, d*0.8), d* 0.5 );
	}
    }
  res.updatePixels();
  res.endDraw();
  
  return res;  
}

