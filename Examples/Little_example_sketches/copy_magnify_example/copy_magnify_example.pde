PImage img;
float x, y;
float W=50, H=50;
float w=W, h=H;

float dw=15, dh=15;

void setup() {
  size(400, 400);
  img=loadImage("grass.jpeg");
  img.resize(width, height);

  x=.75*width;
  y=.75*height;
}

void draw() {
  set(0, 0, img);


  if (keyPressed) {
    if (key == '=') {
      w+=.03*w;
      h+=.03*h;
    }
    if (key == '-') {
      w-=.03*w;
      h-=.03*h;
    }
  } 
  w=constrain(w, W/4, 4*W);
  h=constrain(h, H/4, 4*H);



  float mx=mouseX-dw/2;
  float my=mouseY-dh/2;

  copy(round(mx), round(my), round(dw), round(dh), 
  round(x-w/2), round(y-h/2), round(w), round(h));
  noFill();
  stroke(255);
  // Rectangle shows area being copied
  rect(round(mx), round(my), round(dw), round(dh));
}

