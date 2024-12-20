float j=0;
float k=0;
float a;
float r=40;
float R=250;
PImage c;

void setup()
{
  size(400, 400); 
  noStroke();     
  frameRate(30);
  smooth();
  c = loadImage("buddha.jpg");
}

void draw() 
{ 
  background(255, 255, 150);

  imageMode(CORNERS);
  image(c, width/2-55, height/2-70, width/2+55, height/2+70);

  if (k>6*PI) {
    k=0;
  }
  fill(125+25*sin(k), 125+25*sin(k), 190+60*sin(k));
  if (j>2*PI) {
    j=0;
  }
  for (float a = 0; a < 2*PI; a=a+2*PI/120+2*PI/120) { 
    quad(width/2+r*cos(a), height/2+r*sin(a), width/2+r*cos(a+2*PI/120), height/2+r*sin(a+2*PI/120), width/2+R*cos(a), height/2+R*sin(a), width/2+R*cos(a+2*PI/120), height/2+R*sin(a+2*PI/120));
  }
  for (float a = 0; a < 2*PI; a=a+2*PI/120+2*PI/125) { 
    quad(width/2+r*cos(a+j), height/2+r*sin(a+j), width/2+r*cos(a+j+2*PI/125), height/2+r*sin(a+j+2*PI/125), width/2+R*cos(a+j), height/2+R*sin(a+j), width/2+R*cos(a+j+2*PI/125), height/2+R*sin(a+j+2*PI/125));
  }
  j=j+2*PI/2400;
  k=k+2*PI/150;
} 

