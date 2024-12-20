float[] x, y, vx, vy;
int num=2000;
int xi, yi;
int rad=10;

void setup() {
  size(400, 400);
  smooth();
  x=new float[num];
  y=new float[num];
  vx=new float[num];
  vy=new float[num];

  for (int i=0; i<num; i++) {
    x[i]=random(0, width);
    y[i]=random(0, height);
    vx[i]=random(-1, 1);
    vy[i]=random(-1, 1);
  }
}

void draw() {
  background(0);

  for (int i=0; i<num; i++) {
    x[i]+=vx[i];
    y[i]+=vy[i];

    if (x[i]>width) x[i]=0;
    if (x[i]<0) x[i]=width;
    if (y[i]>height) y[i]=0;
    if (y[i]<0) y[i]=height;

    ellipse(x[i], y[i], rad, rad);
  }

  for (int i=0; i<num; i++) {
    xi=round(x[i]);
    yi=round(y[i]);
    if ( (get(xi+rad, yi) != color(0)) ||
      (get(xi-rad, yi) != color(0)) ||
      (get(xi, yi+rad) != color(0)) ||
      (get(xi, yi-rad) != color(0)) ||
      (get(xi+7, yi+7) != color(0)) ||
      (get(xi-7, yi+7) != color(0)) ||
      (get(xi+7, yi-7) != color(0)) ||
      (get(xi-7, yi-7) != color(0)) ) {
      vx[i]+=random(-.1, .1);
      vy[i]+=random(-.1, .1);
    }
  }
  



  println(frameRate);
}

