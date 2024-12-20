float rotation=0;

void setup() {
  size(500, 500, P3D);
  background(255);
}


void draw() {
  background(255);
  lights();
  
  float minimumDistance = 50;
  float orbitRadius = max(minimumDistance, abs(mouseX - width / 2.0));
  float ypos = mouseY - height / 2.0;
  float xpos = cos(radians(rotation))*orbitRadius;
  float zpos = sin(radians(rotation))*orbitRadius;
  
  camera(xpos, ypos, zpos, 0, 0, 0, 0, -1, 0);

  box(25);

  rotation++;
}

