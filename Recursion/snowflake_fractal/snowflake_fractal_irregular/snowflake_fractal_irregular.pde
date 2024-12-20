float[] triangleCenter = {
  width/2.0, height/2.0
};
float triangleSize = 450.0;
/*triangleCenter and triangleSize aren't used unless
generateEquilateralTriangleVertices is called*/


float[] v = { 
  150, 400, 1150, 600, 700, 200
};
float[] dv = new float[v.length];
/*the array v contains vertices of the shape being drawn
if i'm not using the generate vertices function to make
my shape. dv is to change each vertex dynamically*/


ArrayList jointInfo = new ArrayList();
int counter = -1;
/*global variables for storing information about each joint/segment in the triangle fractal,
 and also a counter which is incremented within the recursive pushOutTriangle function.
 this counter keeps track of which index in the arrayList corresponds to the current
 joint/segment. if initialize is true, the function fills up the arrayList, and if initialize
 is false, the function gets the variables from the arrayList and increments them by some small
 random amount within a range of acceptable values for each variable. this functionality is
 handled by a helper function which accepts input for how much to increment by and also min and
 max values for each variable
 */


void setup() {
  size(1300, 750);
  background(0);

  //  drawTriangleFractal(generateEquilateralTriangleVertices(triangleSize, triangleCenter), 4);
  drawTriangleFractal(v, 5, true);
}


void draw() {
  counter = -1; 

  noStroke();
  fill(0, 255);
  rect(0, 0, width, height);

  float vectorWalk = 7;
  float maxWalk = 250;
  float[] temporaryVertices = new float[v.length];

  for (int i=0; i < v.length; i++) {
    dv[i] += random(-vectorWalk, vectorWalk);
    dv[i] = constrain(dv[i], -maxWalk, maxWalk);
    temporaryVertices[i] = v[i] + dv[i];
  }

  drawTriangleFractal(temporaryVertices, 5, false);
}




void pushOutTriangle(float x0, float y0, float x1, float y1, int iterations, boolean initialize) {
  strokeWeight(random(1,3));
  smooth();
  colorMode(HSB, 360, 100, 100);
  counter++;
  /* this works as long as the segments of triangle are drawn
   counterclockwise, the is to the right of the line as you walk
   along it from its starting point to its endpoint */


  if (initialize) {
    float[] info = {
      random(360), random(.15, .45), random(.55, .85), 
      random(.4, .6), random(-PI/4.0, PI/4.0), random(.25, .5)
      };
      jointInfo.add(info);
  }

  float[] currentInfo = (float[])jointInfo.get(counter);
  
  if (!initialize) {
    currentInfo[0] += random(-25, 25);
    if (currentInfo[0] < 0) currentInfo[0] += 360;
    if (currentInfo[0] > 360) currentInfo[0] -= 360;
    
    float lerpChange = .0175;
    currentInfo[1] += random(-lerpChange, lerpChange);
    currentInfo[1] = constrain(currentInfo[1], .075, .475);
    currentInfo[2] += random(-lerpChange, lerpChange);
    currentInfo[2] = constrain(currentInfo[2], .525, .925);
    currentInfo[3] += random(-lerpChange, lerpChange);
    currentInfo[3] = constrain(currentInfo[3], .3, .7);
    
    currentInfo[4] += random(-PI/40.0, PI/40.0);
    currentInfo[4] = constrain(currentInfo[4], -PI/4.0, PI/4.0);
    
    currentInfo[5] += random(-.02, .02);
    currentInfo[5] = constrain(currentInfo[5], .175, .625);
  }
  
  
  
  float len = dist(x0, y0, x1, y1);
  stroke(currentInfo[0], 100, 100);

  float lrp = currentInfo[1];
  float[] base0 = {
    lerp(x0, x1, lrp), lerp(y0, y1, lrp)
    };
    lrp = currentInfo[2];
  float[] base1 = {
    lerp(x0, x1, lrp), lerp(y0, y1, lrp)
    };
    lrp = currentInfo[3];
  float[] midPoint = {
    lerp(x0, x1, lrp), lerp(y0, y1, lrp)
    };
    float angle = atan2(y1 - y0, x1 - x0);
  angle = angle + PI/2 + currentInfo[4];
  float triHeight = len * currentInfo[5];
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
    pushOutTriangle(x0, y0, base0[0], base0[1], iterations, initialize);
    pushOutTriangle(base0[0], base0[1], p[0], p[1], iterations, initialize);
    pushOutTriangle(p[0], p[1], base1[0], base1[1], iterations, initialize);
    pushOutTriangle(base1[0], base1[1], x1, y1, iterations, initialize);
  }
}






void drawTriangleFractal(float[] vertices, int iterations, boolean initialize) {
  float[] v = vertices;
  pushOutTriangle(v[0], v[1], v[2], v[3], iterations, initialize);
  pushOutTriangle(v[2], v[3], v[4], v[5], iterations, initialize);
  pushOutTriangle(v[4], v[5], v[0], v[1], iterations, initialize);
}





/*this function simply generates vertices for an equilateral triangle
 with a given side length and a given center*/
float[] generateEquilateralTriangleVertices(float sideLength, float[] triangleCenter) {
  float[] v = new float[6];
  float altitude = sideLength * sqrt(3) / 2.0;
  v[0] = triangleCenter[0];
  v[1] = triangleCenter[1] - (2 / 3.0) * altitude;
  v[2] = triangleCenter[0] - sideLength / 2.0;
  v[3] = triangleCenter[1] + (1 / 3.0) * altitude;
  v[4] = triangleCenter[0] + sideLength / 2.0;
  v[5] = triangleCenter[1] + (1 / 3.0) * altitude;
  return v;
}

