import java.awt.event.*; // for mouse wheel listener

public class ExternalClass {
  PApplet app;
  public float mx, my;

  ExternalClass(final PApplet papp) {
    app = papp;
    app.registerMethod("mouseEvent", this);
    app.registerMethod("keyEvent", this);
    
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


  public void mouseEvent(processing.event.MouseEvent me) {

    mx = me.getX();
    my = me.getY();
    println("mousePosition: " + mx + ", " + my);
  }

  public void keyEvent(processing.event.KeyEvent ke) {
    int kc = ke.getKeyCode();
    println(kc);
  }

  /* public modifiers are necessary to register events in external classes */
  /* also, if i'm using registerMethod instead of registerKeyEvent and
   registerMouseEvent then these events must be of the types processing.event.MouseEvent
   and processing.event.KeyEvent, otherwise processing thinks that you're
   trying to register a java MouseEvent or KeyEvent, objects whic can't be registered with
   the new processing method "registerMethod"*/
}

