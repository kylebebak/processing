int val=500;
float valf=val;
int rad=40;
float x[]=new float[val];
float y[]=new float[val];
void setup()
{
  size(500, 500);
  smooth();
  noStroke();
}

void draw()
{
  background(0);
  for (int i=1; i<val; i=i+1) {
    x[i-1]=x[i];
    y[i-1]=y[i];
  }
  x[val-1]=mouseX;
  y[val-1]=mouseY;
  for (int k=0; k<val; k=k+1) {
    fill(random(0, 255), random(0, 255), random(0, 255));
    float kf=k;
    ellipse(x[k], y[k], rad*kf/valf, rad*kf/valf);
  }
}

