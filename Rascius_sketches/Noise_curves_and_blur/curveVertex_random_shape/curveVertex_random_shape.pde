int num=10;
float[] x=new float[num];
float[] y=new float[num];

size(500, 500);
smooth();

for (int i=0; i<num; i++) {
  x[i]=random(0, width);
  y[i]=random(0, height);
}


background(127);

beginShape();
for (int i=0; i<num+3; i++) {
  curveVertex(x[i%num], y[i%num]);
  println(x[i%num]);
}

endShape();

