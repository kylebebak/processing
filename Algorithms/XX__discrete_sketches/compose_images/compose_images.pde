void setup() {

  String imgPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/XX__discrete_sketches/img/XX__constellation/temp/";
  String bgName = "2014_08_04|00.21.54|constellation_bw.png";
  String imgName = "constellation.png";
  PImage bgImg = loadImage(imgPath + bgName);
  PImage img = loadImage(imgPath + imgName);
//  img.resize(1700, 0);
  
  // size of canvas is same as size of image
  size(img.width, img.height);
  
//  tint(0, 153, 204);  // Tint blue
  image(bgImg, 0, 0);
  
//  tint(255, 110);
tint(255, 225);
image(img, 0, 0);
  



  // prepend timestamp to output image so that its name is unique and it doesn't overwrite other files
  String timestamp = nf(year(), 4) + "_" + nf(month(), 2) + "_" + nf(day(), 2)
    + "|" + nf(hour(), 2) + "." + nf(minute(), 2) + "." + nf(second(), 2);

  // save image to same directory where input images are stored, and exit program
  save(imgPath + timestamp + "|" + imgName);
  exit();
}
