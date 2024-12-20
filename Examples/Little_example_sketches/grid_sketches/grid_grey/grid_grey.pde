float dx;
float dy;
float K;
float side;
float c1;


void setup()
{
  size(500,500); 
  rectMode(CENTER);
  noStroke();
  K=2500;
}

void draw() 
{
  background(0);

  for(int i=25; i<width; i+=25) {
    for(int j=25; j<height; j+=25) {
      c1=random(125,255);
      fill(c1);
      //fill(0,0,c1);
      side=25;
      dx=K*(i-mouseX)/pow(dist(i,j,mouseX,mouseY),2.2);
      dy=K*(j-mouseY)/pow(dist(i,j,mouseX,mouseY),2.2);
      rect(i+dx,j+dy,side,side);
    }
  }
}
