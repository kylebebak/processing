/*

 a brownian motion sketch with collision detection and collision physics for cirlces.
 brownian motion is recreated by tracking the motion of one circle among many randomly sized
 and massed circles confined to the area of the sketch, like gas molecules in a box.
 
 toggle keys
 "s" toggles sticky circles on and off, sticky circles isn't realistic
 "h" toggles hollow circles on and off
 "t" toggles track on and off, track is what allows brownian motion to be observed
 
 */



/*****/
int totalcollisions=1000; //this variable determines the number of collisions before the sketch ends
/*****/



PrintWriter dxoutput, dyoutput, dDistoutput, diterationoutput, histogramlist;

int num=500;
//number of particles

float[] r=new float[num];
float rmin=4;
float rmax=7;
float[] m=new float[num];

float[] x=new float[num];
float[] y=new float[num];

float[] vx=new float[num];
float[] vy=new float[num];
float vmax=.4;
/*vmax needs to be small in comparison to the radii of the circles
 for collision detection, and hence motion, to be realistic
 */

int iterations=100;
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

boolean walls=true;
boolean replaceinmiddle=false;
boolean pause=false;


int iterationcounter=0;
int collisioncounter=-2; //these variables should not be changed


float[] xtrack=new float[2];
float[] ytrack=new float[2];
int[] iterationtrack=new int[2];

float[] dx=new float[totalcollisions];
float[] dy=new float[totalcollisions];
float[] dDist=new float[totalcollisions];
int[] diteration=new int[totalcollisions];





void setup() {

  size(400, 400);
  noSmooth();
  ellipseMode(CENTER);
  dxoutput = createWriter("dx values.txt");
  dyoutput = createWriter("dy values.txt");
  dDistoutput = createWriter("dDistance values.txt");
  diterationoutput = createWriter("dIteration values.txt");
  histogramlist = createWriter("histogram range.txt");

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

  xtrack[0]=x[trackindex];
  ytrack[0]=y[trackindex];
}





void draw() {

  background(0);

  for (int k=0; k<iterations; k++) {

    iterationcounter+=1;

    for (int i=0; i<num-1; i++) {
      for (int j=i+1; j<num; j++) {
        /*from j=i+1 is crucial, this prevents Impact from being
         called twice for each pair of balls. the "plus one" prevents
         checkCollision and Impact being called for one ball
         */
        if (checkCollision(x[i], y[i], x[j], y[j], r[i], r[j])) {

          if (i==trackindex || j==trackindex) {

            if (collisioncounter<totalcollisions-1) {

              collisioncounter+=1;

              if (collisioncounter>=0) {

                xtrack[1]=xtrack[0];
                ytrack[1]=ytrack[0];
                iterationtrack[1]=iterationtrack[0];
                xtrack[0]=x[trackindex];
                ytrack[0]=y[trackindex];
                iterationtrack[0]=iterationcounter;

                dx[collisioncounter]=xtrack[0]-xtrack[1];
                dy[collisioncounter]=ytrack[0]-ytrack[1];
                dDist[collisioncounter]=dist( xtrack[0], ytrack[0], xtrack[1], ytrack[1] );
                diteration[collisioncounter]=iterationtrack[0]-iterationtrack[1];
              }
            }
          }

          float[] newPandV = Impact(x[i], y[i], x[j], y[j], 
          vx[i], vy[i], vx[j], vy[j], r[i], r[j], m[i], m[j]);

          x[i]=newPandV[0];
          y[i]=newPandV[1];
          x[j]=newPandV[2];
          y[j]=newPandV[3];

          vx[i]=newPandV[4];
          vy[i]=newPandV[5];
          vx[j]=newPandV[6];
          vy[j]=newPandV[7];
        }
      }
    }



    //update positions
    for (int i=0; i<num; i++) {
      x[i]+=vx[i];
      y[i]+=vy[i];
    }

    /*drop tracked circle in middle if it's at boundary. i need to
     change the way dx, dy and dDist are computed if i want to use this
     */
    if (walls) {
      if (replaceinmiddle) {
        if ( x[trackindex]<0 || x[trackindex]>width
          || y[trackindex]<0 || y[trackindex]>height ) {
          x[trackindex]=width/2;
          y[trackindex]=height/2;
        }
      }
    }

    //bounce ballls of walls or loop them
    for (int i=0; i<num; i++) {

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
  fill(255, 0, 0);
  for (int i=0; i<num; i++) ellipse(x[i], y[i], 2*r[i], 2*r[i]);

  stroke(255);
  fill(255);
  ellipse (x[trackindex], y[trackindex], 2*r[trackindex], 2*r[trackindex]);

  println(collisioncounter);
  if (collisioncounter>0) {
    println(dx[collisioncounter]);
    println(dy[collisioncounter]);
    println(dDist[collisioncounter]);
    println(diteration[collisioncounter]);
  }

  if (collisioncounter>=totalcollisions-1) {
    /*size of all arrays is totalcollisions, so drawing must stop
     when collisioncounter reaches total collisions to avoid getting an
     array out of bounds exception. noLoop allows the current draw loop
     to finish and the prevents it from running again
     */



    //text file writing
    arrayWriter(dx, dxoutput, "dx values");
    arrayWriter(dy, dyoutput, "dy values");
    arrayWriter(dDist, dDistoutput, "dDistance values");
    arrayWriter(diteration, diterationoutput, "dIteration values");

    for (int i=0; i<=400; i++) histogramlist.println((float)i/2-100);
    histogramlist.flush();
    histogramlist.close();



    exit();
    //noLoop(); //either exit or noLoop could be called to stop the program from running
  }
}





void keyReleased() {
  if (key=='w' || key=='W') walls=!walls;
}

void mouseReleased() {
  if (collisioncounter<totalcollisions-1) {
    if (pause==false) {    
      noLoop();
    }
    if (pause==true) {
      loop();
    }
    pause=!pause;
  }
}





void arrayWriter(float[] arr, PrintWriter writer, String name) {
  writer.println(name);
  writer.println("max = " + max(arr)); //writes the max value of the array
  writer.println("min = " + min(arr)); //writes the min value of the array
  writer.println(); //blank line
  for (int i=0; i<arr.length; i++) writer.println(arr[i]); //write all array values
  writer.flush(); //writes the remaining data to the file
  writer.close(); //finishes the file
}

void arrayWriter(int[] arr, PrintWriter writer, String name) {
  writer.println(name);
  writer.println("max = " + max(arr)); //writes the max value of the array
  writer.println("min = " + min(arr)); //writes the min value of the array
  writer.println(); //blank line
  for (int i=0; i<arr.length; i++) writer.println(arr[i]); //write all array values
  writer.flush(); //writes the remaining data to the file
  writer.close(); //finishes the file
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

