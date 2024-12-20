PImage img;
PImage[] segments = new PImage[4];
int currentImage;
 
void setup() {
  img = loadImage("kayaking_copy.png");
  size(img.width, img.height);
  segments[0] = img.get(0,0,img.width/2,img.height/2);
  segments[1] = img.get(img.width/2,0,img.width/2,img.height/2);
  segments[2] = img.get(0,img.height/2,img.width/2,img.height/2);
  segments[3] = img.get(img.width/2,img.height/2,img.width/2,img.height/2);
}
 
void draw() {
  background(0);
  image(segments[currentImage%segments.length], mouseX, mouseY);
}
 
void mousePressed() {
  currentImage++;
}





// Class for animating a sequence of GIFs
/*
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
*/
