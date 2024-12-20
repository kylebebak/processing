PFont font;
Slider2D bubbles; //2D slider for controlling bubble radius and popping rate
Slider2D drifts; //2D slider controlling radial and vertical drift
Palette palette; //palette for changing stroke color for bubble edges
ToggleButton toggleColor;

float SX, SY;
//source location, as a float or as a site number
float rmax, rmax1, rmax2;
//max distance from source to any position on screen, calculated in setup

ArrayList<Float> bubblesx;
ArrayList<Float> bubblesy;
/*tell ArrayList that it's going to hold floats so i don't have to
 cast each element going in and out of the list. x and y coordinates of each bubble*/
ArrayList<Float> radii;
//bubble radii
float rad; //min radius around which bubbles are chosen

float yDrift=200;
float yDr;
float radialDrift=250;

int regions=50;
float dropOffExponent=1.5;
/*number of regions where bubble generation falls off as it gets away from source,
 and also exponential power according to which bubble generation
 falls off as a function of region */
int[] bnew=new int[regions];

int bdead;
float popFrac;
int born=40;

float br, btheta;
float bx, by, xt, yt, radt;
float thetaMin, thetaMax;
//temporary site indices
float dx, dy, r;

float power=-5;
float randmax, randmin;

int neighbors;
//number of neighbors of a given site, another temporary variable

boolean skip;

color bubbleColor=color(0, 255, 255);
color backgroundColor=color(0);






void setup() {
  size(600, 700);
  smooth();
  frameRate(25);
  font=createFont("EurostileBold", 48);

  SX=width/2;
  SY=0; //coordinates of "source" of bubbles

  bubblesx = new ArrayList();
  bubblesy = new ArrayList();
  radii = new ArrayList();

  bubbles=new Slider2D(width-150, height-110, 75, 75, 
  width-150, height-40, 25, 10, 
  2, 20, 0, .2, 7, .0175, 1, 4, "Rad, Pop-rate");

  drifts=new Slider2D(width-150, height-110, 75, 75, 
  width-110, height-40, 25, 10, 
  50, 500, 0, 400, 250, 200, 1, 1, "Radial, Vertical");

  palette=new Palette(80, height-110, 70, 70, 
  80, height-110, 10, 25);

  toggleColor=new ToggleButton(70, height-110, 10, 30, "", false);
}



void draw() {
  

  /*slider, button and palette are drawn at the end,
   because background() isn't called until the end*/

  rad=bubbles.returnvalues()[0];
  popFrac=bubbles.returnvalues()[1];
  radialDrift=drifts.returnvalues()[0];
  yDrift=drifts.returnvalues()[1];



  //kill bubbles with r
  if (keyPressed) {
    if (key == 'r' || key == 'R' ) {
      for (int i=0; i < bubblesx.size(); i++) {
        /*normally one loops backward when removing elements from an array list,
         but looping forward is cool because it misses some and doesn't delete everything at once*/
        bubblesx.remove(i);
        bubblesy.remove(i);
        radii.remove(i);
      }
    }
    if (key == 'c' || key == 'C') {
      bubbleColor=color(0, 255, 255);
      backgroundColor=color(0);
    }
  }
  //move source by dragging mouse
  if (mousePressed && !bubbles.dropdown && !drifts.dropdown
    && !palette.dropdown && !toggleColor.over) {
    SX=constrain(mouseX, 0, width);
    SY=constrain(mouseY, 0, height);
  }

  /*ugly else/if structure for controlling how drift, thetaMin, and thetaMax
   are chosen for bubble generation and drift depending on location of source*/
  if ( SX < width/6 && SY < height/6 ) {
    yDr=yDrift;
    thetaMin=0;
    thetaMax=PI/2;
  } 
  else if ( SX > width/6 && SX < 5*width/6 && SY < height/6 ) {
    yDr=yDrift;
    thetaMin=0;
    thetaMax=PI;
  } 
  else if ( SX > 5*width/6 && SY < height/6 ) {
    yDr=yDrift;
    thetaMin=PI/2;
    thetaMax=PI;
  } 
  else if ( SX < width/6 && SY > height/6 && SY < 5*height/6 ) {
    yDr=0;
    thetaMin=-PI/2;
    thetaMax=PI/2;
  } 
  else if ( SX > width/6 && SX < 5*width/6 && SY > height/6 && SY < 5*height/6 ) {
    yDr=0;
    thetaMin=0;
    thetaMax=2*PI;
  } 
  else if ( SX > 5*width/6 && SY > height/6 && SY < 5*height/6 ) {
    yDr=0;
    thetaMin=PI/2;
    thetaMax=3*PI/2;
  }
  else if ( SX < width/6 && SY > 5*height/6 ) {
    yDr=-yDrift;
    thetaMin=3*PI/2;
    thetaMax=2*PI;
  } 
  else if ( SX > width/6 && SX < 5*width/6 && SY > 5*height/6 ) {
    yDr=-yDrift;
    thetaMin=PI;
    thetaMax=2*PI;
  } 
  else if ( SX > 5*width/6 && SY > 5*height/6 ) {
    yDr=-yDrift;
    thetaMin=PI;
    thetaMax=3*PI/2;
  }






  /*instantiate new bubbles, less likely to appear far away from source*/
  randmax=pow(10*rad, power+1);
  randmin=pow(rad, power+1);

  for (int j=0; j<regions; j++) bnew[j]=round( random(born-born/2, born+born/2) )
    /  round(pow((j+1), dropOffExponent));

  for (int j=0; j<regions; j++) {
    for (int i=0; i<bnew[j]; i++) {

      rmax1=max( dist(SX, SY, 0, 0), dist(SX, SY, width, 0) );
      rmax2=max( dist(SX, SY, 0, height), dist(SX, SY, width, height) );
      rmax=max(rmax1, rmax2);

      br=random( rmax * (float)j / (float)regions, rmax * ((float)j + 1) / (float)regions );
      btheta=random(thetaMin, thetaMax);
      bx= SX + ( br * cos(btheta) );
      by= SY + ( br * sin(btheta) );

      /*
      neighbors=0;
       if ( (get( round(bx+1.5*rad), round(by) ) & 0xFF) != 0 ) neighbors++;
       if ( (get( round(bx-1.5*rad), round(by) ) & 0xFF) != 0 ) neighbors++;
       if ( (get( round(bx), round(by+1.5*rad) ) & 0xFF) != 0 ) neighbors++;
       if ( (get( round(bx), round(by-1.5*rad) ) & 0xFF) != 0 ) neighbors++;
       
       if ( random(0, 1) * (neighbors + 1) / 8 > (1/10) ) {
       bubblesx.add(bx);
       bubblesy.add(by);
       }
       */
      bubblesx.add(bx);
      bubblesy.add(by);
      radii.add( pow(random(randmax, randmin), 1 / (power+1) ) );
    }
  }





  /*pop bubbles, if bubbles have neighbors they are more likely to survive popping.
   as many as 8 neighbors are considered here for popping probabilities*/
  bdead= round( popFrac * bubblesx.size() );
  bdead= round( random(bdead-bdead/2, bdead+bdead/2) );

  for (int i=0; i<bdead; i++) {

    if ( bubblesx.size() != 0 ) {
      int index=(int)random( 0, bubblesx.size() );
      xt=bubblesx.get(index);
      yt=bubblesy.get(index);
      radt=radii.get(index);

      neighbors=0;
      if ( (get( round(xt+radt+.5*rad), round(yt) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt-radt-.5*rad), round(yt) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt), round(yt+radt+.5*rad) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt), round(yt-radt-.5*rad) ) & 0xFF) != 0 ) neighbors++;

      if ( (get( round(xt+radt+.5*rad), round(yt+radt+.5*rad) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt-radt-.5*rad), round(yt+radt+.5*rad) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt+radt+.5*rad), round(yt-radt-.5*rad) ) & 0xFF) != 0 ) neighbors++;
      if ( (get( round(xt-radt-.5*rad), round(yt-radt-.5*rad) ) & 0xFF) != 0 ) neighbors++;

      if ( random(0, 1) * (neighbors+1) < 1.5 ) {
        bubblesx.remove(index);
        bubblesy.remove(index);
        radii.remove(index);
      }
    }
  }


  /*draw all bubbles (without outlines) for calculating motion dynamics, move them and
   then redraw them with outlines for viewer. outlines screw up motion calculations*/
  background(0);
  noStroke();
  fill(0, 0, 255, 2);
  //FIX HERE
  for (int i=0; i < bubblesx.size(); i++) {
    radt=radii.get(i);
    ellipse(bubblesx.get(i), bubblesy.get(i), 
    2*radt, 2*radt);
  }
  
  for (int i = bubblesx.size()-1; i >= 0; i--) {
    xt=bubblesx.get(i); //get these here once and use them for all following calculations
    yt=bubblesy.get(i);
    radt=radii.get(i);

    /*calculate bubble drift, radial and vertical, both inversely proportional
     to distance from source. there is randomness bubble movement*/
    r = dist( SX, SY, xt, yt );
    dx = radialDrift * ( (xt-SX) / r ) / r;    //     cosø / r
    dx = random(dx-dx/6, dx+dx/6);
    dy = yDr / r + radialDrift * ( (yt-SY) / r ) / r;
    dy = random(dy-dy/6, dy+dy/6);

    /*if there are more than 3 bubbles piled on top of each other pop the bubble
     and move on to the next*/
    skip=false;
    float blueComponent = get( round(xt), round(yt) ) & 0xFF;
    if (blueComponent >= 5) {
      /*FIX HERE, this method no longer works in processing
      2.0, i have no idea why*/
      bubblesx.remove(i);
      bubblesy.remove(i);
      radii.remove(i);
      skip=true;
      println(blueComponent);
    }


    if (!skip) {
      /*have bubbles stay close to neighbors, bigger number in front of rad means
       bigger attraction range. floor and ceil instead of round helps with a strange
       glitch that causes the bubbles to drift preferentially towards the left*/
      if ( (get( floor(xt-radt-1.75*rad), round(yt) ) & 0xFF) >= 2 ) dx-=.1*rad;
      if ( (get( ceil(xt+radt+1.75*rad), round(yt) ) & 0xFF) >= 2 ) dx+=.1*rad;
      if ( (get( round(xt), floor(yt-radt-1.75*rad) ) & 0xFF) >= 2 ) dy-=.1*rad;
      if ( (get( round(xt), ceil(yt+radt+1.75*rad) ) & 0xFF) >= 2 ) dy+=.1*rad;

      /*have bubbles that are overlapping spread apart, number in front of rad
       should be less than 1*/
      int numrad=floor(radt/rad);
      for (int k=0; k<numrad; k++) {
        if ( (get( ceil(xt+(k+1)*.8*rad), round(yt) ) & 0xFF) >= 3 ) dx-=.2*rad;
        if ( (get( floor(xt-(k+1)*.8*rad), round(yt) ) & 0xFF) >= 3 ) dx+=.2*rad;
        if ( (get( round(xt), ceil(yt+(k+1)*.8*rad) ) & 0xFF) >= 3 ) dy-=.2*rad;
        if ( (get( round(xt), floor(yt-(k+1)*.8*rad) ) & 0xFF) >= 3 ) dy+=.2*rad;
      }
      if (numrad>=2) for (int k=0; k<numrad-1; k++) {
        if ( (get( ceil(xt+(k+1)*.8*rad), ceil(yt+(k+1)*.8*rad) ) & 0xFF) >= 3 ) {
          dx-=.2*rad;
          dy-=.2*rad;
        }
        if ( (get( floor(xt-(k+1)*.8*rad), ceil(yt+(k+1)*.8*rad) ) & 0xFF) >= 3 ) {
          dx+=.2*rad;
          dy-=.2*rad;
        }
        if ( (get( ceil(xt+(k+1)*.8*rad), floor(yt-(k+1)*.8*rad) ) & 0xFF) >= 3 ) {
          dx-=.2*rad;
          dy+=.2*rad;
        }
        if ( (get( floor(xt-(k+1)*.8*rad), floor(yt-(k+1)*.8*rad) ) & 0xFF) >= 3 ) {
          dx+=.2*rad;
          dy+=.2*rad;
        }
      }
    }
    if (i < bubblesx.size() ) {
      bubblesx.set(i, xt+dx);
      bubblesy.set(i, yt+dy);
    }
  }


  //do all drawing at the end, including slider
  if (palette.toggleMove) {
    if (!toggleColor.toggle) bubbleColor=palette.returnColor();
    if (toggleColor.toggle) backgroundColor=palette.returnColor();
  }

  background(backgroundColor); //background below is graded from black to blue

  /*for (int i=1; i<=height; i++) {
   stroke(0, 0, i*150/height);
   line(0, i, width, i);
   }*/

  if (!drifts.dropdown) {
    bubbles.update();
    bubbles.display(); //display the sliders underneath the bubbles
  }
  if (!bubbles.dropdown) {
    drifts.update();
    drifts.display();
  }

  palette.display();
  palette.update();
  toggleColor.display();
  toggleColor.update();

  //draw the bubbles
  stroke(bubbleColor);
  fill(0, 5, 5, 100);
  for (int i=0; i < bubblesx.size(); i++) {
    radt=radii.get(i);
    ellipse(bubblesx.get(i), bubblesy.get(i), 2*radt, 2*radt);
  }

  //display text with number of bubbles
  textFont(font, 12);
  fill(255);
  text( bubblesx.size(), width-150, height-20 );
  //text("current frame rate: " + round(frameRate), 5, height - 10);
}



void keyPressed() {
  bubbles.arrowKeysPressed();
  drifts.arrowKeysPressed();
}

void keyReleased() {
  bubbles.arrowKeysReleased();
  drifts.arrowKeysReleased();
  palette.changePalette();
}

void mouseReleased() {
  toggleColor.mouseButtonReleased();
}

