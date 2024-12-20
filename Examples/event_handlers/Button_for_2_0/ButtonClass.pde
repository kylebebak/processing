/**
 *
 * @author Martin Prout
 */
public class Button {
    int x;
    int y;
    int w;
    int h;
    boolean pressed = false;
    boolean clicked = false;
    /**
     *
     */
    PApplet applet;
    /**
     *
     * @param outer
     * @param x coordinate 1st point
     * @param y coordinate 2nd point
     */
    public Button(PApplet outer, int x, int y) {
        applet = outer;
        applet.registerMethod("mouseEvent", this);
        applet.registerMethod("keyEvent", this);
        this.x = x;
        this.y = y;
    }
    /**
     * Set width and height of selectable rectangle
     *
     * @param width
     * @param height
     */
    public void setSize(int width, int height) {
        this.w = width;
        this.h = height;
    }
    /**
     * determine whether point(mx, my) is over rectangle
     *
     * @param mx
     * @param my
     * @return
     */
    public boolean overRect(int mx, int my) {
        if (mx >= this.x && my >= this.y && mx <= this.x + this.w && my <= this.y + this.h) {
            return true;
        } else {
            return false;
        }
    }
    /**
     * Mouse events to register
     *
     * @param e
     */
    public void mouseEvent(processing.event.MouseEvent e) {
        int mx = e.getX();
        int my = e.getY();
        println("something done with mouse");
        switch (e.getAction()) {
            case processing.event.MouseEvent.PRESSED:
                pressed = overRect(mx, my); // only controls graphic
                break;
            case processing.event.MouseEvent.CLICKED:
                if (clicked == false) // idempotent
                {
                    clicked = overRect(mx, my);
                }
                break;
        }
    }
    /**
     * Key events to register, in case GUI doesn't display eg with peasycam
     *
     * @param e
     */
    public void keyEvent(processing.event.KeyEvent e) {
        if (processing.event.MouseEvent.RELEASED == e.getAction()) {
            switch (e.getKey()) {
                case 'r':
                case 'R':
                    if (clicked == false) // idempotent
                    {
                        pressed = true;
                        clicked = true;
                    }
                    break;
            }
        }
    }
}

