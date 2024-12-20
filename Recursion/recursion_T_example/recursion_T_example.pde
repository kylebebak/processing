

void setup() {
  size(1000, 600);
  noLoop();
}

void draw() {
  drawT(500, 450, 150, 15);
  drawT2(250, 500, 200, 15);
  drawT2(750, 500, 200, 15);
}

void drawT(int x, int y, int apex, int num) {
  line(x, y, x, y-apex);
  line(x-apex, y-apex, x+apex, y-apex); 

  if (num>0) {
    drawT(x-apex, y-apex, apex/2, num-1);
    drawT(x+apex, y-apex, apex/2, num-1);
  }
}

void drawT2(int x, int y, int apex, int num) {
  line(x, y, x, y-apex);
  line(x-apex, y-apex, x+apex, y-apex); 

  if (num>0) {
    drawT(x-apex, y-apex, 2*apex/3, num-1);
    drawT(x+apex, y-apex, 2*apex/3, num-1);
  }
}

