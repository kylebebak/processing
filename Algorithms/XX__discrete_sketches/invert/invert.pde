void setup() {

  String imgPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/XX__discrete_sketches/img/";
  String imgName = "2014_06_29|18.59.59|kyle_face_small.png";
  
  PImage img = loadImage(imgPath + imgName);
  size(img.width, img.height);
  image(img, 0, 0);
  filter(INVERT);
  
  save(imgPath + "_inv__" + imgName);
  exit();
}
