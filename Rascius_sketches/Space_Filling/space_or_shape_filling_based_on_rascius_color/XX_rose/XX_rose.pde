/**
 * Scattered Letters
 * by Algirdas Rascius.
 * <br/>
 * Click to restart.
 * variable renaming and comments by Kyle Bebak
 */


/*
for kyle_miriam2.jpeg, a scale of 5, 5 resulted in an image size of about 5000 x 3500,
 thresholdValue = .245, initialSize = 600, minSize = 25, shrinkingFactor = .9875, characterSpacing = 1
 numberAttemptsToDrawLetter = 350
 */

import processing.pdf.*;

PFont font, katakanaFont;
boolean japaneseFont = false;
//this boolean toggles between using katakana and a roman alphabet font

PImage backgroundImage;
float[] imageScale = {
  2.5, 2.5
};
float thresholdValue = .3;

float currentSize;
float initialSize = 700;
float minSize = 16.75;
float shrinkingFactor = .9825;
int characterSpacing = 1;
int fontSize = round(.75 * initialSize);
int numberAttemptsToDrawLetter = 225;
//fontSize actually determines the size of the letters drawn into PGrpahics which
//have dimensions currentSize x currentSize. initial size has to be bigger than fontSize
//so that the letters drawn will actually fit into the PGraphics

//colorMode is set to HSB, with hues varying from 0 to 2*PI,
//and saturation, brightness and alpha varying from 0 to 1
float letterHue = PI/10.0;
float hueRange = -PI/1.3;


void setup() {
  //  Road_Works.svg.png, face1.jpg
  backgroundImage = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/space_or_shape_filling_based_on_rascius_color/rose/12.jpg");
  backgroundImage.resize(round(backgroundImage.width*imageScale[0]), 
  round(backgroundImage.height*imageScale[1]));
  backgroundImage.filter(THRESHOLD, thresholdValue);
  backgroundImage.filter(INVERT);

  colorMode(HSB, TWO_PI, 1, 1, 1);
  size(backgroundImage.width, backgroundImage.height);
  initFont();
  smooth();

  initialize();
  
}


// this function creates a font, i'm not sure why rascius didn't use
// one of the preloaded processing fonts. i've read that create font works
// better when outputting text to a pdf, maybe that's why?
void initFont() {

  //  char[] chars = new char['Z'-'A'+1];
  //  for (char c='A'; c<='Z'; c++) {
  //    chars[c-'A'] = c;

  char[] chars = new char[127-33];
  for (char c=33; c<127; c++) {
    chars[c-33] = c;
  }
  // char 'A' has an int value of 65, 'B' is 66, and so on.
  //  in the expression chars[c-'A'] = c;    c-'A' is converted
  //  automatically to an integer because it's being used as the index
  //  of an array, while the c after the assignment operator is
  //  being treated as its normal data type, a char
  font = createFont("MyFont", fontSize, true, chars);
  katakanaFont = createFont("Katakana", fontSize, true);
  //  createFont(name, size, smooth, charset)
}



void draw() {

  //image(backgroundImage, 0, 0);

  if (currentSize > minSize) {
    if (!randomLetter(currentSize)) {
      currentSize *= shrinkingFactor;
      println(currentSize);
    }
    // size is only shrunken if a letter couldn't be fit onto the screen,
    //    the program is given a certain number of tries to place a letter
    //    during each call to draw, and if it's successful, the letterSize stays
    //    the same and the function is called with the same letter size in the next
    //    call to draw, otherwise the letter size is decreased so that there is a better
    //    chance it will fit into the drawing in the next call to draw
  } 
  else {
    println("Drawing finished");
    //save("output.png");
    // tif is lossless, very high quality, so is png. png is much smaller than tif
    // and so is probably the better option among the two. jpg is lossy but much smaller,
    // as long as there aren't sharp color transitions (like with text) jpg is fine.
    // pdf is very small, but for these images with text it does just as well as
    // tif but is 50x smaller! i think i should never use tif, and for this sketch
    // i don't need png because pdf does a great job with text. for the images with
    // leaves png will probably be the way to go
    PGraphics pdf = createGraphics(width, height, PDF, "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/Rascius sketches/Space Filling/space_or_shape_filling_based_on_rascius_color/output.pdf");
    pdf.beginDraw();
    pdf.image(get(), 0, 0);
    pdf.dispose();
    pdf.endDraw();
    noLoop();
  }
  // program will draw letters in white space until
  //  current size is less than minSize, like a while condition
  //  for draw. after this the draw call is empty
}



// restart drawing when any key is pressed
void initialize() {
  background(color(0, 0, 0));
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
  float lH = letterHue - hueRange + 
    (4 * pow( ((currentSize - minSize) / (initialSize - minSize)) - .5, 3.0) + .5) * hueRange * 2;
  g.fill(color(lH, 1, 1, 1));
  g.textAlign(CENTER, CENTER);
  g.translate(letterSize/2, letterSize/2);
  g.rotate(random(TWO_PI));
  g.scale(letterSize/initialSize);
  //  scale factor makes letter drawn into the PGraphics g progressively smaller
  //  g.text((char)random('A', 'Z'+1), 0, 0); 
  if (!japaneseFont) {
    g.textFont(font);
    g.text((char) int(random(33, 127)), 0, 0);
  } 
  else {
    g.textFont(katakanaFont); 
    g.text((char) int(random(33, 109)), 0, 0);
  }
  //  text(c, x, y);
  g.endDraw();


  PGraphics gMask = createGraphics(intLetterSize, intLetterSize);
  gMask.beginDraw();
  gMask.background(color(0, 0, 0, 1));
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
        if (brightness(gMask.get(dx, dy)) != 0) {
          if (brightness(get(x+dx, y+dy)) != 0 || brightness(backgroundImage.get(x+dx, y+dy)) < 0.5) {
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

