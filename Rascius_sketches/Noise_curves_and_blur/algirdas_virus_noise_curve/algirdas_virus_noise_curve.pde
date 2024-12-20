int num=25;
float a;

void setup() {
  size(400, 400);
  smooth();
}

void draw() {

  if (mousePressed && mouseButton == LEFT) filter(BLUR);
  if (mousePressed && mouseButton == RIGHT) background(204);
  //204 in grayscale is the default background color

  num=constrain(num, 3, 100);

  beginShape();
  for (int i=0; i<num+3; i++) {

    float n=noise(.5*(i%num), frameCount*.015);
    a=2*PI*i/num;

    //curveVertex(width/2+(frameCount%200)*cos(a)*n,
    //height/2+(frameCount%200)*sin(a)*n);

    curveVertex(width/2+250*abs(sin(frameCount*2*PI/800))*cos(a)*n, 
    height/2+250*abs(sin(frameCount*2*PI/800))*sin(a)*n);
  }
  endShape();
}


void keyPressed() {
  if (key == '-') num--;
  if (key == '=') num++;
  println(num);
}

