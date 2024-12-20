Stoplight sl;

void setup() {
  size(200, 200);
  smooth();

  float[] pos = {
    .5*(float)width, .5*(float)height
  };
  sl = new Stoplight(200, 50, 250, pos, 5.0);
  
  /* ~~~ Stoplight constructor ~~~
  Stoplight (int greenTime, int yellowTime, int redTime, 
  float[] pos, float radius)
  */
}



void draw() {
  background(127);
  sl.update();
}



class Stoplight {
  int lightState = 0;
  int greenTime, yellowTime, redTime, totalPeriod, currentTime;
  color GREEN = color(0, 255, 0);
  color YELLOW = color(255, 255, 0);
  color RED = color(255, 0, 0);
  color currentColor = GREEN;
  float[] pos;
  float radius;
  float[] lightHeight = new float[3];

  Stoplight (int greenTime, int yellowTime, int redTime, 
  float[] pos, float radius) {
    this.greenTime = greenTime;
    this.yellowTime = yellowTime;
    this.redTime = redTime;
    totalPeriod = greenTime + yellowTime + redTime;
    this.pos = pos;
    this.radius = radius;
    for (int i = 0; i <= 2; i++) lightHeight[i] = (i-1)*(8/3.0)*radius;
  }

  void update() {

    currentTime = (currentTime + 1) % totalPeriod;

    switch(lightState) {
    case 0:
      if (currentTime >= greenTime) {
        lightState = 1;
        currentColor = YELLOW;
      }
      break;
    case 1:
      if (currentTime >= greenTime + yellowTime) {
        lightState = 2; 
        currentColor = RED;
      }
      break;
    case 2:
      if (currentTime == 0) {
        lightState = 0; 
        currentColor = GREEN;
      }
      break;
    }

    noStroke();
    fill(0);
    rectMode(CENTER);
    rect(pos[0], pos[1], (8 / 3.0) * radius, 9 * radius, .5 * radius);
    fill(currentColor);
    ellipse(pos[0], pos[1] + lightHeight[lightState], 
    2 * radius, 2 * radius);
  }
}

