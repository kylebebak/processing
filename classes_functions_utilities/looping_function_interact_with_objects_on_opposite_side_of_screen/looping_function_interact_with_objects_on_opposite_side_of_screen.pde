float Km=.25;
PVector r, v;

void setup() {
  size(500, 500);
  smooth();
  
  r=new PVector(random(0, width), random(0, height));
  v=new PVector(random(-1, 1), random(-1, 1));
  
}

void draw() {

  background(0);
  float xt=0, yt=0, dt=0;


  if (mousePressed==true) {
    float[] c=distloop(r.x, r.y, mouseX, mouseY);
    xt=c[0];
    yt=c[1];
    dt=dist(xt, xt, mouseX, mouseY);
    if (dt>0) {
      dt=dt*sqrt(sqrt(dt));
      v.add(-Km*(xt-mouseX)/dt, -Km*(yt-mouseY)/dt, 0);
    }
  }

  v.setMag(min(v.mag(), 3));
  r.add(v);

  if (r.x>width) r.add(-width, 0, 0);
  if (r.x<0) r.add(width, 0, 0);
  if (r.y>height) r.add(0, -height, 0);
  if (r.y<0) r.add(0, height, 0);

  fill(255, 0, 0);
  ellipse(r.x, r.y, 10, 10);
}




float[] distloop(float x1, float y1, float x2, float y2) {

  /*point coords are changed to values that minimize the distance
   between the points, assuming that the screen loops along x and y
   */

  if ( abs(x1-x2) > width/2 ) {
    if (x1>x2) x1-=width;
    else x1+=width;
  }
  if ( abs(y1-y2) > height/2 ) {
    if (y1>y2) y1-=height;
    else y1+=height;
  }

  float[] coords= {
    x1, y1
  };
  return coords;
}

