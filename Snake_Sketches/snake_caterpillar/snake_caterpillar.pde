//make a spiral!
PImage img;

float len=35;
float baseLength=len;
int segs=12;

float x0, y0;
float[] x=new float[segs];
float[] y=new float[segs];
float angle;

boolean dragged;
float easing=.05;
float baseEasing=easing;

float W, H;
float panx=0;
float pany=0;
float mousePan=15;
float mapW, mapH, mapX, mapY, mmX, mmY, boxW, boxH;

boolean overMap, active, lockout;

float proximity;

float[] rad=new float[segs];
float rotAngle=0;
float omega=PI/50;
int numBalls=5;

boolean[] arrowkeys=new boolean[4];
float keyPan=10;



void setup() {
  size(1200, 600);
  smooth();

  x0=random(0, width);
  x[0]=x0;
  y0=random(0, height);
  y[0]=y0;
  W=width*3;
  H=height*5;

  mapW=100;
  mapH=80;
  mapX=30;
  mapY=height-mapX-mapH;
  boxW=mapW * width / W;
  boxH=mapH * height / H;
  panx=0;
  pany=0;


  for (int i=1; i<segs; i++) rad[i]=7.5/pow(float(i), .5);

  size(3600, 3000);
  background(0);
  for (int j=0; j<12; j++) {
    drawCircle(random(0, width), random(0, height), (int)random(50, 750), 8);
    //drawFern(random(0, width), random(0, height), random(0, 2*PI), random(50, 1000), 8);
  }
  img=get();
  size(1200, 600);
}



void draw() {

  rotAngle+=omega;
  rotAngle=rotAngle % (2*PI);

  if (mouseX>mapX && mouseX<mapX+mapW
    && mouseY>mapY && mouseY<mapY+mapH) overMap=true;
  else overMap=false;
  if (overMap && mousePressed && !lockout) active=true;
  if (!overMap && !active && mousePressed) lockout=true;
  if (!mousePressed) {
    lockout=false;
    active=false;
  }

  if (active) {
    mmX=constrain(mouseX, mapX+boxW/2, mapX + mapW - boxW/2);
    mmY=constrain(mouseY, mapY+boxH/2, mapY + mapH - boxH/2);
    mmX -= mapX + boxW/2;
    mmY -= mapY + boxH/2;
    panx= (mmX / (mapW - boxW) ) * (W-width);
    pany= (mmY / (mapH - boxH) ) * (H-height);
  }



  if (!active && mousePressed) {
    if (mouseX>width-10) panx+=mousePan;
    if (mouseX<10) panx-=mousePan; 
    if (mouseY>height-10) pany+=mousePan;
    if (mouseY<10) pany-=mousePan;
  }


  if (arrowkeys[0] || arrowkeys[1] || arrowkeys[2] || arrowkeys[3]) {
    if (arrowkeys[0]) {
      x0=max(0, x0-keyPan);
      if (x0<panx) panx-=keyPan;
    }
    if (arrowkeys[1]) {
      x0=min(W, x0+keyPan);
      if (x0>width+panx) panx+=keyPan;
    }
    if (arrowkeys[2]) {
      y0=max(0, y0-keyPan);
      if (y0<pany) pany-=keyPan;
    }
    if (arrowkeys[3]) {
      y0=min(H, y0+keyPan);
      if (y0>height+pany) pany+=keyPan;
    }
  }

  panx=constrain(panx, 0, W-width);
  pany=constrain(pany, 0, H-height);

  /*
  pushMatrix();
   translate(-panx, -pany);
   image(img, 0, 0);
   popMatrix();
   */

  /*this can be called instead of image, it's faster if you don't need to do
   any transformations or resize or tint*/
  set(-(int)panx, -(int)pany, img);

  strokeWeight(2);
  stroke(127);
  rect(mapX-1, mapY-1, mapW+2, mapH+2);
  image(img, mapX, mapY, mapW, mapH);
  stroke(255);
  rect(mapX + mapW * panx / W, mapY + mapH * pany / H, 
  boxW, boxH);
  stroke(0, 255, 255);
  ellipse(mapX + mapW * x[0] / W, mapY + mapH * y[0] / H, 2, 2);

  translate(-panx, -pany);



  angle = atan2(mouseY+pany-y[0], mouseX+panx-x[0]);

  if (!mousePressed) {
    dragged=false;
    easing = baseEasing;
  }

  if (dragged) {
    x0=mouseX+panx-len*cos(angle);
    y0=mouseY+pany-len*sin(angle);
    float speed=dist(mouseX, mouseY, pmouseX, pmouseY);
    speed=sqrt(speed);
    len += .2 * speed;
    easing = baseEasing + .005 * speed;
  }

  proximity=dist(x0, y0, x[0], y[0]);
  if (proximity < 200) len -= 5  /  max(3, sqrt(proximity));
  len=max(baseLength, len);


  x[0] += easing * (x0-x[0]);
  y[0] += easing * (y0-y[0]);
  if (abs(x0-x[0]) < 2 ) x[0]=x0;
  if (abs(y0-y[0]) < 2 ) y[0]=y0;


  for (int i=0; i<segs-1; i++) {

    angle = atan2(y[i]-y[i+1], x[i]-x[i+1]);

    x[i+1]=x[i]-len*cos(angle);
    y[i+1]=y[i]-len*sin(angle);

    pushMatrix();
    translate(x[i+1], y[i+1]);
    rotate(angle);

    stroke(255, 0, 0);
    ellipse(len/2, 0, rad[i+1]*2/3, rad[i+1]*2/3);

    stroke(0, 255, 255);
    float dAngle=0;
    for (int j=0; j<numBalls; j++) {
      dAngle=2*PI*j / (float)numBalls;
      ellipse(len/2 * ( 1 + (1/sqrt(i+1)) * cos(rotAngle+dAngle) ), 
      len/2 * (1/sqrt(i+1)) * ( sin(rotAngle+dAngle) ), 
      rad[i+1]*2, rad[i+1]*2);
    }

    popMatrix();
  }
}



void mouseDragged() {
  if (!active && !overMap) dragged=true;
}



void mouseReleased() {
  if (!active && !overMap) {
    x0=mouseX+panx-len*cos(angle);
    y0=mouseY+pany-len*sin(angle);
  }
}


void keyPressed() {
  if (keyCode == LEFT) arrowkeys[0]=true;
  if (keyCode == RIGHT) arrowkeys[1]=true;
  if (keyCode == UP) arrowkeys[2]=true;
  if (keyCode == DOWN) arrowkeys[3]=true;
}

void keyReleased() { 
  if (keyCode == LEFT) arrowkeys[0]=false;
  if (keyCode == RIGHT) arrowkeys[1]=false;
  if (keyCode == UP) arrowkeys[2]=false;
  if (keyCode == DOWN) arrowkeys[3]=false;
}





void drawCircle(float x, float y, int radius, int level) 
{                    
  float tt = 126 * level/6.0;
  fill(0, 0, tt, 125);
  ellipse(x, y, radius*2, radius*2);      
  if (level > 1) {
    level = level - 1;
    int num = int(random(2, 6));
    for (int i=0; i<num; i++) {
      float a = random(0, TWO_PI);
      float nx = x + cos(a) * 10.0 * level;
      float ny = y + sin(a) * 10.0 * level;
      drawCircle(nx, ny, radius/2, level);
    }
  }
}



void drawFern(float x, float y, float angle, 
float blength, int branches)
{                 
  noFill();  
  stroke(0, 0, 255, 50);
  strokeWeight((float)branches);
  float ex = x + blength * cos(angle);
  float ey = y - blength * sin(angle);
  line(x, y, ex, ey);

  if (branches > 1) {
    branches -= 1;
    int num = int(random(2, 5));
    for (int i=0; i<num; i++) {

      float a = random(11*PI/24, 13*PI/24);

      if ( int(random(0, 2)) == 0 ) a += PI;
      float newx=random(min(x, ex), max(x, ex));
      float slope=(ey-y)/(ex-x);

      drawFern(newx, y + slope * (newx - x), angle+a, 
      2*blength/3, branches);
    }
  }
}

