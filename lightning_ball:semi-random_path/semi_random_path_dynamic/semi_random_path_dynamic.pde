float x0, y0, x1, y1;
float x0t, y0t;
int num=15;

float da=PI/4;
ArrayList<Float> a=new ArrayList<Float>();
ArrayList<Float> len=new ArrayList<Float>();

void setup() {
  size(800, 500);
  smooth();
  background(0);

  //starting coordinates
  x0=width/2;
  y0=height/2;
  //target coordinates
  x1=width/5;
  y1=3*height/5;

  fill(255, 0, 0);
  ellipse(x0, y0, 8, 8);
  ellipse(x1, y1, 8, 8);
  strokeWeight(4);
  stroke(0, 255, 0, 100);


  /*reset x0t and y0t to their original values,
   x0 and y0. they are changed repeatedly in the coming
   for loop, so their values need to be reset each
   frame*/
  x0t=x0;
  y0t=y0;

  for (int i=0; i<num; i++) {
    len.add( dist(x0t, y0t, x1, y1) );
    a.add( atan2(y1-y0t, x1-x0t) );
    len.set( i, random(len.get(i)/2, 3*len.get(i)/2) / (num+1-i) );
    a.set( i, random(a.get(i)-da, a.get(i)+da) );

    float xx=x0t+ len.get(i) * cos( a.get(i) ), 
    yy=y0t + len.get(i) * sin( a.get(i) );
    line(x0t, y0t, xx, yy);
    x0t=xx;
    y0t=yy;
  }
  line(x0t, y0t, x1, y1);
}





void draw() {

  if (mousePressed) {
    x1=mouseX;
    y1=mouseY;
  }

  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);


  fill(255, 0, 0);
  ellipse(x0, y0, 8, 8);
  ellipse(x1, y1, 8, 8);


  strokeWeight(4);
  stroke(0, 255, 0, 100);

  /*reset x0t and y0t to their original values,
   x0 and y0. they are changed repeatedly in the coming
   for loop, so their values need to be reset each
   frame*/
  x0t=x0;
  y0t=y0;

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

  num=len.size();
  println(num);

  float xfinal=0, yfinal=0; /*these will store the x and y coords
   of the last moving vertex*/

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
    a.set( i, constrain( a.get(i), at-PI/2.8, at+PI/2.8) );
    

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
  /*i don't know what the x and y coords of any vertex is,
   i just know their length and angle relative to the previous vertex*/

  float df=dist(x0, y0, xfinal, yfinal), d0=dist(x0, y0, x1, y1);
  /*distances that will be used for adding or subtracting vertices*/

  /*a vertex is subtracted if the final unfixed vertex
   of the bolt is further away from the starting point than
   the target point*/
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
  if (random(0, 1) > .96) {

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





  /*filter(BLUR);
   better without blur, it renders a lot faster*/
}
