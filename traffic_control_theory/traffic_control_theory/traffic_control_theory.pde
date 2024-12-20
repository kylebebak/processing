/*

 PD for cars interacting with other cars
 error term will be difference between car separation and ideal car separation,
 which will get larger with increased speed
 P term will cause car to accelerate (push the gas down or brake)
 proportional to error term
 D term will cause car to accelerate based on
 rate of change of error term (difference of speeds),
 causing trailing car to try to match speed of leading car
 
 
 there will also be ideal speed that car goes towards 
 in the absence of other cars, how will this play with cars 
 moving in unison with other cars? will there be another 
 controller operating independently, telling the car to reach this speed?
 maybe it could just be a P controller, 
 acceleration proportional to difference between current speed and target speed.
 
 
 there will have to be one more controller to deal with stoplights--
 cars should try to come to a stop at the stoplights and behind the other cars. 
 if a car has no other cars in front of it, it will try to brake
 so that it comes to a stop right at the stoplight... how do i do this?
 if car is within a certain distance of a stoplight that's red or yellow,
 it will try to slow down unless its current speed can take it through
 the stoplight not long after it turns red. if it can't make the light,
 then it brake in a way that's directly proportional to its current speed
 and inversely proportional to the distance between the car and the light.
 maybe i could multiply make two terms, one that's proportional to speed
 and one that's inversely proportional to distance, and multiply them together,
 and playing with the denominator so it can't be zero.
 ~~~
 braking_force = constant * velocity / max(min_distance, distance)
 ~~~I NEED TO TRY THIS, IT SEEMS LIKE IT COULD WORK
 
 also, maybe i will constrain velocity of car so that it's never negative,
 i.e. it can't go in reverse. this would simplify things.
 
 */




Stoplight slNorth, slWest;


void setup() {
  size(800, 600, P3D);

  float[] pos1 = {
    width/2 + 25, height/2 - 50
  };
  float[] angle1 = {
    PI/6, PI/6, 0
  };
  slNorth = new Stoplight(200, 50, 280, 0, pos1, angle1, 5);

  float[] pos2 = {
    width/2 - 25, height/2 - 50
  };
  float[] angle2 = {
    PI/6, -PI/6, 0
  };
  slWest = new Stoplight(200, 50, 280, 265, pos2, angle2, 5);
}


void draw() {
  background(0);

  rectMode(CENTER);
  stroke(0);
  fill(127);

  pushMatrix();
  translate(width/2, height/2);
  rotateX(PI/4);
  rect(0, 0, 2*width, 25);
  rect(0, 0, 25, 2*height);
  popMatrix();

  slNorth.update();
  slWest.update();
}





class Car {
  float[] pos, vel, dvel;
  float radius;
  color carColor;
  float maxSpeed = 2.5;
  float maxAccel = .015;
  float maxBrake = 3*maxAccel;
  Road road;
  /*road knows which cars are on it, car knows which road it's on
  */

  float minSeparationDistance = 10;

  Car (float[] pos, float[] vel, float[] dvel, 
  float radius, color carColor, Road road) {
    this.pos = pos;
    this.vel = vel;
    this.dvel = dvel;
    this.radius = radius;
    this.carColor = carColor;
    this.road = road;
  }

  void update() {
  }

  Car findNearestCar(Road road) {
    return null;
  }
}




class Road {
  ArrayList<Car> cars = new ArrayList<Car>();
  ArrayList<Stoplight> stoplights = new ArrayList<Stoplight>();
  /*road knows which Cars and Stoplights it has,
  later it will also have lanes and cars will be travel
  on a certain lane of a given road. they can change lanes on
  a given road, and then can change roads at an intersection
  */

  Road () {
  }

  void addCar(Car car) {
    cars.add(car);
  }

  void removeCar(int index) {
  }


  /*
i'll implement lanes
   later, for now i'll just have roads with cars going
   in one direction
   */
}





class Intersection {

  Intersection(Road road1, Road road2) {
  }
  /*Intersection knows which Roads it has,
   it doesn't need to know which Stoplights
   it has because the road knows which stoplights
   it has
   */

}






class Stoplight {
  int lightState = 0;
  int greenTime, yellowTime, redTime, totalPeriod, currentTime;
  color GREEN = color(0, 255, 0);
  color YELLOW = color(255, 255, 0);
  color RED = color(255, 0, 0);
  color currentColor = GREEN;
  float[] pos, angle;
  float radius;
  float[] lightHeight = new float[3];
  PGraphics img;

  Stoplight (int greenTime, int yellowTime, int redTime, int initialTime, 
  float[] pos, float[] angle, float radius) {
    this.greenTime = greenTime;
    this.yellowTime = yellowTime;
    this.redTime = redTime;
    totalPeriod = greenTime + yellowTime + redTime;
    this.currentTime = initialTime % totalPeriod;
    this.pos = pos;
    this.angle = angle;
    this.radius = radius;
    for (int i = 0; i <= 2; i++) lightHeight[i] = (i-1)*(8/3.0)*radius;
    img = createGraphics(round(4*radius), round(20*radius));
  }

  void update() {

    switch(lightState) {
    case 0:
      if (currentTime >= greenTime) {
        lightState = 1;
        currentColor = YELLOW;
      }
      break;
    case 1:
      if (currentTime >= greenTime + yellowTime) {
        lightState = 2; 
        currentColor = RED;
      }
      break;
    case 2:
      if (currentTime == 0) {
        lightState = 0; 
        currentColor = GREEN;
      }
      break;
    }

    currentTime = (currentTime + 1) % totalPeriod;



    img.beginDraw();
    img.background(0, 0);

    img.smooth();
    img.strokeWeight(1);
    img.stroke(127);
    img.fill(0);
    img.rectMode(CENTER);
    img.translate(.5*img.width, .5*img.height);
    img.rect(0, 0, (8.5/3.0)*radius, 8.5*radius, .5*radius);
    img.strokeWeight(.75*radius);
    img.line(0, (12/3.0)*radius, 0, 8*radius);

    img.noStroke();
    img.fill(currentColor);
    img.ellipse(0, lightHeight[lightState], 
    2*radius, 2*radius);

    img.endDraw();

    imageMode(CENTER);
    pushMatrix();
    translate(pos[0], pos[1]);
    rotateX(angle[0]);
    rotateY(angle[1]);
    rotateZ(angle[2]);
    image(img, 0, 0);
    popMatrix();
  }
}

