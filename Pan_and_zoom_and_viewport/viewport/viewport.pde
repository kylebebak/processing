//a test sketch to get zoom to work

float x=0, y=0;
float w, h;
float X, Y;
float mX, mY, pmX, pmY;
float panx=0, pany=0, px=0, py=0, dpx=0, dpy=0;
float easing=.065;
boolean[] keys=new boolean[2];
float angle=0;
float da;

boolean yellow=false;

void setup() {
  size(500, 500);
  w=width;
  h=height;
  smooth();
}

void draw() {

  yellow=false;
  background(0);

  if (keyPressed) {
    //= and - to zoom in and out on center of screen
    if (key == '1') {
      float zoom=.95; 
      x += .5 * w * ( 1 - 1 / zoom );
      y += .5 * h * ( 1 - 1 / zoom );
      w *= 1 / zoom;
      h *= 1 / zoom;
    }
    if (key == '2') {
      float zoom=1.05;
      x += .5 * w * ( 1 - 1 / zoom );
      y += .5 * h * ( 1 - 1 / zoom );
      w *= 1 / zoom;
      h *= 1 / zoom;
    }

    //r to reset all zooms and translates
    if (key == 'r') {
      x=0;
      y=0;
      w=width;
      h=height;
      mX=0;
      mY=0;
      angle=0;
    }

    if (key == 'q') { 
      float[] m=mouseRotate(constrain(mouseX, 0, width), 
      constrain(mouseY, 0, height), angle, width/2, height/2);
      mX=m[0];
      mY=m[1];
      X= x + mX * w/width;
      Y= y + mY * h/height;

      println("rotated mouse = " + mX + ", " + mY);
      if (X>45 && X<55 && Y>45 && Y<55) {
        yellow=true;
      }
    }
  }

  //mouseDragged translation
  dpx= (panx - px) * easing;
  dpy= (pany - py) * easing;
  x -= dpx;
  y -= dpy;
  px += dpx;
  py += dpy;

  //arrowkey Rotation, keys[]
  if (keys[0]) angle+=radians(-2);
  if (keys[1]) angle+=radians(2);

  translate(width/2, height/2);
  rotate(angle);
  translate(-width/2, -height/2);

  scale( width / w, height / h);
  translate(-x, -y);

  //some test rectangles
  fill(255);
  rect(225, 225, 50, 50);
  rect(245, 125, 10, 10);
  rect(245, 25, 10, 10);

  fill(255, 0, 0);
  rect(290, 290, 20, 20);

  if (yellow) fill (255, 255, 0, 100);
  else fill(255, 255, 0);
  rect(45, 45, 10, 10);
}

void mousePressed() {

  // mouseEvent variable contains the current event information
  //double-click zoom
  if (mouseEvent.getClickCount()==2) {
    float zoom=2;

    float[] m=mouseRotate(constrain(mouseX, 0, width), 
    constrain(mouseY, 0, height), angle, width/2, height/2);
    mX=m[0];
    mY=m[1];

    X= x + mX * w/width;
    Y= y + mY * h/height;
    x= X - (1 / zoom) * (X - x);
    y= Y - (1 / zoom) * (Y - y);
    w *= 1 / zoom;
    h *= 1 / zoom;
  }

  //right-click center and zoom
  if (mouseEvent.getButton()==MouseEvent.BUTTON3) {
    float zoom=2;

    float[] m=mouseRotate(constrain(mouseX, 0, width), 
    constrain(mouseY, 0, height), angle, width/2, height/2);
    mX=m[0];
    mY=m[1];

    X= x + mX * w/width;
    Y= y + mY * h/height;
    x= X - w / (2 * zoom);
    y= Y - h / (2 * zoom);
    w *= 1 / zoom;
    h *= 1 / zoom;
  }
}

void mouseDragged() {
  float[] m=mouseRotate(constrain(mouseX, 0, width), 
  constrain(mouseY, 0, height), angle, width/2, height/2);
  mX=m[0];
  mY=m[1];

  m=mouseRotate(constrain(pmouseX, 0, width), 
  constrain(pmouseY, 0, height), angle, width/2, height/2);
  pmX=m[0];
  pmY=m[1];

  panx += (mX - pmX) * w/width;
  pany += (mY - pmY) * h/height;
}

void keyPressed() {
  if (keyCode == LEFT) keys[0]=true;
  if (keyCode == RIGHT) keys[1]=true;
}

void keyReleased() {
  if (keyCode == LEFT) keys[0]=false;
  if (keyCode == RIGHT) keys[1]=false;
}

float[] mouseRotate(float mx, float my, float angle, 
float xc, float yc) {
  float mtx=mx;
  float mty=my;
  mx= xc + (mtx-xc) * cos(-angle) - (mty-yc) * sin(-angle);
  my= yc + (mtx-xc) * sin(-angle) + (mty-yc) * cos(-angle);
  float[] mxmy= {
    mx, my
  };
  return mxmy;
}

