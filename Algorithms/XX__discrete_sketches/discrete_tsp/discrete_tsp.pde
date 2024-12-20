// specifies which group a given pixel belongs to, declared globally so it can be referenced within helper functions
int[][] group;

void setup() {

  String imgPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/XX__discrete_sketches/img/";
  String imgName = "kyle_face_small.png";
  PImage img = loadImage(imgPath + imgName);
  img.resize(1500, 0);

  // size of canvas is same as size of image
  size(img.height, img.width);
  image(img, 0, 0);
  // convert image to grayscale image
  filter(GRAY);


  float range = 255; // range of brightness values (in processing this is from 0 to 255 be default) 
  int levels = 12; // number of discreet brightness levels
  float pointDensity = .05; // ratio of pixels in tours to total number of pixels in image


  group = new int[width][height]; // grayscale value (i.e. brightness) group a pixel falls into
  float[] boundary = new float[levels]; // discrete boundary levels for determining which group a pixel falls into
  int[] groupSize = new int[levels]; // number of points in each group


  // create boundary values based on number of levels
  for (int i = 0; i < levels; i++) {
    boundary[i] = i * range / levels;
  }


  // assign each pixel to a group
  float gray;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      gray = brightness(get(x, y));

      for (int i = levels - 1; i >= 0; i--) {
        if (gray >= boundary[i]) {
          group[x][y] = i;
          groupSize[i]++;
          break;
        }
      }
    }
  }



  // create a separate tour for each group
  Tour[] tours = new Tour[levels];
  int np;
  for (int i = 0; i < levels; i++) {

    // number of points in tour for given group
    np = round(groupSize[i] * pointDensity * sqrt(levels - i));

    tours[i] = new Tour(createPointSet(np, i), true);
  }


  // prepare to draw image
  background(255);
  smooth();

  // draw tour for each group
  for (int i = 0; i < levels; i++) {
    stroke(boundary[i] + .5 * range / levels);
    strokeWeight(sqrt(sqrt(levels - i)));
    drawTour(tours[i]);
  }
  
  // create timestamp so that output image has unique name and does not overwrite other images
  String timestamp = nf(year(), 4) + "_" + nf(month(), 2) + "_" + nf(day(), 2)
    + "|" + nf(hour(), 2) + "." + nf(minute(), 2) + "." + nf(second(), 2);
    
  // save and exit
  save(imgPath + timestamp + "|" + imgName);
  exit();
}





// create and return set of p points belonging to group g
public Point[] createPointSet(int p, int g) {
  Point[] points = new Point[p];

  for (int i = 0; i < p; i++) {

    while (true) {
      int x = (int) random(0, width);
      int y = (int) random(0, height);

      if (inGroup(x, y, g)) {
        points[i] = new Point(x, y);
        break;
      }
    }
  }

  return points;
}




// is the point x, y in the group g?
public boolean inGroup(int x, int y, int g) {
  return group[x][y] == g;
}


// connect all in tour in order with straight lines
public void drawTour(Tour t) {
  Point[] points = t.getTourPoints();

  for (int i = 0; i < points.length - 1; i++) {
    points[i].drawTo(points[i + 1]);
  }

  points[points.length - 1].drawTo(points[0]);
}

