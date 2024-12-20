background(0, 0, 50);
size(1250, 750);
smooth();

int num=500;
float[] x=new float[num];
float[] y=new float[num];
float[] r=new float[num];

float power=-2.5;
float rad=10;
float randmax=pow(25*rad, power+1);
float randmin=pow(rad, power+1);

noStroke();
fill(0, 79, 232, 40);
for (int i=0; i<num; i++) {
  x[i]=random(0, width);
  y[i]=random(0, height);


  r[i]=pow( random(randmax, randmin), 1 / (power+1) );
  ellipse(x[i], y[i], 2*r[i], 2*r[i]);
}

strokeWeight(.5);
stroke(0);
for (int i=0; i<num; i++) {
  for (int j=i+1; j<num; j++) {

    if ( dist(x[i], y[i], x[j], y[j]) < r[i] + r[j] )
      line(x[i], y[i], x[j], y[j]);
  }
}

strokeWeight(2);
stroke(0);
fill(255);
for (int i=0; i<num; i++) ellipse(x[i], y[i], 4, 4);

