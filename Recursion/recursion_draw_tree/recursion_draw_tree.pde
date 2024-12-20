void setup() 
{
  size(600, 600);
  smooth();
  drawTree(width/2, 3*height/4, 120, 8, 8);
  drawTree(width/4, 3*height/6, 80, 7, 7);
  drawTree(3*width/4, 3*height/5, 150, 6, 6);
}

void drawTree(float x, float y, float blength, int branches, int br0) 
{
//br0 must be entered the same as branches when drawTree is called
  float treeColor = 255 * ( 1 - (float)branches / br0 );
  stroke(treeColor, 175);
  strokeWeight( (float)branches / 2 );
  float a = random(PI/6, 5*PI/6);
  float ex = x + blength * cos(a);
  float ey = y - blength * sin(a);
  line(x, y, ex, ey);  
  
  if(branches > 1) {
    branches -= 1;
    int num = int(random(3, 6));
    for(int i=0; i<num; i++) {
      drawTree(ex, ey, 2*blength/3, branches, br0);
    }
  }
}

