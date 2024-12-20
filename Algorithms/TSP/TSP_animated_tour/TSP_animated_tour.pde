int N;
int pointsPerFrame;
Point[] points;

PImage backgroundImage;
float imageScale;
float bwThreshold;

int fadeFrames;
float fadePercent;
float hueChange;

Tour t;
int fc = 0; // frame counter
float hue = 0;



void setup() {

  String projectPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/TSP/TSP_animated_tour/";
  String lines[] = loadStrings(projectPath + "kyle_and_miri_ghosts_flashes");
  // parse variables from plain text file with 9 lines and no white space
  // lines are (0 - 1)
  //number of points, points drawn per frame
  // (2 - 4)
  // image file name, image scale, black / white filter threshold value
  // (5 - 9)
  // frames in between calls to fade, percent fade in each call to fade, 
  // delta hue per frame, boolean for inverting b / w of the image

  N = Integer.parseInt(lines[0]);
  pointsPerFrame = Integer.parseInt(lines[1]);

  backgroundImage = loadImage(projectPath + lines[2]);
  imageScale = Float.parseFloat(lines[3]);
  bwThreshold = Float.parseFloat(lines[4]);

  fadeFrames = Integer.parseInt(lines[5]);
  fadePercent = Float.parseFloat(lines[6]);
  hueChange = Float.parseFloat(lines[7]);

  boolean invert = Boolean.parseBoolean(lines[8]);



  points = new Point[N];

  colorMode(HSB, 2 * PI, 1, 1, 1);
  backgroundImage.resize( round(backgroundImage.width * imageScale), 
  round(backgroundImage.height * imageScale) );
  size(backgroundImage.width, backgroundImage.height);

  backgroundImage.filter(THRESHOLD, bwThreshold);
  if (invert) backgroundImage.filter(INVERT);

  background(backgroundImage);

  int n = 0;
  float x;
  float y;
  while (n < N) {
    x = random(width);
    y = random(height);

    if (fits(x, y)) {
      points[n] = new Point(x, y);
      n++;
    }
  }

  t = new Tour(points, true);
  //  t.drawTour();
  points = t.getTourPoints(); 
  // now points are in tour sorted order

  background(0, 0, 0);
  strokeWeight(1.5);
}





// draw a continuous loop around image
void draw() {

  if (frameCount % fadeFrames == 0) {
    noStroke();
    fill(0, 0, 0, fadePercent);
    rect(0, 0, width, height);
  }

  hue += hueChange;
  hue = hue % (2 * PI);
  stroke(hue, 1, 1);

  for (int i = 0; i < pointsPerFrame; i++) {
    points[fc].drawTo(points[ (fc + 1) % N ]);
    fc++;
    fc = fc % N;
  }
  
//  saveFrame("/Users/kylebebak/Desktop/frames/####.png");
}





boolean fits(float x, float y) {
  return brightness(get( (int) x, (int) y )) > 0;
}

