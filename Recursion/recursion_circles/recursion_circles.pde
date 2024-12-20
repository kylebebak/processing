void setup() 
{
  size(1200, 800);
  noStroke();
  smooth();
  noLoop();
}

void draw() 
{
  drawCircle(width/2, height/2, 500, 10, 10);
}

void drawCircle(int x, int y, int radius, int level, float plevel) 
{                    
  float tt = 255 * level / plevel;
  fill(tt);
  ellipse(x, y, radius*2, radius*2);      
  if(level > 1) {
    level = level - 1;
    drawCircle(x - radius/2, y, radius/2, level, plevel);
    drawCircle(x + radius/2, y, radius/2, level, plevel);
    //drawCircle(x, y - radius/2, radius/2, level);
    //drawCircle(x, y + radius/2, radius/2, level);
  }
}

