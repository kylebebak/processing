float len=20;
float baseLength=len;
int segs=12;

float x0, y0;
float[] x=new float[segs];
float[] y=new float[segs];
float angle;

boolean dragged;
float easing=.05;
float baseEasing=easing;
float rad;
float W, H;
float panx=0;
float pany=0;

float mapW, mapH, mapX, mapY, mmX, mmY, boxW, boxH;

boolean overMap, active, lockout;

float proximity;

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
}



void draw() {

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


  fill(0, 50);
  noStroke();
  rect(0, 0, W, H);


  if (!active && mousePressed) {
    if (mouseX>width-10) panx+=15;
    if (mouseX<10) panx-=15; 
    if (mouseY>height-10) pany+=15;
    if (mouseY<10) pany-=15;
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

  strokeWeight(2);
  stroke(127);
  fill(0);
  rect(mapX, mapY, mapW, mapH);
  stroke(255);
  rect(mapX + mapW * panx / W, mapY + mapH * pany / H, 
  boxW, boxH);
  stroke(0, 255, 255);
  ellipse(mapX + mapW * x[0] / W, mapY + mapH * y[0] / H, 2, 2);


  translate(-panx, -pany);

  /*
  noFill();
   for (int i=0; i<10; i++) {
   strokeWeight(sqrt(i+1));
   stroke(0, 255-25*i, 25*i);
   ellipse(W/2, H/2, 40*sq(i), 40*sq(i));
   }
   strokeWeight(2);
   */

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


  stroke(255, 0, 0);

  pushMatrix();
  translate(x[0], y[0]);
  rotate(angle);
  rad=random(5, 15);
  ellipse(random(0, len), random(-10, 10), rad, rad);
  line(0, -len/1.65, 0, len/1.65);
  popMatrix();


  stroke(0, 255, 255);
  for (int i=0; i<segs-1; i++) {

    angle = atan2(y[i]-y[i+1], x[i]-x[i+1]);

    x[i+1]=x[i]-len*cos(angle);
    y[i+1]=y[i]-len*sin(angle);

    pushMatrix();
    translate(x[i+1], y[i+1]);
    rotate(angle);
    rad=random(1, 5);
    ellipse(random(0, len), random(-10, 10), rad, rad);
    line(0, -len/2, 0, len/2);
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

