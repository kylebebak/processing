

class LinePath{
  // by quark.
  private Shape3D shape = null;
  private PVector s, d, pos;
  private long sTime, durTime;
  private boolean destReached = false;

  LinePath(Shape3D object, PVector dest, long duration){
    shape = object;
    s = shape.getPosVec();
    d = new PVector(dest.x, dest.y, dest.z);
    sTime = millis();
    durTime = duration;
  }

  public void updatePos(long time){
    if(!destReached){
      float factor = (time - sTime)/(float)(durTime);
      if(factor > 1.0) {
        factor = 1.0;
        destReached = true;
      }
      PVector move = PVector.mult(PVector.sub(d, s), factor);
      pos = PVector.add(s, move);
      // b.moveTo(pos);
      shape.moveTo(pos);
    }
  }

  public void endMove(){
    destReached = true;
  }

} // end of LinePath class

// usage example by quark 

void setup1(){
  //  size(800,800,P3D);
  //
  //  b = new Box(this); // ,50);
  //  b.rotateBy(radians(45),0,radians(45));
  //  // Move the object to a new position over the next 5 seconds
  //  lp = new LinePath(b, new PVector(100,50,-50), 5000);
}

void draw1(){
  //  camera(0,0,300,0,0,0,0,1,0);
  //  background(64);
  //  lp.updatePos(millis());
  //  b.draw();
}


