PImage img;
int[] screen_size = {
  1000, 650
};
float x_offset;
float x_scroll_speed = 5;


void setup() {
  img = loadImage("space_clouds_3.jpg");
  img.resize(screen_size[0], screen_size[1]);
  // resize changes img.width and img.height

  size( screen_size[0], screen_size[1] );
  // image(img, 0, 0, width, height, 200, 200, img.width, img.height);
}


/*documentation for image*/
//image(img, dx, dy, dw, dh, sx, sy, sw, sh);
//
//dx, dy, dw, dh  = the area of your display that you want to draw to.
//
//sx1, sy1, sx2, sy2  = the part of the image to draw (measured in pixels)


void draw() {
  x_offset = mod(x_offset+x_scroll_speed, width);


  // image(img, x_offset, 0, width-x_offset, height, 0, 0, round(img.width-x_offset-200), img.height);
  // interesting warp effect

  //  image(img, x_offset, 0, width-x_offset, height, 0, 0, round(img.width-x_offset), img.height);
  //  image(img, 0, 0, x_offset, height, round(img.width-x_offset), 0, round(x_offset), img.height);
  //weird folding effect
  
  background(0, 0, 0);
  
  image(img, x_offset, 0, width-x_offset, height, 0, 0, round(img.width-x_offset), img.height);
  image(img, 0, 0, x_offset, height, round(img.width-x_offset), 0, img.width, img.height);
}





float mod(float in, float mod) {
  float quotient=in/mod;
  quotient=float(floor(quotient));
  float out=in-mod*quotient;
  return out;
}

