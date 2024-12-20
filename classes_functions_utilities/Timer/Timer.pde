public class Timer {
  private int startTime = 0, totalElapsed = 0;
  private boolean running = false;
  private int timeLeft = 0;


  /****************************
   * for a countdown timer, constructor sets time left in milliseconds
   ****************************/
  public Timer(int timeLeft) {
    this.timeLeft = timeLeft;
  }

  /************ for countdown timer *************/
  public void addTime(int time) {
    timeLeft += time;
  }

  public void subtractTime(int time) {
    timeLeft -= time;
  }

  public boolean timeIsUp() {
    return (remainingTime() < 0);
  }

  /************ for count up timer *************/
  public void addTimeCountUp(int time) {
    startTime -= time;
  }

  public void subtractTimeCountUp(int time) {
    startTime += time;
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
   * get a string represenation of an arbitrary time, elapsed time, or remaining time.
   * Accurate from hours down to units of .01 seconds
   ****************************/
  public String timeToStringHours(int time) {

    return nf(hour(time), 1) + ":" + nf(minute(time), 2) + ":" + nf(second(time), 2) + 
      "." + Integer.toString( thousandths(time) / 10 );
  }

  public String elapsedTimeToStringHours() {
    return timeToStringHours(elapsedTime());
  }

  public String remainingTimeToStringHours() {
    if (remainingTime() < 0)
      return "-" + timeToStringHours(-remainingTime());

    return timeToStringHours(remainingTime());
  }


  // Accurate from 1 digit of minutes down to units of .01 seconds
  public String timeToStringMinutes(int time) {

    return nf(minute(time), 1) + ":" + nf(second(time), 2) + 
      "." + Integer.toString( thousandths(time) / 10 );
  }

  public String elapsedTimeToStringMinutes() {
    return timeToStringMinutes(elapsedTime());
  }

  public String remainingTimeToStringMinutes() {
    if (remainingTime() < 0)
      return "-" + timeToStringMinutes(-remainingTime());

    return timeToStringMinutes(remainingTime());
  }
}

