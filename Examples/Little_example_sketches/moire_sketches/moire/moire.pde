float j=0;

void setup()
{
size(1000, 600);
noStroke();
frameRate(40);
smooth();
}

void draw() 
{
  background(255);
  if (j>8.5) {j=0;}
for(int i=0;i<height;i=i+height/120+height/120) {
fill(0);
rect(0,i,width,height/120);
}
for(int i=0;i<height;i=i+height/120+height/121) {
fill(0);
rect(0,i+j,width,height/121);
}
j=j+.25;
}
