PFont font;
PImage leaves, leaf;

float x, y, z, w, h;
float wx, wy, wz; //angular velocites for different dimensions
float ax, ay, az;
float vy = -3;
float dvy = .15;
float vx = .5;
float fontSize = 75;
float damping = .75;

/* for falling leaves, the x rotation should stay around PI/2,
 they y-rotation should stay around zero, and the z-rotation
 can change with time
 */

void setup() {
  size(500, 600, P3D);
  rectMode(CENTER);

  font = loadFont("helvetica-48.vlw");
  leaves = loadImage("transparent_leaves.png");
  leaf = leaves.get(0, 0, 134, 125);

  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  // textAlign(CENTER, CENTER) is different from textAlign(CENTER),
  //the latter doesn't center the text vertically

  x = 150;
  y = 100;
  z = -100;
  w = 40;
  h = 80;
  wx = .025;
  wy = -.025;
  wz = .015;
}

void draw() {
  background(0);

  ax += wx;
  ay += wy;
  az += wz;
  vy += dvy;
  y += vy;
  x += vx;

  if (y > height) {
    y = 2*height - height;
    vy = -vy*damping;
  }

  if (x > width) {
    x = 2*width - x; 
    vx = -vx*damping;
  }

  fill(255);
  translate(x, y);
  rotateX(ax);
  rotateY(ay);
  rotateZ(az);
  textFont(font, fontSize);
  text('A', 0, 0);
  //  rect(0, 0, w, h);
  //  image(leaf, 0, 0);



  z++; // The rectangle moves forward as z increments.
}

