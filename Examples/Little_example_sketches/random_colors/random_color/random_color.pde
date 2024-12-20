int i;
int j;
int k;
float h=40;
float w=40;
float c1;
float c2;
float c3;

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
    c2=random(0,255);
    c3=random(0,255);
    fill(c1,c2,c3);
    rect(k*w,j*h,w,h);
    }
  }
}
