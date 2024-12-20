public class Point { 
    private final float x;   // Cartesian
    private final float y;   // coordinates
   
    // create and initialize a point with given (x, y)
    public Point(float x, float y) {
        this.x = x;
        this.y = y;
    }

    // return Euclidean distance between invoking point this and that
    public float distanceTo(Point that) {
        float dx = this.x - that.x;
        float dy = this.y - that.y;
        return sqrt(dx * dx + dy * dy);
    }

    // draw this point using standard draw
    public void drawPoint() {
        point(x, y);
    }

    // draw the line from the invoking point this to that using standard draw
    public void drawTo(Point that) {
        line(this.x, this.y, that.x, that.y);
    }

    // return string representation of this point
    public String toString() {
        return "(" + x + ", " + y + ")";
    }
}

