/* make array lists of letter/sprite objects, one for
 static letters and one for letters which have been erased and are
 now falling
 
 these letter objects will be instances of a class
 that has fields for position, velocity,
 acceleration, angles, and angular velocities. they will
 have a lifespan field and a boolean dead that changes
 once their age is greater than its lifespan
 
 it will have an erase method that it uses to erase itself and
 initialize the falling letter, and it will have an update/draw
 method that it uses to move and animate itself once it's falling.
 it will draw itself in a PGraphics using P3D and then put this image
 onto the main canvas. it will remove itself from the array
 list when its age is greater than its lifespan
 */


ArrayList<Letter> drawnLetters = new ArrayList<Letter>();
ArrayList<Letter> fallingLetters = new ArrayList<Letter>();
float chanceOfRemoval = .75;
int dynamicFrameCounter = 0;


PFont font;
boolean japaneseFont = true;
PImage backgroundImage;
float[] imageScale = {
  1.6, 1.6
};
PGraphics backgroundLayer;
float thresholdValue = .175;


float currentSize;
float initialSize = 175;
float minSize = 32.5;
float shrinkingFactor = .997;
int fontSize = round(.75 * initialSize);
int numberAttemptsToDrawLetter = 225;
//fontSize actually determines the size of the letters drawn into PGrpahics which
//have dimensions currentSize x currentSize. initial size has to be bigger than fontSize
//so that the letters drawn will actually fit into the PGraphics

//colorMode is set to HSB, with hues varying from 0 to 2*PI,
//and saturation, brightness and alpha varying from 0 to 1
float letterHue = PI;
float hueRange = PI / 4.0;





void setup() {

  colorMode(HSB, TWO_PI, 1, 1, 1);

  backgroundImage = loadImage("/Users/kylebebak/Desktop/Dropbox/Programming/Processing/"
  + "Rascius sketches/Space Filling/space_filling_and_disintegration_P3D_color/kyle_face1.jpeg");
  backgroundImage.resize(round(backgroundImage.width*imageScale[0]), 
  round(backgroundImage.height*imageScale[1]));
  backgroundImage.filter(THRESHOLD, thresholdValue);
  backgroundImage.filter(INVERT);

  println(backgroundImage.width);
  println(backgroundImage.height);

  size(backgroundImage.width, backgroundImage.height, P3D);

  backgroundLayer = createGraphics(backgroundImage.width, 
  backgroundImage.height, P2D);


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
  for (char c = 33; c < 127; c++) {
    chars[c-33] = c;
  }
  // char 'A' has an int value of 65, 'B' is 66, and so on.
  //  in the expression chars[c-'A'] = c;    c-'A' is converted
  //  automatically to an integer because it's being used as the index
  //  of an array, while the c after the assignment operator is
  //  being treated as its normal data type, a char

  font = japaneseFont ? createFont("Katakana", fontSize, true) :
  createFont("MyFont", fontSize, true, chars);
  //  this code does the same thing as the 2 lines below, ternary operator
  //  if (!japaneseFont) font = createFont("MyFont", fontSize, true, chars);
  //  else font = createFont("Katakana", fontSize, true);

  //  createFont(name, size, smooth, charset)
}




// initialize function, restart drawing when 'r' is pressed
void initialize() {
  background(color(0, 0, 0));

  backgroundLayer.beginDraw();
  backgroundLayer.background(color(0, 0, 0));
  backgroundLayer.endDraw();

  currentSize = initialSize;
  dynamicFrameCounter = 0;
  drawnLetters = new ArrayList<Letter>();
  fallingLetters = new ArrayList<Letter>();
}
void keyPressed() {
  if (key == 'r' || key == 'R') initialize();
}




void draw() {

  image(backgroundLayer, 0, 0);
  //image(backgroundImage, 0, 0);

  if (currentSize > minSize) {
    
    boolean letterFits = randomLetter(currentSize);
    if (!letterFits) {
      currentSize *= shrinkingFactor;
      println(currentSize);
    }
    else {
//      saveFrame("/Users/kylebebak/Desktop/frames/####.jpg");
    }
    // size is only shrunken if a letter couldn't be fit onto the screen,
    //    the program is given a certain number of tries to place a letter
    //    during each call to draw, and if it's successful, the letterSize stays
    //    the same and the function is called with the same letter size in the next
    //    call to draw, otherwise the letter size is decreased so that there is a better
    //    chance it will fit into the drawing in the next call to draw. program will
    //    draw letters in white spce until current size is less than minSize, like a while
    //    condition for draw, then it will move to the second phase of the program,
    //    where it hollows out letters and animates them falling
  } 



  else {
    
//    saveFrame("/Users/kylebebak/Desktop/frames/####.jpg");
    
    if ( dynamicFrameCounter == 0) {
      println("Drawing finished");
      println(drawnLetters.size());
    }
    dynamicFrameCounter++;


    if ( (random(1) > 1 - chanceOfRemoval) && (drawnLetters.size() > 0) ) {
      int index = (int)random(0, drawnLetters.size()-1);
      Letter letter = drawnLetters.get(index);

      letter.eraseStaticAndInitializeDynamic();

      drawnLetters.remove(index);
      fallingLetters.add(letter);
    }


    for (int i = fallingLetters.size() - 1; i >= 0; i--) {
      Letter letter = fallingLetters.get(i);
      if (letter.updateDynamic()) fallingLetters.remove(i);
    }
  }
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
  // transparent background. the brightness has to be set to 1 -- if it is set to 0,
  // the background is not transparent, even if the alpha value is set to 0
  float lH = letterHue - hueRange + (currentSize / initialSize) * hueRange * 2;
  g.fill(color(lH, 1, 1));
  g.textAlign(CENTER, CENTER);
  g.translate(letterSize / 2, letterSize / 2);

  float[] angle = {
    0, 0, random(TWO_PI)
    };
    g.rotate(angle[2]);

  g.scale(letterSize / initialSize);
  //  scale factor makes letter drawn into the PGraphics g progressively smaller 

  g.textFont(font);
  char character;
  if (!japaneseFont) character = (char) int(random(33, 127));
  else character = (char) int(random(33, 109));

  g.text(character, 0, 0);
  //  text(c, x, y);
  g.endDraw();



  PGraphics gMask = createGraphics(intLetterSize, intLetterSize);
  gMask.beginDraw();
  gMask.background(color(0, 0, 0, 1));
  gMask.image(g, 0, 0);
  // the gMask is necessary because get doesn't behave well with the
  // PGraphics g that has the transparent background
  gMask.endDraw();




  for (int tries = numberAttemptsToDrawLetter; tries > 0; tries--) {
    // a certain number of tries is allotted to draw a letter to the canvas
    //    without overlap, if the letter hasn't been drawn by this number of tries
    //    the function finally returns false. it doesn't return false until this number
    //    of tries has been exhausted, and will return true if a character is
    //    successfully drawn any time before this number of tries is exhausted
    int[] pos = { 
      (int)random(width - intLetterSize), (int)random(height - intLetterSize)
      };

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
    for (int dx = 0; dx < intLetterSize && fits; dx++) {
      for (int dy = 0; dy < intLetterSize && fits; dy++) {
        if (brightness(gMask.get(dx, dy)) != 0) {
          if (brightness(get(pos[0] + dx, pos[1] + dy)) > 0 || brightness(backgroundImage.get(pos[0] + dx, pos[1] + dy)) < .5) {

            fits = false;
            // using get on the backgroundLayer slows things down A LOT, not sure why
          }
        }
      }
    }
    if (fits) {
      backgroundLayer.beginDraw();
      backgroundLayer.image(g, pos[0], pos[1]);
      backgroundLayer.endDraw();

      //  LETTER CLASS CONSTRUCTOR    
      /*
  Letter (PFont font, float letterSize, char character, int lifeSpan, 
       float[] pos, float[] vel, float[] dvel, float[] angle, float[] omega)
       */

      float[] position = {
        (float)pos[0], (float)pos[1]
      };
      float[] vel = {
        random(-5, 5), random(-5, 5)
        };
      float[] dvel = {
        0, .15
      };
      float[] omega = { 
        random(-.15, .15), random(-.15, .15), random(-.15, .15)
        };

      Letter letter = new Letter(font, letterSize, character, (int)random(125, 175), 
      position, vel, dvel, angle, omega, lH);
      drawnLetters.add(letter);

      return true;
    }
  }
  return false;
}





class Letter {
  // initialSize and font are global variables
  PFont font;
  float letterSize;
  char character;
  int lifeSpan, age;
  float[] pos, vel, dvel, angle, omega;
  PGraphics staticLetterImage, dynamicLetterImage;
  float bounceDamping = .75;
  float transparency;
  float letterHue;

  Letter (PFont font, float letterSize, char character, int lifeSpan, 
  float[] pos, float[] vel, float[] dvel, float[] angle, float[] omega, float letterHue) {
    this.font = font;
    this.letterSize = letterSize;
    this.character = character;
    this.lifeSpan = lifeSpan;
    this.age = 0;
    this.pos = pos;
    this.vel = vel;
    this.dvel = dvel;
    this.angle = angle;
    this.omega = omega;
    this.letterHue = letterHue;
  }


  void eraseStaticAndInitializeDynamic() {

    staticLetterImage = createGraphics((int)letterSize, (int)letterSize);
    dynamicLetterImage = createGraphics((int)letterSize, (int)letterSize, P3D);
    // initialize dynamicLetterImage once here, instead of
    //   reinitializing it every frame later, this slows the program down a lot

    staticLetterImage.beginDraw();
    staticLetterImage.background(color(0, 0, 1, 0));
    // this color is rgb(255), "WHITE", but in HSB format. the alpha value
    // of the background is zero, so that this PGraphics gets drawn into the canvas 
    // like it was a sprite, with the letter totally opaque on top of the totally
    // transparent background
    staticLetterImage.fill(color(0, 0, 0));
    staticLetterImage.textAlign(CENTER, CENTER);
    staticLetterImage.translate(letterSize / 2, letterSize / 2);
    staticLetterImage.rotate(angle[2]);
    staticLetterImage.scale(letterSize / initialSize);
    //  scale factor makes letter drawn into the PGraphics sLI progressively smaller 
    staticLetterImage.textFont(font);
    staticLetterImage.text(character, 0, 0);
    //  text(c, x, y);
    staticLetterImage.endDraw();

    backgroundLayer.beginDraw();
    backgroundLayer.image(staticLetterImage, (int)pos[0], (int)pos[1]);
    backgroundLayer.endDraw();
  }


  boolean updateDynamic() {
    boolean dead = false;
    age++;
    transparency = (float)age / (float)lifeSpan;
    transparency = sq(sq(transparency));

    vel[0] += dvel[0];
    vel[1] += dvel[1];
    pos[0] += vel[0];
    pos[1] += vel[1];
    angle[0] += omega[0];
    angle[1] += omega[1];
    angle[2] += omega[2];
    if (pos[1] > height) {
      pos[1] = 2 * height - pos[1];
      vel[1] = -vel[1] * bounceDamping;
    }

    dynamicLetterImage.beginDraw();
    dynamicLetterImage.background(color(0, 0, 1, 0));
    dynamicLetterImage.fill(color(letterHue, 1, 1, max(.01, 1 - transparency)));
    dynamicLetterImage.textAlign(CENTER, CENTER);
    dynamicLetterImage.translate(letterSize / 2, letterSize / 2);
    dynamicLetterImage.rotateX(angle[0]);
    //dynamicLetterImage.rotateY(angle[1]);
    dynamicLetterImage.rotateZ(angle[2]);
    dynamicLetterImage.scale(letterSize / initialSize);
    //  scale factor makes letter drawn into the PGraphics dLI progressively smaller 
    dynamicLetterImage.textFont(font);
    dynamicLetterImage.text(character, 0, 0);
    //  text(c, x, y);
    dynamicLetterImage.endDraw();

    image(dynamicLetterImage, (int)pos[0], (int)pos[1]);

    if (age >= lifeSpan) dead = true;
    return dead;
  }
}

