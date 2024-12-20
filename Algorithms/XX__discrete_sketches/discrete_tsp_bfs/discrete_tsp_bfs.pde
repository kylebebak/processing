// specifies which connected component a pixel belongs to, all contiguous pixels belonging to the same grayscale group form a component
int[][] component;
// number of pixels in each component, computed in the computeComponent BFS helper function. stored in an array list because number of components is unknown until they are all computed by BFS
ArrayList<Integer> componentSize;
// group that each component belongs to, this is also computed within the computeComponent helper function  
ArrayList<Integer> componentGroup;
// min num of pixels that can form a viable component. pixels in the component[][] array that are not part of a viable component will not be used for generating tours
int componentThreshold;

// specifies which group a given pixel belongs to, declared globally so it can be referenced within helper functions
int[][] group;




void setup() {

  String imgPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/XX__discrete_sketches/img/";
  String imgName = "kyle_face_small.png";
  PImage img = loadImage(imgPath + imgName);
  img.resize(1700, 0);

  // size of canvas is same as size of image
  size(img.width, img.height);
  image(img, 0, 0);
  // convert image to grayscale image
  // filter(GRAY);





  float range = 255; // range of brightness values (in processing this is from 0 to 255 be default) 
  int groups = 16; // number of discreet grayscale groups, i.e. brightness levels
  float pointDensity = .065; // ratio of pixels in tours to total number of pixels in component
  float baseStroke = .85; // base value of stroke weight
  float maxStrokeLength = width / 40.0; // max length between two points on a path for which the line connecting these points will be drawn

  // initialize all values in the component[][] matrix to -1
  component = new int[width][height];
  for (int x = 0; x < width; x++)
    for (int y = 0; y < height; y++)
      component[x][y] = -1;

  componentThreshold = 50;
  componentSize = new ArrayList<Integer>();
  componentGroup = new ArrayList<Integer>();

  group = new int[width][height]; // grayscale value (i.e. brightness) group a pixel falls into
  int[] groupSize = new int[groups]; // number of points in each group
  float[] boundary = new float[groups]; // boundary levels for determining which grayscale group a pixel belongs to


  // create grayscale boundary values based on number of groups
  for (int i = 0; i < groups; i++) {
    boundary[i] = i * range / groups;
  }





  // assign each pixel to a group based on its grayscale value, i.e. brightness
  float gsv;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      gsv = brightness(get(x, y));

      for (int i = groups - 1; i >= 0; i--) {
        if (gsv >= boundary[i]) {
          group[x][y] = i;
          groupSize[i]++;
          break;
        }
      }
    }
  }

  // assign each pixel to some connected component, where connected components are defined as contiguous pixels belonging to the same grayscale group
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      // only compute a component for source pixel if this pixel has not yet been assigned to a component. this helper function also adds values to the componentSize and componentGroup array lists
      if (component[x][y] == -1) computeComponent(x, y);
    }
  }





  // create a separate tour for each viable component
  ArrayList<Tour> tours = new ArrayList<Tour>();
  // number of points to placed each in tour, based on the size of each component 
  int np;
  for (int i = 0; i < componentSize.size (); i++) {

    // don't create a tour for components whose size is smaller than threshold value, add an empty tour to array list instead
    if (componentSize.get(i) < componentThreshold) {
      tours.add(new Tour());
      continue;
    }

    // number of points in tour for a given component
    np = round(componentSize.get(i) * pointDensity * pow(groups - componentGroup.get(i), .5));

    tours.add(new Tour(createPointSet(np, i), true));
  }

  // prepare to draw image
  background(255);
  smooth();

  // draw tour for each group
  for (int i = 0; i < componentSize.size (); i++) {

    // don't draw tours for components whose size is smaller than threshold size. these tours are empty
    if (componentSize.get(i) < componentThreshold) continue;

    // control stroke value and weight based on group to which component belongs, or size of component
    stroke(boundary[componentGroup.get(i)] + .5 * range / groups);
    
    // components whose groups have higher indices (higher brightness values) are drawn with the smaller strokes
    if (groups / 2 - componentGroup.get(i) < 0) strokeWeight(baseStroke * pow(groups - componentGroup.get(i), .5));
    else if (groups / 4 - componentGroup.get(i) < 0) strokeWeight(baseStroke * pow(groups - componentGroup.get(i), .65));
    else strokeWeight(baseStroke * pow(groups - componentGroup.get(i), .85));




    tours.get(i).drawTour(maxStrokeLength);
  }





  // prepend timestamp to output image so that its name is unique and it doesn't overwrite other files
  String timestamp = nf(year(), 4) + "_" + nf(month(), 2) + "_" + nf(day(), 2)
    + "|" + nf(hour(), 2) + "." + nf(minute(), 2) + "." + nf(second(), 2);

  // save image to same directory where input images are stored, and exit program
  save(imgPath + timestamp + "|" + imgName);
  exit();
}





/************************
 HELPER FUNCTIONS 
 *************************/




// create and return set of p points belonging to component c
public Point[] createPointSet(int p, int c) {
  Point[] points = new Point[p];

  for (int i = 0; i < p; i++) {

    while (true) {
      int x = (int) random(0, width);
      int y = (int) random(0, height);

      if (inComponent(x, y, c)) {
        points[i] = new Point(x, y);
        break;
      }
    }
  }

  return points;
}



// is the point x, y in the connected component c?
public boolean inComponent(int x, int y, int c) {
  return component[x][y] == c;
}

// is the point x, y in the group g?
public boolean inGroup(int x, int y, int g) {
  return group[x][y] == g;
}







// compute the connected component starting with source coordinates (sx, sy), this function modifies the global components array. components are computed with BFS
public void computeComponent(int sx, int sy) {
  int g = group[sx][sy];

  DoublingQueue<Point> q = new DoublingQueue<Point>();
  // enqueue the source point
  q.enqueue(new Point(sx, sy));


  Point p;
  int nx, ny; // x and y coordinates for neighbors of dequeued point p
  int s = 1; // size of component 
  int nComponents = componentSize.size(); // number of distinct connected components

  // this while loop contains the main logic of the BFS algorithm
  while (q.isEmpty () == false) {
    p = q.dequeue();

    nx = (int) p.getX() - 1;
    ny = (int) p.getY();
    if (inImg(nx, ny) && group[nx][ny] == g && component[nx][ny] == -1) {
      q.enqueue(new Point(nx, ny));
      component[nx][ny] = nComponents;
      s++;
    }

    nx = (int) p.getX();
    ny = (int) p.getY() - 1;
    if (inImg(nx, ny) && group[nx][ny] == g && component[nx][ny] == -1) {
      q.enqueue(new Point(nx, ny));
      component[nx][ny] = nComponents;
      s++;
    }

    nx = (int) p.getX() + 1;
    ny = (int) p.getY();
    if (inImg(nx, ny) && group[nx][ny] == g && component[nx][ny] == -1) {
      q.enqueue(new Point(nx, ny));
      component[nx][ny] = nComponents;
      s++;
    }

    nx = (int) p.getX();
    ny = (int) p.getY() + 1;
    if (inImg(nx, ny) && group[nx][ny] == g && component[nx][ny] == -1) {
      q.enqueue(new Point(nx, ny));
      component[nx][ny] = nComponents;
      s++;
    }
  }
  
  // this component contains s points
  componentSize.add(s);
  // this component belongs to grayscale group g, the group of the source point
  componentGroup.add(g);
}


public boolean inImg(int x, int y) {
  return (x >= 0 && x < width && y >= 0 && y < height);
}
