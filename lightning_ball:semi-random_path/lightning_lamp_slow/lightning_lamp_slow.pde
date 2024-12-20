/*i should try doing this with a class, "bolt", and fill
 an arraylist with instances of bolt. this way i can change
 the number of bolts easily, the array lists holding lengths
 and angles for the segments of each bolt will be contained
 within each bolt and handled by methods that i give the
 bolt class. the code will look cleaner and be easier to
 work with*/

float x0, y0, x1, y1;
int nbolts=12;
float rin=75, rout=345;
float[] ain, aout, 
xin, xout, yin, yout;
int[] joints;
float[] chance_of_new_vertex;

ArrayList<Float>[] a=new ArrayList[nbolts];
ArrayList<Float>[] len=new ArrayList[nbolts];


void setup() {
  size(700, 700);
  smooth();

  ain=new float[nbolts];
  aout=new float[nbolts];
  xin=new float[nbolts];
  xout=new float[nbolts];
  yin=new float[nbolts];
  yout=new float[nbolts];

  joints=new int[nbolts];
  chance_of_new_vertex=new float[nbolts];

  /*this translate puts the origin of our coord
   system at the center of the canvas*/
  pushMatrix();
  translate(width/2, height/2);

  for (int i=0; i<nbolts; i++) {

    ain[i]=random(0, 2*PI);
    aout[i]=ain[i]+random(-PI/6, PI/6);
    joints[i]=(int)random(3, 20);
    a[i]=new ArrayList<Float>();
    len[i]=new ArrayList<Float>();

    xin[i]=rin*cos(ain[i]);
    yin[i]=rin*sin(ain[i]);
    xout[i]=rout*cos(aout[i]);
    yout[i]=rout*sin(aout[i]);

    chance_of_new_vertex[i]=random(.925, .975);

    /*initialize semi-random paths in setup,
     this function will also be called when the mouse is
     pressed and dragged so that the bolts don't lag
     so long in adjusting to their new positions*/
    initialize_semi_random_path(xin[i], yin[i], xout[i], yout[i], 
    joints[i], a[i], len[i]);
  }

  popMatrix();
}



void draw() {
  noStroke();
  fill(0, 50);
  rect(0, 0, width, height);


  for (int i=0; i<nbolts; i++) {
    /*ain is performing a random walk around the circle,
     no danger that it will ever go to far =)
     aout is tied to ain but allowed to drift back and forth
     relative to ain. this guarantees ain will never
     be very far from aout*/

    ain[i]+=random(-PI/50, PI/50);
    aout[i]=ain[i] + (PI/2)*( noise( .1*ain[i], frameCount*.005) - .5);


    /*starting coords and target coords
     are xin, yin    and    xout, yout
     they get put in to perturb_semi_random_path function
     */
    xin[i]=rin*cos(ain[i]);
    yin[i]=rin*sin(ain[i]);

    xout[i]=rout*cos(aout[i]);
    yout[i]=rout*sin(aout[i]);
  }
  
  /*this translate puts the origin of our coord
   system at the center of the canvas*/
  translate(width/2, height/2);
  
  /*draw inner and outer radii of lightning lamp*/
  noFill();
  stroke(0, 0, 255);
  strokeWeight(2);
  ellipse(0, 0, 2*rin, 2*rin);
  ellipse(0, 0, 2*rout+2, 2*rout+2);


  /*mouse control. when mouse is pressed in void mousePressed,
   all ain values are brought close to the mouse.
   aout is constrained to be near ain so it will
   also change automatically. if the mouse is held,
   ain is not changed but rather constrained to stay close
   to the mouse. when the mouse is released in void mouseReleased,
   all bolts are reinitialized, but with the same number of vertices
   and chance_of_new_vertex that they had before*/
  if (mousePressed) {
    float mA=atan2(mouseY-height/2, mouseX-width/2);

    for (int i=0; i<nbolts; i++) {
      ain[i]=constrain(ain[i], mA-PI/10, mA+PI/10);

      xin[i]=rin*cos(ain[i]);
      yin[i]=rin*sin(ain[i]);

      if ( dist(mouseX, mouseY, pmouseX, pmouseY) > 5 ) {
        a[i]=new ArrayList<Float>();
        len[i]=new ArrayList<Float>();

        initialize_semi_random_path(xin[i], yin[i], xout[i], yout[i], 
        joints[i], a[i], len[i]);
      }
    }
  }


  /*perturb and redraw each of the bolts*/
  for (int i=0; i<nbolts; i++) {
    perturb_semi_random_path(xin[i], yin[i], 
    xout[i], yout[i], a[i], len[i], 
    chance_of_new_vertex[i]);
  }
}


void mousePressed() {

  float mA=atan2(mouseY-height/2, mouseX-width/2);
  for (int i=0; i<nbolts; i++) {

    ain[i]=mA+random(-PI/10, PI/10);

    xin[i]=rin*cos(ain[i]);
    yin[i]=rin*sin(ain[i]);
  }
}

void mouseReleased() {
  for (int i=0; i<nbolts; i++) {

    ain[i]=random(0, 2*PI);
    aout[i]=ain[i]+random(-PI/6, PI/6);

    xin[i]=rin*cos(ain[i]);
    yin[i]=rin*sin(ain[i]);
    xout[i]=rout*cos(aout[i]);
    yout[i]=rout*sin(aout[i]);

    a[i]=new ArrayList<Float>();
    len[i]=new ArrayList<Float>();

    initialize_semi_random_path(xin[i], yin[i], xout[i], yout[i], 
    joints[i], a[i], len[i]);
  }
}








/*function that initializes a semi random path.
 this function will get called throughout the running of
 the program to reset the angles based on the start points
 and end points of the path. perturb_semi_random_path
 performs perturbations on the angles unrelated to the start
 and end points, which causes problems if they drift significantly
 over time. so, every 100 frames or so, i can call
 initialize_semi_random_path to recalculate the angles*/
void initialize_semi_random_path(float x0, float y0, 
float x1, float y1, int joints, 
ArrayList<Float> a, ArrayList<Float> len) {

  /*bolts with more joints can be brighter, this will make the sketch
   more dynamic and make it easier to differentiate between bolts of
   with different numbers of vertices*/
  float T = 255 * joints / 20;
  color C = color(0, 255, 0);

  stroke(C, T/2);
  fill(C, T/2);
  ellipse(x0, y0, 5, 5);


  pushMatrix();

  float afinal=atan2(y1, x1);
  translate(x1, y1);
  rotate( atan2(y1, x1) );
  ellipse(0, 0, 3, 20);

  popMatrix();

  stroke(C, T);
  strokeWeight(4);


  float da=PI/4;
  /*temporary variables which are updated throughout
   the path drawing process, this way x0 and y0
   are left alone*/
  float x0t=x0, y0t=y0;

  for (int i=0; i<joints; i++) {
    len.add( dist(x0t, y0t, x1, y1) );
    a.add( atan2(y1-y0t, x1-x0t) );
    len.set( i, random(len.get(i)/2, 3*len.get(i)/2) / (joints+1-i) );
    a.set( i, random(a.get(i)-da, a.get(i)+da) );

    float xx=x0t+ len.get(i) * cos( a.get(i) ), 
    yy=y0t + len.get(i) * sin( a.get(i) );
    line(x0t, y0t, xx, yy);
    x0t=xx;
    y0t=yy;
  }
  line(x0t, y0t, x1, y1);
}





/*this function perturbs and redraws a semi-random path*/
void perturb_semi_random_path(float x0, float y0, 
float x1, float y1, 
ArrayList<Float> a, ArrayList<Float> len, 
float chance_new) {

  int num=len.size();

  /*bolts with more joints can be brighter, this will make the sketch
   more dynamic and make it easier to differentiate between bolts of
   with different numbers of vertices*/
  float T = 255 * num / 20;
  color C = color(0, 255, 0);

  stroke(C, T/2);
  fill(C, T/2);
  ellipse(x0, y0, 5, 5);


  pushMatrix();

  float afinal=atan2(y1, x1);
  translate(x1, y1);
  rotate( atan2(y1, x1) );
  ellipse(0, 0, 3, 20);

  popMatrix();

  stroke(C, T);
  strokeWeight(4);


  /*reset x0t and y0t to their original values,
   x0 and y0. they are changed repeatedly in the coming
   for loop, so their values need to be reset each
   frame*/
  float x0t=x0;
  float y0t=y0;

  /*draw random path here each frame,
   where each vertex is taking a random
   walk in both angle and length so that
   the path changes from frame to frame.
   hopefully by having many joints at once
   performing random walks, the length and
   direction of the path will remain
   relatively constant. if it doesn't, i 
   may have to consider adding or removing
   vertices as appropriate*/

  float xfinal=0, yfinal=0; /*these will store the x and y coords
   of the the last moving vertex*/

  for (int i=0; i < num; i++) {

    len.set( i, len.get(i) + random( -.05*len.get(i), .05*len.get(i) ) );
    a.set( i, a.get(i) + random(-PI/50, PI/50) );

    float d=dist(x0t, y0t, x1, y1);

    len.set( i, constrain( len.get(i), (d / (num + 1 - i)) * .5, 
    (d / (num + 1 - i)) * 3) );
    float at=atan2(y1-y0t, x1-x0t);
    /*this was FIXED HERE. the angle discontinuity along
     the negative x axis combined with constrain was causing
     problems here so i fixed them with the block of code 
     below, which is an implementation of the modulo operator*/
    if ( abs(at - a.get(i)) > PI ) {
      if (at > a.get(i)) at-=2*PI;
      else at+=2*PI;
    }
    a.set( i, constrain( a.get(i), at-PI/2.7, at+PI/2.7) );


    float xx=x0t+len.get(i) * cos( a.get(i) ), 
    yy=y0t+len.get(i) * sin( a.get(i) );
    line(x0t, y0t, xx, yy);

    x0t=xx;
    y0t=yy;

    if (i == len.size() - 1) {
      xfinal=xx;
      yfinal=yy;
    }
  }

  line(x0t, y0t, x1, y1);
  /*i don't know what the x and y coords of any of the vertices is,
   i just know their length and angle relative to the previous vertex*/

  float df=dist(xfinal, yfinal, 0, 0), d0=.95*rout;
  /*distances that will be used for adding or subtracting vertices*/

  /*a vertex is subtracted if the final unfixed vertex
   of the bolt is too close to the outer radius of the lightning lamp
   */
  if ( df > d0 ) {
    if (len.size() > 0) {
      int it=(int)random(0, len.size() );
      len.remove( it );
      a.remove( it );
    }
  }

  /*every frame there is a chance that a vertex will be added.
   the rate at which vertices are subtracted (the frequency with
   which the final vertex strays too far from home) doesn't depend
   strongly on the vertices. the rate at which they're added
   doesn't depend on the number of vertices at all. this means
   that the number of vertices can wander considerably, it
   is sort of performing a random walk in one dimension and there
   doesn't seem to be much of a "conservative" force holding it
   in place. if i could tweak the mechanics so that more vertices
   meant a higher chance that the final vertex strays too far,
   then there would be a stable range for the number of vertices.
   maybe there already is--time will tell*/
  if (random(0, 1) > chance_new) {
    /*bolts have different values for chance_of_new_vertex, some will
     have more vertices and some will have less, this makes the sketch
     more dynamic*/

    if ( len.size() > 1 ) {

      int it=(int)random(1, len.size() ); //temporary index
      len.add( it, len.get(it-1)/2 + len.get(it)/2 );
      a.add( it, a.get(it-1)/2 + a.get(it)/2 );
    } 

    else {
      len.add( d0 / (len.size() + 2) );
      a.add( atan2(y1-y0, x1-x0) );
    }
  }
}
