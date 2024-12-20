int num=200;
float[] x=new float[num];
float[] y=new float[num];
float[] vx=new float[num];
float[] vy=new float[num];
float[] r=new float[num];

float power=-2;
float rad=10;
float randmax=pow(15*rad, power+1);
float randmin=pow(rad, power+1);
float maxv=1;

color background1=color(0, 0, 50);
color background2=color(255);
color backgroundColor=background1;





void setup() {
  size(1000, 700);
  background(backgroundColor);
  smooth();

  noStroke();
  fill(0, 79, 232, 40);
  for (int i=0; i<num; i++) {
    x[i]=random(0, width);
    y[i]=random(0, height);
    vx[i]=random(-maxv, maxv);
    vy[i]=random(-maxv, maxv);


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
}





void draw() {

  background(backgroundColor);

  noStroke();
  fill(0, 79, 232, 40);
  for (int i=0; i<num; i++) {
    x[i]+=vx[i];
    y[i]+=vy[i];
    
    if (x[i]>width) x[i]=0;
    if (x[i]<0) x[i]=width;
    if (y[i]>height) y[i]=0;
    if (y[i]<0) y[i]=height;
    
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
  
  if (frameCount%10==0) println(frameRate);
}





void keyReleased() {
  if (backgroundColor == background1) backgroundColor=background2;
  else backgroundColor = background1;
}

void mouseReleased() {
  for (int i=0; i<num; i++) {
    vx[i]=random(-maxv, maxv);
    vy[i]=random(-maxv, maxv);
  }
}





void updateLines(int minIndex, int maxIndex) {

  strokeWeight(.5);
  stroke(0);
  for (int i=minIndex; i<maxIndex; i++) {
    for (int j=i+1; j<num; j++) {

      if ( dist(x[i], y[i], x[j], y[j]) < r[i] + r[j] )
        line(x[i], y[i], x[j], y[j]);
    }
  }
}

