/*
 * Color Blindness by Algirdas Rascius (http://mydigiverse.com).
/**
 * Mouse-click to restart.
 */
//there are 56 symbols in total in the image file symbols.png, the size
//is 1008 x 1152 pixels, and each image is a square that's 144 x 144 pixels.
//it has 7 x 8 images


CircleSet circles;
PImage symbolsImg;
int currentSymbol;
float currentHue;

int[] imagesDim = {7, 8};
int[] imagesSize = {144, 144};
int numImages = imagesDim[0] * imagesDim[1];


void setup() { 
  symbolsImg = loadImage("symbols.png");

  size(700, 700);
  noStroke();
  smooth();
  colorMode(HSB, 1);
  frameRate(30);
  initialize();
}

void initialize() {
  background(#000000);
  currentSymbol = floor(random(numImages));
  currentHue = random(1);
  circles = new CircleSet();
  if ( int(random(2)) == 0 ) symbolsImg.filter(INVERT);
}

void draw() {
  circles.growAll();
}


void mousePressed() {
  initialize();
}

void keyPressed() {
  initialize();
}

color getColor(int x, int y) {
  int xx = imagesSize[0]*(currentSymbol % imagesDim[0]) + 1 + imagesSize[0]*x/width;
  int yy = imagesSize[1]*(currentSymbol / imagesDim[0]) + 1 + imagesSize[1]*y/height;
  float hue;
  if (brightness(symbolsImg.get(xx, yy)) >= random(1)) {
    hue = currentHue + random(0.1);
  } 
  else {
    hue = currentHue + 0.2 + random(0.8);
  }
  return color(hue%1, random(0.7, 1), random(0.7, 1), random(0.03, 0.3));
}



//-------------------------------------------------------------
class CircleSet {
  ArrayList circles = new ArrayList();
  ArrayList activeCircles = new ArrayList(); 

  CircleSet() {
  }

  Circle addRandomCircle() {
    int x = round(random(5, width-5));
    int y = round(random(5, height-5));
    return checkFit(x, y, 2) ? new Circle(x, y) : null;
  }

  boolean checkFit(int x, int y, int r) {
    return checkFit(x, y, r, null);
  }

  boolean checkFit(int x, int y, float r, Circle c) {
    for (int i=0; i<circles.size(); i++) {
      Circle circle = (Circle)circles.get(i);
      if (circle !=c) {
        if (dist(x, y, circle.centerX, circle.centerY) <= r + circle.radius + 1) {
          return false;
        }
      }
    }
    return true;
  }

  void growAll() {
    ArrayList oldActive = activeCircles;
    activeCircles = new ArrayList();
    for (int i=0; i<oldActive.size(); i++) {
      Circle circle = (Circle)oldActive.get(i);
      boolean growSuccess = circle.grow();
      if (growSuccess) {
        activeCircles.add(circle);
      } 
      else {
        addRandomCircle();
        addRandomCircle();
        addRandomCircle();
      }
    }
    int count = 500;
    while (activeCircles.size () < 3 && (count--)>0) {
      addRandomCircle();
    }
  }

  //-------------------------------------------------------------
  class Circle {
    int centerX;
    int centerY;
    float radius;
    color clr;
    float growRate;
    float maxRadius;
    boolean canGrow;
    int drawOverCount; 

    Circle(int x, int y) {
      centerX = x;
      centerY = y;
      radius = 0;
      clr = getColor(x, y);
      growRate = random(0.5, 2);
      maxRadius = random(2, 5.5);
      canGrow = true;
      drawOverCount = 0;
      circles.add(this);
      activeCircles.add(this);
    }

    boolean grow() {
      canGrow =
        canGrow &&
        radius < maxRadius &&
        centerX > radius+20 &&
        centerX < width - radius-20 &&
        centerY > radius+20 &&
        centerY < height - radius-20 &&       
        checkFit(centerX, centerY, radius+growRate, this);

      if (canGrow) {
        radius += growRate;
      } 
      else {
        drawOverCount++;
      }

      fill(clr);
      ellipse(centerX, centerY, 2*radius, 2*radius);

      return drawOverCount < 20;
    }
  }
};

