public class Flash {

  private int start;
  private int len;
  private boolean up;
  private int N;
  private float hue;
  private final float dhue = .01;
  
  private int count;

  public Flash(int start, int len, boolean up, int N, float hue) {
    this.start = start;
    this.len = len;
    this.up = up;
    this.N = N - 1;
    this.hue = hue;

    count = 0;
  }

  public void increment() {
    count++;
    hue += dhue;
    hue = hue % (2 * PI);
  } 

  public int V() {
    if (up) return (start + count) % N;
    else {
      if (start - count >= 0) return start - count;
      else return (N + start - count);
    }
  }

  public int Vnext() {
    int v = V();

    if (up) return (v + 1) % N;
    else {
      if (v == 0) return N - 1;
      else return (v - 1);
    }
  }
  
  public float getHue() {
    return hue;
  }

  public boolean isFinished() {
    return (count >= len);
  }
}

