import java.awt.event.*; // for mouse wheel listener

public class ExternalClass {
  PApplet app;
  public float mx, my;

  ExternalClass(PApplet papp) {
    app = papp;
    app.registerMouseEvent(this);
    app.registerKeyEvent(this);
    app.registerDraw(this);

    /* app.frame.addMouseWheelListener( 
     i read online that the mouse wheel listener had to be added
     to the frame but it doesn't look like that's necessary */
    app.addMouseWheelListener(
    new MouseWheelListener() {
      void mouseWheelMoved(MouseWheelEvent mwe) {
        println(mwe.getWheelRotation());
      }
    }
    ); //an abstract mouse wheel listener class instance argument
  }







  public void draw() {
    //    background(0);
    //    rect(random(width), random(height), 20, 20);

    /* this draw event is optional, it allows an external class to draw
     something on the main canvas. i could also accomplish this by giving
     the class a void display() method, which makes more sense in my opinion
     because it allows me to control _when_ the external class draws things
     (like drawing itself--if i have it draw itself within this draw event here
     it could, for example, draw itself before i call background(0)
     in the main sketch and not be visible!) */
  }



  public void mouseEvent(MouseEvent me) {
    //    println("mouseEvent: " + me);
    /* this will print out the mouseEvent object, it has lots of info associated with it */
    mx = me.getX();
    my = me.getY();

    if (me.getClickCount() == 2) background(0);
    if (me.getButton() == me.BUTTON3) println("mouse was right clicked");

    int id = me.getID();
    if (id == me.MOUSE_PRESSED) {

      println("mouse was pressed at " + mx + ", " + my);
    }

    if (id == me.MOUSE_RELEASED) {
      println("mouse was released at " + mx + ", " + my);
    }

    if (id == me.MOUSE_DRAGGED) {
      stroke(255);
      line(pmouseX, pmouseY, mouseX, mouseY);
    }
  }


  public void keyEvent(KeyEvent ke) {
    int kc = ke.getKeyCode();
    int id = ke.getID();

    if (id == ke.KEY_TYPED) println(ke.getKeyChar() + " was typed");

    if (id == ke.KEY_PRESSED) if (kc == ke.VK_SHIFT) println("shift was pressed");

    if (id == ke.KEY_RELEASED) if (kc == ke.VK_SHIFT) println("shift was released");
  }
}

