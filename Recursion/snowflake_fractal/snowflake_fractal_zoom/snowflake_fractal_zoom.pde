float[] triangleCenter = new float[2];
float triangleSize = 600;
float angle = 0;
float dAngle = .075;
float zoom = 2.75;


void setup() {
  size(800, 800);
  background(0);

  triangleCenter[0] = width/4.0;
  triangleCenter[1] = height/4.0;
}

void draw() {

  angle += dAngle;  
  zoom = 3.5 - 1.5 * pow(frameCount, .333);
  float zoomThreshold = 0;
  //  zoom -= zoom * .3;
  //  float zoomThreshold = .15;

  triangleCenter[0] +=6;
  triangleCenter[1] += 3;

  if (zoom > zoomThreshold) drawTriangleFractal(generateTriangleVertices(triangleSize), triangleCenter, angle, zoom, 4);
}







void pushOutTriangle(float x0, float y0, float x1, float y1, int iterations) {
  smooth();
  colorMode(HSB, 360, 100, 100);
  stroke(random(360), 100, 100);
  /* this works as long as the segments of triangle are drawn
   counterclockwise, the is to the right of the line as you walk
   along it from its starting point to its endpoint */

  float len = dist(x0, y0, x1, y1);
  float[] base0 = {
    lerp(x0, x1, 1/3.0), lerp(y0, y1, 1/3.0)
    };
  float[] base1 = {
    lerp(x0, x1, 2/3.0), lerp(y0, y1, 2/3.0)
    };
  float[] midPoint = {
    lerp(x0, x1, .5), lerp(y0, y1, .5)
    };
    float angle = atan2(y1 - y0, x1 - x0);
  angle += PI/2;
  float triHeight = (len / 3.0) * (sqrt(3) / 2);
  float[] p = {
    midPoint[0] + triHeight*cos(angle), 
    midPoint[1] + triHeight*sin(angle)
    };
    line(x0, y0, base0[0], base0[1]);
  line(base0[0], base0[1], p[0], p[1]);
  line(p[0], p[1], base1[0], base1[1]);
  line(base1[0], base1[1], x1, y1);



  iterations--;
  if (iterations > 0) {
    pushOutTriangle(x0, y0, base0[0], base0[1], iterations);
    pushOutTriangle(base0[0], base0[1], p[0], p[1], iterations);
    pushOutTriangle(p[0], p[1], base1[0], base1[1], iterations);
    pushOutTriangle(base1[0], base1[1], x1, y1, iterations);
  }
}





float[] generateTriangleVertices(float sideLength) {
  float[] v = new float[6];
  float altitude = sideLength * sqrt(3) / 2.0;
  v[0] = 0;
  v[1] = 0 - (2 / 3.0) * altitude;
  v[2] = 0 - sideLength / 2.0;
  v[3] = 0 + (1 / 3.0) * altitude;
  v[4] = 0 + sideLength / 2.0;
  v[5] = 0 + (1 / 3.0) * altitude;
  return v;
}




void drawTriangleFractal(float[] vertices, float[] triangleCenter, float angle, float zoom, int iterations) {
  float[] v = vertices;
  strokeWeight(2);

  pushMatrix();
  translate(triangleCenter[0], triangleCenter[1]);
  rotate(angle);
  scale(zoom);
  pushOutTriangle(v[0], v[1], v[2], v[3], iterations);
  pushOutTriangle(v[2], v[3], v[4], v[5], iterations);
  pushOutTriangle(v[4], v[5], v[0], v[1], iterations);
  popMatrix();
}

