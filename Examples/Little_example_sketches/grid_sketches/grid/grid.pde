float span;
float side;
float c1;
void setup()
{
  size(500,500); 
  rectMode(CENTER);
  noStroke();
  span=dist(25,25,width,height);
}

void draw() 
{
  background(0);

  for(int i=25; i<width; i+=25) {
    for(int j=25; j<height; j+=25) {
      c1=random(0,255);
      fill(0,0,c1);
      side=dist(mouseX,mouseY,i,j);
      side=side/span*25;
      rect(i,j,side,side);
    }
  }
}
