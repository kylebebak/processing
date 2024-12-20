String imgPath = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Algorithms/XX__discrete_sketches/img/";
String imgName = "kyle_face_small.png";
PImage img;
img = loadImage(imgPath + imgName);

size(img.height, img.width);
image(img, 0, 0);
filter(GRAY);

float range = 255; // range of brightness levels, starting at 0 
int levels = 3; // number of discreet brightness levels

float[] gray = new float[width * height]; // discretized grayscale values of each pixel
float[] grayVals = new float[levels]; // discrete boundary levels for determining which group a pixel falls into


for (int i = 0; i < levels; i++) {
  grayVals[i] = i * range / levels;
}




float g;
for (int y = 0; y < height; y++) {
  for (int x = 0; x < width; x++) {


    g = brightness(get(x, y));

    for (int i = levels - 1; i >= 0; i--) {
      if (g >= grayVals[i]) {
        gray[x + y * width] = grayVals[i] + .5 * range / levels;
        break;
      }
    }
  }
}



loadPixels();

for (int i = 0; i < gray.length; i++) {
  pixels[i] = color(gray[i]);
}

updatePixels();



String timestamp = nf(year(), 4) + "_" + nf(month(), 2) + "_" + nf(day(), 2)
+ "|" + nf(hour(), 2) + "." + nf(minute(), 2) + "." + nf(second(), 2);

// save and exit
save(imgPath + timestamp + "|" + imgName);
exit();

