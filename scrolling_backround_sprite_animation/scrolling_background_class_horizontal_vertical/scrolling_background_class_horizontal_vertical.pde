PImage img;
int[] screen_size = {
  1000, 650
};
float[] scroll_speed = {
  -3, 1.5
};

Scrolling_background sb;


//space_clouds_3 copy.jpg, debris2_blue copy.png
void setup() {
  img = loadImage("debris2_blue copy.png");
  // resize changes img.width and img.height

  sb = new Scrolling_background(img, screen_size, scroll_speed);
  size( screen_size[0], screen_size[1] );
}


/*documentation for image*/
//image(img, dx, dy, dw, dh, sx, sy, sw, sh);
//
//dx, dy, dw, dh  = the area of your display that you want to draw to.
//
//sx1, sy1, sx2, sy2  = the part of the image to draw (measured in pixels)


void draw() {

  background(0, 0, 0);
  
  sb.update();
  sb.draw_background();
}






class Scrolling_background {
  PImage img;
  int[] image_size = new int[2];
  float[] scroll_speed = new float[2];
  float[] offset = new float[2];

  Scrolling_background(PImage im, int[] im_size, float[] scr_speed) {
    img = im;
    image_size = im_size;
    scroll_speed = scr_speed;
    img.resize(image_size[0], image_size[1]);
  }

  void update() {
    offset[0] = mod(offset[0] + scroll_speed[0], width);
    offset[1] = mod(offset[1] + scroll_speed[1], height);
  }

  void draw_background() {
    
    imageMode(CORNER);
    
    //main image piece
    image(img, offset[0], offset[1], width-offset[0], height-offset[1], 
    0, 0, round(img.width-offset[0]), round(img.height-offset[1]));

    //corner piece
    image(img, 0, 0, offset[0], offset[1], 
    round(img.width-offset[0]), round(img.height-offset[1]), img.width, img.height);

    //side piece
    image(img, 0, offset[1], offset[0], height-offset[1], 
    round(img.width-offset[0]), 0, img.width, round(img.height-offset[1]));

    //top-bottom piece
    image(img, offset[0], 0, width-offset[0], offset[1], 
    0, round(img.height-offset[1]), round(img.width-offset[0]), img.height);
  }

  float mod(float in, float mod) {
    float quotient=in/mod;
    quotient=float(floor(quotient));
    float out=in-mod*quotient;
    return out;
  }
}

