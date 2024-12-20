/**
 * Tour is implemented with a linked list, which makes insertion into the middle
 * of a tour a bit faster. This is key for the smallest increase and nearest
 * neighbor heuristics implemented below, both of which are greedy heuristics.
 * <p>
 * Smallest increase is much more effective than nearest neighbor, and results
 * in much fewer places where the tour crosses itself. <b>It is trivial to show
 * that the length of the tour can be decreased in every place where the tour
 * crosses itself, but uncrossing the tour in these places is not trivial.</b>
 * <p>
 * Finding where to insert a new point into the tour requires stepping through
 * the entire tour, so the runtime is quadratic in the number of points on the
 * tour.
 */
public class Tour {

  private Node first;
  private int N;

  private class Node {
    private Point p;
    private Node next;

    public Node(Point p) {
      // create one Node
      this.p = p;
      this.next = null;
    }

    public Node(Node that) {
      this.p = that.p;
      this.next = that.next;
    }
  }

  /**
   * Create an empty tour
   */
  public Tour() {
    N = 0;
  }

  /**
   * Create a tour from an array of points
   */
  public Tour(Point[] points, boolean smallest) {
    N = 0;

    if (smallest)
      for (Point p : points)
        this.insertSmallest(p);
    else
      for (Point p : points)
        this.insertNearest(p);
  }

  /**
   * Print the tour to standard output
   */
  public void showTour() {
    if (N < 1)
      return;

    StdOut.println(first.p.toString());
    for (Node n = first.next; n != first; n = n.next)
      StdOut.println(n.p.toString());
    StdOut.println(first.p.toString());
  }

  /**
   * Draw the tour
   */
  public void drawTour() {
    if (N < 2)
      return;

    first.p.drawTo(first.next.p);
    for (Node n = first.next; n != first; n = n.next)
      n.p.drawTo(n.next.p);
  }

  /**
   * Return the total distance of the tour
   */
  public float distance() {

    if (N < 2)
      return 0;

    float d = first.p.distanceTo(first.next.p);
    if (N == 2)
      return 2.0 * d;

    for (Node n = first.next; n != first; n = n.next)
      d += n.p.distanceTo(n.next.p);

    return d;
  }

  /**
   * Smallest increase heuristic: Read in the next point, and add it to the
   * current tour after the point where it results in the least possible
   * increase in the tour length. (If there is more than one point, insert it
   * after the first such point you discover.)
   */
  public void insertSmallest(Point p) {
    if (N < 2) {
      initialize(p);
      return;
    }

    float dd = first.p.distanceTo(p) + p.distanceTo(first.next.p)
      - first.p.distanceTo(first.next.p);
    // dd is the increase in path distance caused by inserting p
    float ndd;
    Node n = first.next;
    Node insertAfter = first;

    // find the node after which inserting point p causes the smallest
    // increase in distance
    while (n != first) {
      ndd = n.p.distanceTo(p) + p.distanceTo(n.next.p)
        - n.p.distanceTo(n.next.p);
      if (ndd < dd) {
        dd = ndd;
        insertAfter = n;
      }
      n = n.next;
    }

    // make a new node with p and insert it
    Node insertBefore = insertAfter.next;
    insertAfter.next = new Node(p);
    insertAfter.next.next = insertBefore;
    N++;
  }

  /**
   * Nearest neighbor heuristic: Read in the next point, and add it to the
   * current tour after the point to which it is closest. (If there is more
   * than one point to which it is closest, insert it after the first such
   * point you discover.)
   */
  public void insertNearest(Point p) {
    if (N < 2) {
      initialize(p);
      return;
    }

    float nd = first.p.distanceTo(p);
    // nd is the nearest distance from p to any of the points in the path
    float nnd;
    Node n = first.next;
    Node insertAfter = first;

    // find the node to which p is closest
    while (n != first) {
      nnd = n.p.distanceTo(p);
      if (nnd < nd) {
        nd = nnd;
        insertAfter = n;
      }
      n = n.next;
    }

    // make a new node with p and insert it
    Node insertBefore = insertAfter.next;
    insertAfter.next = new Node(p);
    insertAfter.next.next = insertBefore;
    N++;
  }

  /**
   * Helper function for when N = 0 or N = 1, putting in first two points
   */
  private void initialize(Point p) {
    if (N == 0) {
      first = new Node(p);
      N++;
      return;
    }

    if (N == 1) {
      first.next = new Node(p);
      first.next.next = first;
      N++;
      return;
    }
  }

  public Point[] getTourPoints() {
    Point[] points = new Point[N];
    if (N == 0) return points;

    points[0] = first.p;
    if (N == 1) return points;

    int index = 1;
    for (Node n = first.next; n != first; n = n.next)
      points[index++] = n.p;

    return points;
  }
}

