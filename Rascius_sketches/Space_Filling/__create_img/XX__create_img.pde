import processing.pdf.*;

PImage maskImg, img;
int targetDim = 2300;

int w, h;

void setup() {
  maskImg = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img/maskImg.png");
  img = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img/img1.png");
  
  if (img.width > img.height) {
    img.resize(targetDim, 0);
  } 
  else {
    img.resize(0, targetDim);
  }

  w = img.width;
  h = img.height;
  
  
  maskImg = maskImg.get(0, 0, w, h);
  maskImg.filter(THRESHOLD, .95);
  maskImg.filter(INVERT);
  

  img.mask(maskImg);
  
  background(0);
  
  smooth();
  size(w, h);

//  "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/XX__create_img/output.pdf"
  
  image(img, 0, 0);

}

