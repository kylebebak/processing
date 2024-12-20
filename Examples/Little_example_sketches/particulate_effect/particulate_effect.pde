float R;
float a;
float s;
float c1;


void setup()
{
  size(500, 500); 
  rectMode(CENTER);
  noStroke();
}

void draw() 
{
  background(0);

  for (int i=1; i<100; i+=1) {
    R=random(10, 200);
    a=random(0, 2*PI);
    s=random(3, 10);
    c1=random(0, 255);
    fill(c1, 0, 0);
    rect(mouseX+R*cos(a), mouseY+R*sin(a), s, s);
  }
}

