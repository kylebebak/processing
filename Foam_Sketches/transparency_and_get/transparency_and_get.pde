void draw() {

  background(0);
  noStroke();
  fill(0, 0, 255, 2);

  for (int i = 0; i < 5; i++) {
    float x = random(40, 60);
    float y = random(40, 60);
    ellipse(x, y, 20, 20);
  }

  float blueComponent = get( round(50), round(50) ) & 0xFF;
  println(blueComponent);
}



