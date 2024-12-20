float[] x, y, vx, vy;
int num=2000;

void setup() {
  smooth();
  size(400, 400);
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

    ellipse(x[i], y[i], 10, 10);
    for (int j=i+1; j<num; j++) {
      if (dist(x[i], y[i], x[j], y[j]) < 10) {
        vx[i]+=random(-.1,.1);
        vy[i]+=random(-.1,.1);
      }
    }
  }



  println(frameRate);
}

