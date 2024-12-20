int num=25;

void setup() {
  size(800, 300);
  smooth();
}

void draw() {

  if (mousePressed && mouseButton == LEFT) filter(BLUR);
  if (mousePressed && mouseButton == RIGHT) background(204);
  //204 in grayscale is the default background color

  num=constrain(num, 2, 50);

  beginShape();
  curveVertex(3*width, 0);
  curveVertex(-width/2, -height/2);
  curveVertex(-width/2, height/2);
  
  for (int i=0; i<num; i++) {

    float n=noise(.5*(i), frameCount*.015);
    
    curveVertex( (width/ (num-1))*i,
    1.5*height*abs(sin(frameCount*2*PI/800))*n);
    
  }
  
  curveVertex(3*width/2, height/2);
  curveVertex(3*width/2, -height/2);
  curveVertex(-width/2, -height/2);
  curveVertex(width/2, 3*height);
  
  endShape();
}


void keyPressed() {
  if (key == '-') num--;
  if (key == '=') num++;
  println(num);
}

