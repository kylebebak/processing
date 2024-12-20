class StopWatchTimer {
  private int startTime = 0, totalElapsed = 0;
  private boolean running = false;

  void start() {
    if (running) 
      return;

    startTime = millis();
    running = true;
  }

  void stop() {
    if (!running)
      return;

    totalElapsed += (millis() - startTime);
    running = false;
  }

  void reset() {
    totalElapsed = 0;

    if (running) 
      startTime = millis();
    else
      startTime = 0;
  }


  int getElapsedTime() {
    if (running) 
      return (millis() - startTime + totalElapsed);
    else 
      return (totalElapsed);
  }

  boolean isRunning() {
    return running;
  }



  int thousandths() {
    return (getElapsedTime() % 1000);
  }

  int second() {
    return (getElapsedTime() / 1000) % 60;
  }

  int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }

  int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }

  String timeToString() {
    String time = nf(hour(), 1) + ":" + nf(minute(), 2) + ":" 
      + nf(second(), 2) + ".";
    int t = thousandths();
    if (t < 100) 
      time += "0";
    else 
      time += Integer.toString(t / 100);
    return time;
  }
}

