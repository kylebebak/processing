void setup() 
{
  size(600, 600);
  noStroke();
  smooth();
  background(0);
  drawCircle(width/2, height/2, 250, 10);
}

void drawCircle(float x, float y, int radius, int level) 
{                    
  float tt = 126 * level/6.0;
  fill(0, tt, tt, 153);
  ellipse(x, y, radius*2, radius*2);      
  if(level > 1) {
    level = level - 1;
    int num = int(random(2, 6));
    for(int i=0; i<num; i++) {
      float a = random(0, TWO_PI);
      float nx = x + cos(a) * 10.0 * level;
      float ny = y + sin(a) * 10.0 * level;
      drawCircle(nx, ny, radius/2, level);
    }
  }
}

