float j=0;
float a=PI/4;

void setup()
{
  size(600, 600); 
  noStroke();     
  frameRate(40);
}

void draw() 
{ 
  background(150,240,255);
  if (j>50) {j=0;}
  fill(127);
  for(int i=0;i<width;i=i+width/120+width/120) {
    quad(i,0,i+width/200,0,i+height*sin(a)+width/200,height,i+height*sin(a),height);
    quad(i,0,i+width/200,0,i-height*sin(a)+width/200,height,i-height*sin(a),height);
  }
  for(int i=0;i<width;i=i+width/120+width/121) {
    quad(i+j,0,i+j+width/210,0,i+j+height*sin(a)+width/210,height,i+j+height*sin(a),height);
    quad(i+j,0,i+j+width/210,0,i+j-height*sin(a)+width/210,height,i+j-height*sin(a),height);
  }
  j=j+.5;
}
