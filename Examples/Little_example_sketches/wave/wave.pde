int val=10;
float x[]=new float[val];
float y[]=new float[val];
float initspan;
float span;
float side;
void setup() {
  size(500,500);
  smooth();
  noStroke();
  rectMode(CENTER);
  initspan=dist(25,25,width,height);
}
void draw() {
  background(0);
  for (int i=1; i<val; i=i+1) {
    x[i-1]=x[i];
    y[i-1]=y[i];
  }
  x[val-1]=mouseX;
  y[val-1]=mouseY;
  for (int k=0; k<val; k=k+1) {
    for(int i=25; i<width; i+=50) {
      for(int j=25; j<height; j+=50) {
        side=dist(x[k],y[k],i,j);
        side=pow(side,.5*(k+1));
        span=pow(initspan,.5*(k+1));
        side=side/span*50;
        rect(i,j,side,side);
      }
    }
  }
}
