/* get vertex code returns and integer 0 through 4
 the integers, in order, correspond to the following
 VERTEX, BEZIER_VERTEX, QUAD_BEZIER_VERTEX, CURVE_VERTEX, BREAK
 BREAK corresponds to a move to instruction in the SVG curve,
 this can be done by endShape and then beginShape with 
 a vertex at the given coords
 */

PShape sh;
PShape ch;
float[] x, y;
int[] codes;
int V;

void setup() {
  size(1200, 700);
  smooth();
  sh = loadShape("map.svg");
  ch = sh.getChild("OH");
  codes=ch.getVertexCodes();
  V=codes.length;
  println("number of vertices (not the same as vertex count) = " + V);
  x=new float[V];
  y=new float[V];
  noLoop();
}

void draw() {

  background(204);

  for (int i=0; i<V; i++) {
    x[i]=ch.getVertexX(i);
    y[i]=ch.getVertexY(i);


    println("x = " + x[i] + ", y = " + y[i]
      + ", vertex code = " + codes[i]);
  }

  stroke(0);
  ch.disableStyle();
  shape(ch, 0, 0);


  translate(width/2-x[0], height/2-y[0]);

  beginShape();
  
  for (int i=0; i<V; i++) {
    if (x[i] != 0 && y[i] != 0) {
    if (codes[i]==0) vertex(x[i], y[i]);
    else if (codes[i]==1) {
      bezierVertex(x[i], y[i], x[i+1], y[i+1], x[i+2], y[i+2]);
      i+=2;
    }
    else if (codes[i]==4) {
      endShape(CLOSE);
      beginShape();
      vertex(x[i], y[i]);
    }
  }
  }

  endShape(CLOSE);
}

