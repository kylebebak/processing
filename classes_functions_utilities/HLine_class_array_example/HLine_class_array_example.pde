// Declare and construct two objects (h1, h2) from the class HLine 
int number_lines = 50;
HLine[] hl = new HLine[number_lines]; 
 
void setup() 
{
  size(200, 200);
  for (int i=0; i<hl.length; i++) hl[i] = new HLine(random(200), random(5));
  
}

void draw() { 
  background(204);
  for (int i=0; i<hl.length; i++) hl[i].update(); 
} 
 
class HLine { 
  float ypos, speed; 
  HLine (float y, float s) {  
    ypos = y; 
    speed = s; 
  } 
  void update() { 
    ypos += speed; 
    if (ypos > height) { 
      ypos = 0; 
    } 
    line(0, ypos, width, ypos); 
  } 
} 
