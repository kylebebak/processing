void setup() {
  size(600, 600);

  test(11, random(.25*width, .75*width), random(.25*height, .75*height));
}

void test(float in, float x, float y) {
  float initialVal=in;
  ttest(in, x, y, initialVal);
}
void ttest(float in, float x, float y, float initialVal) {
  rectMode(CENTER);
  fill(100, 50);
  in-=1;
  if (in > 0) {
    for (int i=0; i<2; i++) {
      rect(x, y, in*in*sqrt(in), in*in*sqrt(in));
      x=x+in*random(-10, 10);
      y=y+in*random(-10, 10);
      ttest(in, x, y, initialVal);
    }
  }
  println(initialVal);
}

