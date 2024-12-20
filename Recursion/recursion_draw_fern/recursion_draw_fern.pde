void setup() 
{
  size(1200, 800);
  smooth();
  drawFern(width/2, 3*height/4, random(5*PI/12, 7*PI/12), 300, 8);
  drawFern(width/10, height/7, random(-PI/12, PI/12), 350, 9);
  drawFern(9*width/10, height/2, random(PI + 6*PI/12, PI + 8*PI/12), 330, 6);
}

void drawFern(float x, float y, float angle, 
float blength, int branches)
{                 
  noFill();  
  stroke(100, 50+25*branches);
  strokeWeight((float)branches);
  float ex = x + blength * cos(angle);
  float ey = y - blength * sin(angle);
  line(x, y, ex, ey);
  /*
  bezier(x, y, x + .5 * blength * sin(angle), y + .5 * blength * cos(angle),
   ex + .5 * blength * sin(angle), ey + .5 * blength * cos(angle), ex, ey);
   */

  /*
  println(" (x, y) = (" + x + ", " + y + ")");
   println(" (ex, ey) = (" + ex + ", " + ey + ")");
   println(" angle = " + ( (angle * 360 / (2 * PI)) % 360 ) );
   */

  if (branches > 1) {
    branches -= 1;
    int num = int(random(2, 5));
    for (int i=0; i<num; i++) {

      float a = random(11*PI/24, 13*PI/24);

      if ( int(random(0, 2)) == 0 ) a += PI;
      float newx=random(min(x, ex), max(x, ex));
      float slope=(ey-y)/(ex-x);

      drawFern(newx, y + slope * (newx - x), angle+a, 
      2*blength/3, branches);
    }
  }
}

