PImage fadingBackground;

void setup() {

  fadingBackground = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/TSP/fade_out_for_movie/0653.png");  
  size(fadingBackground.width, fadingBackground.height);

  colorMode(HSB, 2 * PI, 1, 1, 1);
  image(fadingBackground, 0, 0);
}



void draw() {


  fill(0, .1);
  rect(0, 0, width, height);


  saveFrame("/Users/kylebebak/Desktop/frames2/####.png");
}

