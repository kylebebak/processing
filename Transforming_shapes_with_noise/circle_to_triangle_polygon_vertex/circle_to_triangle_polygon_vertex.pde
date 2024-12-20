int num=50;
float a;
float r=300;

void setup() {
  size(700, 700);
  smooth();
}

void draw() {

  if (num>3) if (frameCount%20==0) num--;



  beginShape();

  for (int i=0; i<num+1; i++) {
    a=2*PI*i/num;
    vertex(width/2+r*cos(a), height/2+r*sin(a));
  }

  endShape();
}

