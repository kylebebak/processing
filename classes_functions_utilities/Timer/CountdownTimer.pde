public class CountdownTimer {
  private int startTime = 0, totalElapsed = 0;
  private boolean running = false;
  private int timeLeft = 0;


  /****************************
   * for a countdown timer, constructor sets time left in milliseconds
   ****************************/
  public CountdownTimer(int timeLeft) {
    this.timeLeft = timeLeft;
  }

  public void addTime(int time) {
    timeLeft += time;
  }

  public void subtractTime(int time) {
    timeLeft -= time;
  }

  public boolean timeIsUp() {
    return (remainingTime() < 0);
  }

  /****************************
   * start timer, stop timer, reset timer
   ****************************/
  public void start() {
    if (running) 
      return;

    startTime = millis();
    running = true;
  }

  public void stop() {
    if (!running)
      return;

    totalElapsed += (millis() - startTime);
    running = false;
  }

  public void reset() {
    totalElapsed = 0;

    if (running) 
      startTime = millis();
    else
      startTime = 0;
  }


  /****************************
   * get elapsed time or remaining time in milliseconds, check whether timer is running
   ****************************/
  public int elapsedTime() {
    if (running) 
      return (millis() - startTime + totalElapsed);
    else 
      return (totalElapsed);
  }

  public int remainingTime() {
    return timeLeft - elapsedTime();
  }

  public boolean isRunning() {
    return running;
  }


  /****************************
   * get different units of an arbitrary time, input in milliseconds
   ****************************/
  public int thousandths(int time) {
    return (time % 1000);
  }

  public int second(int time) {
    return (time / 1000) % 60;
  }

  public int minute(int time) {
    return (time / (1000*60)) % 60;
  }

  public int hour(int time) {
    return (time / (1000*60*60)) % 24;
  }

  /****************************
   * get a string represenation of an arbitray time, elapsed time, or remaining time.
   * Accurate from hours down to units of .1 seconds
   ****************************/
  public String timeToString(int time) {
    String ts = nf(hour(time), 1) + ":" + nf(minute(time), 2) + ":" 
      + nf(second(time), 2) + ".";

    int t = thousandths(time);
    if (t < 100) 
      ts += "0";
    else 
      ts += Integer.toString(t / 100);

    return ts;
  }

  public String elapsedTimeToString() {
    return timeToString(elapsedTime());
  }

  public String remainingTimeToString() {
    if (remainingTime() < 0)
      return "-" + timeToString(-remainingTime());

    return timeToString(remainingTime());
  }
}

