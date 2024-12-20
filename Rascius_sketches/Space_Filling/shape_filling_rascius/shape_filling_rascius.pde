/**
 * Scattered Letters
 * by Algirdas Rascius.
 * <br/>
 * Click to restart.
 * variable renaming and comments by Kyle Bebak
 */


////leaves images is 6*6 sprites, total dimension is 804 x 750, each sprite has dimension
////of 134 x 125


int frames = 36;
PImage spritesImage;
PImage[] sprites = new PImage[frames];
float[] frame_size = new float[2];
int[] framesDim = {
  6, 6
};





PFont font;
PImage backgroundImage;
float[] imageScale = {
  6, 6
};
float thresholdValue = .24;

float currentSize;
float initialSize = 200;
float minSize = 40;
float shrinkingFactor = .99;
int characterSpacing = 1;
int numberAttemptsToDrawLetter = 350;


//colorMode is set to HSB, with hues varying from 0 to 2*PI,
//and saturation, brightness and alpha varying from 0 to 1


void setup() {
//  /Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/shape_filling_rascius/
  spritesImage = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/shape_filling_rascius/transparent_leaves.png");
  backgroundImage = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/shape_filling_rascius/kyle_face1.png");
  backgroundImage.resize(round(backgroundImage.width*imageScale[0]), 
  round(backgroundImage.height*imageScale[1]));
//  backgroundImage.filter(THRESHOLD, thresholdValue);
//  backgroundImage.filter(INVERT);

  colorMode(HSB, TWO_PI, 1, 1, 1);
  size(backgroundImage.width, backgroundImage.height);
  smooth();


  frame_size[0] = spritesImage.width/framesDim[0];
  frame_size[1] = spritesImage.height/framesDim[1];

  for (int i=0; i<frames; i++)
    sprites[i] = spritesImage.get((i % framesDim[0]) * (int)frame_size[0], 
    ( i / framesDim[1] ) * (int)frame_size[1], (int)frame_size[0], (int)frame_size[1]);


  initialize();
}




void draw() {

  //image(backgroundImage, 0, 0);

  if (currentSize > minSize) {
    if (!randomLetter(currentSize)) {
      currentSize *= shrinkingFactor;
    }
    // size is only shrunken if a letter couldn't be fit onto the screen,
    //    the program is given a certain number of tries to place a letter
    //    during each call to draw, and if it's successful, the letterSize stays
    //    the same and the function is called with the same letter size in the next
    //    call to draw, otherwise the letter size is decreased so that there is a better
    //    chance it will fit into the drawing in the next call to draw
  } 
  else {
    //filter(GRAY);
    println("Drawing finished");
    save("output.png");
    noLoop();
  }
  // program will draw letters in white space until
  //  current size is less than minSize, like a while condition
  //  for draw. after this the draw call is empty
}



// restart drawing when any key is pressed
void initialize() {
  background(color(0, 0, 1, 1));
  currentSize = initialSize;
}
void keyPressed() {
  if (key == 'r' || key == 'R') initialize();
}



/*this function renders a letter in a PGraphics called
 g which has the same size as the letterSize, then scales
 the size so that the letter, which will be drawn with the initial
 font size, actually fits into the continually shrinking PGraphics
 */
boolean randomLetter(float letterSize) {
  int intLetterSize = (int)letterSize;

  PGraphics g = createGraphics(intLetterSize, intLetterSize);
  // this PGraphics gets progressively smaller as the letterSize,
  //  which is assigned to the currentSize value passed into randomLetter,
  //  gets smaller from frame to frame
  g.beginDraw();
  g.background(color(0, 0, 1, 0));
  // this color is rgb(255), "WHITE", but in HSB format. the alpha value
  // of the background is zero, so that this PGraphics gets drawn into the canvas 
  // like it was a sprite, with the letter totally opaque on top of the totally
  //  transparent background
  g.fill(color(0, 0, 0));
  g.imageMode(CENTER);
  g.translate(letterSize/2, letterSize/2);
  g.rotate(random(TWO_PI));
  g.scale(initialSize/frame_size[0]);
  g.scale(letterSize/initialSize);
  //  scale factor makes letter drawn into the PGraphics g progressively smaller 
  g.image(sprites[(int)random(sprites.length)], 0, 0);
  g.endDraw();


  PGraphics gMask = createGraphics(intLetterSize, intLetterSize);
  gMask.beginDraw();
  gMask.background(color(0, 0, 1, 1));
  gMask.image(g, 0, 0);
  for (int i=0; i<characterSpacing; i++) gMask.filter(ERODE);
  /* calls to filter(ERODE), which is the opposite of filter(DILATE),
   replace white pixels with darker pixels at borders between the two. this
   effectively makes letters in the gMask PGrpahics slightly bigger,
   which makes overlap more likely to occur when the gMask is checked against
   the actual canvas in the for loops below. the letters that are drawn to the canvas
   are drawn from the PGraphics g, which does not have these bigger letters,
   so this increases the effective spacing between the letters that are actually
   drawn to the canvas. the program would work fine without this gMask, but this
   effect of increasing the spacing between letters couldn't be achieved. 
   
   ***another way to do it would be to draw a letter to the gMask
   with a scaling factor that was just slightly larger
   than the scaling factor used in g*/
  gMask.endDraw();


  for (int tries=numberAttemptsToDrawLetter; tries>0; tries--) {
    // a certain number of tries is allotted to draw a letter to the canvas
    //    without overlap, if the letter hasn't been drawn by this number of tries
    //    the function finally returns false. it doesn't return false until this number
    //    of tries has been exhausted, and will return true if a character is
    //    successfully drawn any time before this number of tries is exhausted
    int x = (int)random(width-intLetterSize);
    int y = (int)random(height-intLetterSize);

    boolean fits = true;
    /* if brightness on the PGraphics is low, that means the given
     pixel on the PGraphics is black, which means that space is occupied by
     the drawn character. if this is true, a random x and y which vary between
     0 and the effective width and height of the canvas are added to the coordinates
     of this pixel and the corresponding pixel in the canvas is checked. if it's black
     there is overlap and the for loops end and the function goes to the next without
     drawing the image. if the function goes through all the pixels in the PGraphics
     and the corresponding pixels on the canvas and there is no overlap of black
     then the function draws the letter from the PGraphics onto the canvas and 
     returns true */
    for (int dx = 0; dx<intLetterSize && fits; dx++) {
      for (int dy = 0; dy<intLetterSize && fits; dy++) {
        if (brightness(gMask.get(dx, dy))<0.96) {
//          if (brightness(get(x+dx, y+dy))<0.96 || brightness(backgroundImage.get(x+dx, y+dy))<0.96) {
  if (brightness(get(x+dx, y+dy))<0.96 || ((backgroundImage.get(x+dx, y+dy) >> 24) & 0xFF) < 50) {
            fits = false;
          }
        }
      }
    }
    if (fits) {
      image(g, x, y);
      return true;
    }
  }
  return false;
}

