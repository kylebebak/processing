//  has Animation class, ScrollingBackground class, mod function
import java.awt.event.KeyEvent;

int frames = 10;

PImage kayak_img, background_image;
PImage[] kayak_images = new PImage[frames];

float[] frame_size = new float[2];

float angle;
float[] position = new float[2];
float[] velocity = new float[2];
float turn_speed = .15, row_acceleration = 2;
float drag = .1;

boolean[] arrowkeys = new boolean[4];
boolean is_rowing;


int[] screen_size = {
  800, 650
};
float[] scroll_speed = {
  -3, -1.5
};



ScrollingBackground sb;
Animation kayak;
int default_frame = 0;
float kayak_size_multiplier = 4;


void setup() {
  frameRate(10);

  String path = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/scrolling backround, sprite animation/sprite_animation/images/";
  kayak_img = loadImage(path + "kayaking.png");
  background_image = loadImage(path + "water_background.png");
  frame_size[0] = kayak_img.width/10;
  frame_size[1] = kayak_img.height/4;

  for (int i=0; i<frames; i++)
    kayak_images[i] = kayak_img.get(i*(int)frame_size[0], 0, 
    (int)frame_size[0], (int)frame_size[1]);

  sb = new ScrollingBackground(background_image, 
  screen_size, scroll_speed);
  kayak = new Animation( kayak_images );

  size( screen_size[0], screen_size[1] );
}


/*documentation for image*/
//image(img, dx, dy, dw, dh, sx, sy, sw, sh);
//
//dx, dy, dw, dh  = the area of your display that you want to draw to.
//
//sx1, sy1, sx2, sy2  = the part of the image to draw (measured in pixels)


void draw() {

  sb.update();
  sb.draw_background();


  if (arrowkeys[1]) angle += turn_speed;
  if (arrowkeys[0]) angle -= turn_speed;

  if (arrowkeys[3]) {
    velocity[0] += -sin(angle)*row_acceleration; 
    velocity[1] += cos(angle)*row_acceleration;
  }
  if (arrowkeys[2]) {
    velocity[0] += sin(angle)*row_acceleration; 
    velocity[1] += -cos(angle)*row_acceleration;
  }

  velocity[0] *= ( 1 - drag );
  velocity[1] *= ( 1 - drag );

  position[0] = mod(position[0] + velocity[0] + scroll_speed[0], width);
  position[1] = mod(position[1] + velocity[1] + scroll_speed[1], height);
  //  scroll_speed is the speed of the moving water
  //  the current carries the boat as well


  if (arrowkeys[0] || arrowkeys[1] || arrowkeys[2] || arrowkeys[3]) is_rowing = true;

  kayak.update(is_rowing, default_frame, position, 
  angle, kayak_size_multiplier);
  //  draw kayaker now

  is_rowing = false;
}



void keyPressed() {
  if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=true;
  if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=true;
  if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=true;
  if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=true;
}

void keyReleased() {
  if (keyCode == KeyEvent.VK_LEFT) arrowkeys[0]=false;
  if (keyCode == KeyEvent.VK_RIGHT) arrowkeys[1]=false;
  if (keyCode == KeyEvent.VK_DOWN) arrowkeys[2]=false;
  if (keyCode == KeyEvent.VK_UP) arrowkeys[3]=false;
}





/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
class ScrollingBackground {
  PImage img;
  int[] image_size = new int[2];
  float[] scroll_speed = new float[2];
  float[] offset = new float[2];

  ScrollingBackground(PImage im, int[] im_size, float[] scr_speed) {
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
}





/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
class Animation {
  PImage[] images;
  int frame;

  Animation (PImage[] imgs) {
    images = imgs;
  }

  void update(boolean is_animating, int choose_frame, 
  float[] pos, float angle, float size_multiplier) {

    if (is_animating) frame = (frame + 1) % images.length;
    else frame = choose_frame;


    imageMode(CENTER);

    /* put origin at the mouse coords, then put it at the center of little canoer
     before rotating */
    pushMatrix();
    translate(pos[0], pos[1]);
    rotate(angle);

    image(images[frame], 0, 0, 
    size_multiplier*images[frame].width, 
    size_multiplier*images[frame].height);
    popMatrix();
  }
}





/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
/* ~~~~~~~~~~~~~~~~~~~~~~~ */
float mod(float in, float mod) {
  float quotient=in/mod;
  quotient=float(floor(quotient));
  float out=in-mod*quotient;
  return out;
}
