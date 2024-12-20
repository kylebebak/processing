/**
some digital fireflies by
<a href="http://www.local-guru.net/blog">Guru</a>
*/

PGraphics pg1;

void setup() {
  size(400,400);
  pg1 = makeTexture( 40 );
  frameRate(25);
}

float alph = 0.0;

void draw() {
  alph += 0.1;
  background(0);
  
  drawStar( pg1, width/2 + 50 * sin(alph), height/2 + 50 * cos( alph ));
}

void drawStar( PImage img, float x, float y ) {
   blend( img, 0, 0, img.width, img.height, int(x) - img.width/2, int(y) - img.height/2, img.width, img.height, ADD);
}

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
