size(600, 600);
smooth();
noFill();
background(0);
stroke(#00FFFF);
for (int i=0; i<100; i++) {
  pushMatrix();
  translate(random(0, width), random(0, height));
  rotate(random(0, 2*PI));
  ellipse(0, 0, random(100), random(100));
  popMatrix();
}
filter(BLUR);

