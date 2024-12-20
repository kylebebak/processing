int i;
int j;
int k;
float h=40;
float w=40;
float c1;

void setup()
{
  size(400, 400); 
  noStroke();     
  frameRate(20);
}

void draw()
{
  for (j=0; j<height/h; j=j+1) {
    for (k=0; k<width/w; k=k+1) {
    c1=random(0,255);
    fill(0,0,c1);
    rect(k*w,j*h,w,h);
    }
  }
}
