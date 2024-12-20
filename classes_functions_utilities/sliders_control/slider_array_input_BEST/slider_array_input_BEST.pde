Slider check, check2;

void setup() {
  size(500, 500);

  String[] a = {
    "Easy", "Medium", "Hard"
  };

  Integer[] b = {
    3, 4, 5, 6, 8, 9, 10
  };

  check = new Slider(50, 50, 200, 40, a, 2, "Difficulty");
  check2 = new Slider(50, 300, 200, 40, b, 3, "Images per card");
}

void draw() {
  background(0);
  check.update();
  check.display();

  check2.update();
  check2.display();

  //  println(check.getValue().toString());
}

public class Slider<Item> {
  int topcornerx, topcornery; // location of slider
  int dimx, dimy, dim; // width and height, slider horizontal if dim bigger
  float xbutton, ybutton; // value returned by slider, button position
  int ticks, tickval;
  Object[] values;

  float tickspacing, tickspacingclick; // computing these variables in setup makes slider run faster
  float minxpos, maxxpos, minypos, maxypos, buttonsize, buttonsizex, buttonsizey;
  color colorbox, coloractive, colorbutton, textcolor;
  boolean toggleMove, over, lockout; // lockout prevents 2 sliders from being activated at once
  PFont sliderfont; // default color is white, can be changed by calling changeTextColor
  String slidername;

  Slider (int topcornerx, int topcornery, int dimx, int dimy, 
  Item[] values, int initialIndex, String slidername) {
    this.topcornerx = topcornerx; 
    this.topcornery = topcornery;
    this.dimx = dimx; 
    this.dimy = dimy;
    this.slidername = slidername;

    this.values = new Object[values.length];
    for (int i = 0; i < values.length; i++) 
      this.values[i] = values[i];
    ticks = values.length;
    tickval = constrain(initialIndex, 0, values.length - 1);

    buttonsize = 12;

    dim = max(dimx, dimy);

    if (dimx >= dimy) {
      buttonsizex = buttonsize;
      buttonsizey = dimy;
      minxpos = topcornerx - buttonsizex / 2.0;
      maxxpos = topcornerx + dimx + buttonsizex / 2.0;
      minypos = topcornery; 
      maxypos = topcornery + buttonsizey;
      xbutton = topcornerx + round( dim * tickval / (float) values.length);
      ybutton = topcornery + buttonsizey / 2.0;
    } 
    else {
      buttonsizex = dimx;
      buttonsizey = buttonsize;
      minxpos = topcornerx; 
      maxxpos = topcornerx + buttonsizex;
      minypos = topcornery - buttonsizey / 2.0; 
      maxypos = topcornery + dimy + buttonsizey / 2.0;
      xbutton = topcornerx + buttonsizex / 2.0;
      ybutton = topcornery + round( dim * tickval / (float) values.length);
    }

    colorbox = #0093CB; 
    coloractive = #00FFFD; 
    colorbutton = #FFFFFF;
    textcolor = (255);
    sliderfont = createFont("Helvetica", 48);

    tickspacing = dim / (float) (ticks - 1);
    tickspacingclick = dim / (float) ticks;
    if (dimx >= dimy)
      xbutton = topcornerx + tickval * tickspacing;
    else
      ybutton = topcornery + tickval * tickspacing;
  }

  void update() {
    if (mouseX > minxpos && mouseX < maxxpos && 
      mouseY > minypos && mouseY < maxypos) over=true;
    else over = false;

    if (over && mousePressed && !lockout) toggleMove = true;

    if (mousePressed && !over && toggleMove==false) lockout = true;

    if (mousePressed == false) {
      toggleMove = false;
      lockout = false;
    }

    if (toggleMove) {

      if (dimx >= dimy) {
        tickval = constrain(floor((mouseX - topcornerx) / tickspacingclick), 0, ticks - 1);
        xbutton = topcornerx + tickval * tickspacing;
      }
      else {
        tickval = constrain(floor((mouseY - topcornery) / tickspacingclick), 0, ticks - 1);
        ybutton = topcornery + tickval * tickspacing;
      }
    }
  }

  void display() {

    stroke(0);
    rectMode(CORNER);

    if ((over || toggleMove) && !lockout) fill(coloractive);
    else fill(colorbox);

    if (dimx >= dimy) rect(topcornerx - buttonsizex / 2, topcornery, dim + buttonsizex, buttonsizey);
    else rect(topcornerx, topcornery - buttonsizey / 2, buttonsizex, dim + buttonsizey);

    rectMode(CENTER);
    fill(colorbutton, 185);
    rect(xbutton, ybutton, buttonsizex, buttonsizey);

    textFont(sliderfont, 12);
    fill(textcolor);
    text(slidername + "  :  " + values[tickval].toString(), 
    minxpos, minypos - 2);
  }

  void changeTextColor(color c) {
    textcolor = c;
  }

  void changeSliderColor(color cbox, color cactive, color cbutton) {
    colorbox = cbox; 
    coloractive = cactive; 
    colorbutton = cbutton;
  }

  Item getValue() {
    return (Item) values[tickval];
  }
}
