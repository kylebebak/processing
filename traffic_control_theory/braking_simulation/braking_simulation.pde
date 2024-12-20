float pos, vel, dvel;

void setup() {
  size(600, 400);
  pos = random(50, 250);
  vel = random(.5, 2.5);
}

void draw() {
  background(0);
  stroke(255);
  line(width - 10.0, 0, width - 10.0, height);
  
  pos += vel;
  dvel = sq(vel) * .5 / (width - 10.0 - pos); 
  vel -= dvel;
  
  fill(255, 0, 0);
  ellipse(pos, .5*height, 10, 10);
}

