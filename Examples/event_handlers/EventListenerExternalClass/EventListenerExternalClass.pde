ExternalClass ec;

void setup() {
  size(100, 100);
  noStroke();
  background(0);

  ec = new ExternalClass(this);
}

void draw() {
}
/* the draw method in the main sketch must be called, even if it's empty, or
events in the external class won't be recognized */

