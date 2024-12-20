/*

 a brownian motion sketch with collision detection and collision physics for cirlces.
 brownian motion is recreated by tracking the motion of one circle among many randomly sized
 and massed circles confined to the area of the sketch, like gas molecules in a box.
 
 toggle keys
 "s" toggles sticky circles on and off, sticky circles isn't realistic
 "h" toggles hollow circles on and off
 "t" toggles track on and off, track is what allows brownian motion to be observed
 
 */

int num=800;
//number of particles

float[] r=new float[num];
float rmin=2.5;
float rmax=3.5;
float[] m=new float[num];

float[] x=new float[num];
float[] y=new float[num];

float[] vx=new float[num];
float[] vy=new float[num];
float vmax=.4;
/*vmax needs to be small in comparison to the radii of the circles
 for collision detection, and hence motion, to be realistic
 */

int iterations=2;
/*number of time steps between drawing each frame,
 this allows velocities to be much smaller,
 which in turn makes collision detection much more accurate
 */

int trail=500;
int trackindex=0;
float xtrail[]=new float[trail];
float ytrail[]=new float[trail];
/*choose which particle to track, reproduce brownian motion from collisions!
 */

boolean track=true;
boolean sticky=false;
boolean hollow=false;
boolean walls=true;





void setup() {

  size(400, 400);
  frameRate(50);
  noSmooth();
  ellipseMode(CENTER);

  fill(255, 0, 0);
  stroke(255, 0, 0);

  for (int i=0; i<num; i++) {

    r[i]=random(rmin, rmax);
    m[i]=sq(r[i])/sq(rmin);

    x[i]=random(0, width);
    y[i]=random(0, height);

    vx[i]=random(-vmax, vmax);
    vy[i]=random(-vmax, vmax);
  }

  for (int i=0; i<trail; i++) {
    xtrail[i]=x[trackindex];
    ytrail[i]=y[trackindex];
  }
}


void draw() {

  background(0);

  for (int k=0; k<iterations; k++) {

    for (int i=0; i<num-1; i++) {
      for (int j=i+1; j<num; j++) {
        /*from j=i+1 is crucial, this prevents Impact from being
         called twice for each pair of balls. the "plus one" prevents
         checkCollision and Impact being called for one ball
         */
        if (checkCollision(x[i], y[i], x[j], y[j], r[i], r[j])) {

          if (track) {
            if (i==trackindex) {
              for (int m=trail-1; m>0; m--) {
                xtrail[m]=xtrail[m-1];
                ytrail[m]=ytrail[m-1];
              }
              xtrail[0]=x[i];
              ytrail[0]=y[i];
            }
          }

          float[] newPandV = Impact(x[i], y[i], x[j], y[j], 
          vx[i], vy[i], vx[j], vy[j], r[i], r[j], m[i], m[j]);

          if (!sticky) {
            x[i]=newPandV[0];
            y[i]=newPandV[1];
            x[j]=newPandV[2];
            y[j]=newPandV[3];
          }

          vx[i]=newPandV[4];
          vy[i]=newPandV[5];
          vx[j]=newPandV[6];
          vy[j]=newPandV[7];

          /*
          //println(m[0]*vx[0]+m[1]*vx[1]);
           //println(m[0]*vy[0]+m[1]*vy[1]);
           */
          //these quantities should always be the same because momentum is conserved
          //except it's not quite true because the particles bounce off the walls,
          //and this definitely doesn't conserve momentum. rather, there are discrete values
          //the total momentum can take
          /*
          println(m[0] * (sq(vx[0]) + sq(vy[0])) + m[1] * (sq(vx[1]) + sq(vy[1]) ));
           */
          //this last quantity should always be the same because energy is conserved
        }
      }
    }

    for (int i=0; i<num; i++) {
      x[i]+=vx[i];
      y[i]+=vy[i];

      if (walls) {
        if (x[i]<0 || x[i]>width) vx[i]=-vx[i];
        if (y[i]<0 || y[i]>height) vy[i]=-vy[i];

        if (x[i]<0) x[i]=-x[i];
        if (x[i]>width) x[i]=2*width-x[i];
        if (y[i]<0) y[i]=-y[i];
        if (y[i]>height) y[i]=2*height-y[i];
      }
      else {
        if (x[i]<0) x[i]+=width;
        if (x[i]>width) x[i]-=width;
        if (y[i]<0) y[i]+=height;
        if (y[i]>height) y[i]-=height;
      }
    }
  }

  stroke(255, 0, 0);
  if (hollow) noFill();
  else fill(255, 0, 0);
  for (int i=0; i<num; i++) ellipse(x[i], y[i], 2*r[i], 2*r[i]);

  if (track) {
    stroke(255);
    if (hollow) noFill();
    else fill(255);
    ellipse (x[trackindex], y[trackindex], 2*r[trackindex], 2*r[trackindex]);
    for (int j=0; j<trail-1; j++) {
      stroke( 255 * (1 - .75 * (float)j / trail) );
      line(xtrail[j], ytrail[j], xtrail[j+1], ytrail[j+1]);
    }
  }
}


void keyReleased() {
  if (key=='s' || key=='S') sticky=!sticky;
  if (key=='h' || key=='H') hollow=!hollow;
  if (key=='t' || key=='T') track=!track;
  if (key=='w' || key=='W') walls=!walls;
}





boolean checkCollision(float x1, float y1, float x2, float y2, 
float r1, float r2) {
  boolean collision;
  if (abs(x1-x2)+abs(y1-y2) < 2*r1 + 2*r2) {
    if (dist(x1, y1, x2, y2) < r1+r2) collision=true;
    else collision=false;
  } 
  else collision=false;
  return collision;
}





float[] Impact(float x1, float y1, float x2, float y2, 
float vx1, float vy1, float vx2, float vy2, 
float r1, float r2, float m1, float m2) {
  float impactx=vx2-vx1;
  float impacty=vy2-vy1;
  float impulsex=-x2+x1;
  float impulsey=-y2+y1;
  float ratio=sqrt( sq(impulsex) + sq(impulsey) );
  impulsex=impulsex / ratio;
  impulsey=impulsey / ratio;

  float impactSpeed = impactx * impulsex + impacty * impulsey;
  float reducedMass = (2 * m1 * m2) / (m1 + m2);
  float distance = dist(x1, y1, x2, y2);
  float radiusRatio = ( r1 + r2 - distance ) / ( r1 + r2 );
  float d1 = r2 * radiusRatio;
  float d2 = r1 * radiusRatio;

  x1+= d1 * impulsex;
  y1+= d1 * impulsey;
  x2-= d2 * impulsex;
  y2-= d2 * impulsey;

  impulsex=impulsex * impactSpeed * reducedMass;
  impulsey=impulsey * impactSpeed * reducedMass;

  vx1+=impulsex/m1;
  vy1+=impulsey/m1;
  vx2-=impulsex/m2;
  vy2-=impulsey/m2;

  float[] newPositionAndVelocity= {
    x1, y1, x2, y2, vx1, vy1, vx2, vy2
  };
  return newPositionAndVelocity;
}

