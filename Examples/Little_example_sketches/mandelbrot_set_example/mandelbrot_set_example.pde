PImage fracImg; // Global
boolean drawFractal = true;
float xmin = -2.5;
float ymin = -2.0;
float wh = 4;
int maxIterations = 1000;
int mx, my;

void setup() {
  size(800, 800, P2D);
  stroke(255);
  noFill();
}

void draw() {
  if (fracImg != null) {
    image(fracImg, 0, 0);
  }
  if (mousePressed) {
    rect(mx, my, mouseX-mx, mouseY-my);
  }
  if (drawFractal) fractal();
}

void fractal() {
  loadPixels();
  float xmax = xmin+wh;
  float ymax = ymin+wh;
  float dx = (xmax-xmin)/width;
  float dy = (ymax-ymin)/height;
  float x = xmin;
  for (int i = 0; i < width; i++) {
    float y = ymin;
    for (int j = 0;  j < height; j++) {
      float zr = x;
      float zi = y;
      int n = 0;
      while (n < maxIterations) {
        float zrr = zr*zr;
        float zii = zi*zi;
        float twori = 2*zr*zi;
        zr = zrr-zii+x;
        zi = twori+y;
        if (zrr+zii > 16) break;
        n++;
      }
      if (n == maxIterations) pixels[i+j*width] = 0;
      else {
        float fn = n+1-log(log(sqrt(zr*zr+zi*zi)))/log(2);
        float logColor = log(fn)/log(maxIterations);
        pixels[i+j*width] = color(logColor*255);
      }
      y += dy;
    }
    x += dx;
  }
  updatePixels();
  println("Time: "+millis());
  drawFractal = false;
}

void mousePressed() {
  mx = mouseX;
  my = mouseY;
  fracImg = get();
}
