//a test sketch to get zoom to work

//scale values for mouse and keys, translate values
float sc=1;
float mX=0, mY=0;
float tx=0, ty=0, txm=0, tym=0, txmr=0, tymr=0, ttx=0, tty=0;
float easing=.075;

void setup() {
  size(500, 500);
}

void draw() {

  background(0);

  if (keyPressed) {
    //= and - to zoom in and out on center of screen
    if (key == '1') sc *= 1/1.05;
    if (key == '2') sc *= 1.05;

    if  (key == 's') {
      float scroll=dist(mouseX, mouseY, pmouseX, pmouseY) / 50;
      if (scroll<.75) scroll=.75;
      tx += (mouseX - pmouseX) * scroll / sc;
      ty += (mouseY - pmouseY) * scroll / sc;
    }

    //r to reset all zooms and translates
    if (key == 'r') {
      sc=1;
      tx=0;
      ty=0;
      txm=0;
      tym=0;
      txmr=0;
      tymr=0;
    }
  }

  translate(width/2, height/2);
  scale(sc);
  translate(-width/2, -height/2);
  /*if the following code is removed (and txmr and tymr are removed below) 
   then double-click will zoom in on and center whatever
   the mouse is pointing at*/
  translate(txmr, tymr);

  //mouseDragged translation
  ttx+=(tx - ttx) * easing;
  tty+=(ty - tty) * easing;
  translate(ttx, tty);
  
  //double-click translation
  translate(txm, tym);

  //some test rectangles
  fill(255);
  rect(225, 225, 50, 50);

  fill(255, 0, 0);
  rect(300, 300, 20, 20);

  fill(255, 255, 0);
  rect(50, 50, 10, 10);
}

//getting mouse coordinates for debugging just type c
void keyReleased() {
  if (key == 'c') {
    println();
    println("X = " + mouseX);
    println("Y = " + mouseY);
  }
}


void mousePressed() {

  // mouseEvent variable contains the current event information
  if (mouseEvent.getClickCount()==2) {
    mX=constrain(mouseX, 0, width);
    mY=constrain(mouseY, 0, height);
    txm += ( width/2 - mX) / sc;
    tym += ( height/2 - mY ) / sc;
    sc *= 2;
    /*if the following code is removed (and the corresponding translate
     is taken out above) then double-click will zoom in on and center 
     whatever the mouse is pointing at*/
    txmr += ( mX - width/2 ) / sc;
    tymr += ( mY - height/2 ) / sc;
  }
  //if (mouseEvent.getButton()==MouseEvent.BUTTON3)
}

void mouseDragged() {
  tx += (mouseX - pmouseX) / sc;
  ty += (mouseY - pmouseY) / sc;
}

