/* get vertex code returns an integer 0 through 4.
 the integers, in order, correspond to the following:
 VERTEX, BEZIER_VERTEX, QUAD_BEZIER_VERTEX, CURVE_VERTEX, and BREAK.
 BREAK corresponds to a "move to" instruction in the SVG curve,
 this can be done by endShape and then beginShape with 
 a vertex at the given coords
 */

PShape sh, sh0, sh1;
float[] r0, a0, r1, a1;
float[] R, A; //final mixed arrays
/*radii and angles for each vertex. this sketch is done in
 polar coords*/
int V;
//number of vertices of shape with larger number of vertices


//transformation variables
float n; //number of vertices cast as a float
float nn, nnp; //number of "new" (changed) vertices 
float T=1500, fc=0; //this determines total length of transformation
//fc is frameCount cast as a float
float weightR, weightA;
ArrayList<Float> crad=new ArrayList(), cangle=new ArrayList();
float zoom0=3, zoom1=3;
//these are scaling factors for each shape
int Ve=500; //extra vertices


void setup() {
  size(1200, 700);
  smooth();
  sh = loadShape("map.svg");

  /*get shapes of two states from US map using getChild, just enter
   2 letter state initials*/
  sh0 = sh.getChild("OR");
  sh1 = sh.getChild("LA");
  /*if sh1 is louisiana "LA" there's a bug, maybe some of louisiana's
   vertices are repeated. it turns out this was the problem, it's
   been solved*/


  int[] codes0=sh0.getVertexCodes(), codes1=sh1.getVertexCodes();
  int V0=codes0.length, V1=codes1.length;
  /*getVertexCodeCount does not return the same value as querying
   the length of the array of vertex codes gotten with getVertexCodes*/

  /*these loops get the indices at which the first breaks in the shapes
   occur, and set the lengths of the arrays of vertices to these values*/
  for (int i=0; i<codes0.length; i++) {
    if (codes0[i]==4) {
      V0=i;
      break;
    }
  }
  for (int i=0; i<codes1.length; i++) {
    if (codes1[i]==4) {
      V1=i;
      break;
    }
  }

  float[] x0=new float[V0];
  float[] y0=new float[V0];
  float[] x1=new float[V1];
  float[] y1=new float[V1];

  /*initialize x and y arrays which will soon be 
   r and theta arrays*/
  for (int i=0; i<V0; i++) {
    x0[i]=sh0.getVertexX(i); 
    y0[i]=sh0.getVertexY(i);
  }
  for (int i=0; i<V1; i++) {
    x1[i]=sh1.getVertexX(i); 
    y1[i]=sh1.getVertexY(i);
  }  


  /*now, if the numbers of vertices in the two shapes aren't the same,
   vertices are added to the shape with fewer vertices until these numbers
   are the same. these vertices will be added _exactly_ in the middle
   of existing vertices, so as not to change the shape at all. having
   the same number of vertices in the two shapes makes switching these
   vertices much more practical--all one has to do is replace the nth
   vertex in the starting shape with the nth vertex in the target shape*/
  Ve=abs(Ve);
  V=max(V0, V1)+Ve;
  n=(float)V;

  int d=abs(V0-V1);
  ArrayList<Float> xx0=new ArrayList();
  ArrayList<Float> yy0=new ArrayList();
  ArrayList<Float> xx1=new ArrayList();
  ArrayList<Float> yy1=new ArrayList();


  for (int i=0; i<V0; i++) {
    xx0.add(x0[i]);
    yy0.add(y0[i]);
  }
  for (int i=0; i<V1; i++) {
    xx1.add(x1[i]);
    yy1.add(y1[i]);
  }

  int index;
  float xx, yy;
  if (V1 >= V0) {
    for (int i=0; i<d+Ve; i++) {
      index=(int)random(xx0.size()-1);
      xx= .5 * (xx0.get(index) + xx0.get(index+1));
      yy= .5 * (yy0.get(index) + yy0.get(index+1));
      xx0.add(index+1, xx);
      yy0.add(index+1, yy);
    }
    for (int i=0; i<Ve; i++) {
      index=(int)random(xx1.size()-1);
      xx= .5 * (xx1.get(index) + xx1.get(index+1));
      yy= .5 * (yy1.get(index) + yy1.get(index+1));
      xx1.add(index+1, xx);
      yy1.add(index+1, yy);
    }
  }
  if (V0 > V1) {
    for (int i=0; i<Ve; i++) {
      index=(int)random(xx0.size()-1);
      xx= .5 * (xx0.get(index) + xx0.get(index+1));
      yy= .5 * (yy0.get(index) + yy0.get(index+1));
      xx0.add(index+1, xx);
      yy0.add(index+1, yy);
    }
    for (int i=0; i<d+Ve; i++) {
      index=(int)random(xx1.size()-1);
      xx= .5 * (xx1.get(index) + xx1.get(index+1));
      yy= .5 * (yy1.get(index) + yy1.get(index+1));
      xx1.add(index+1, xx);
      yy1.add(index+1, yy);
    }
  }


  x0=new float[xx0.size()];
  y0=new float[xx0.size()];
  for (int i=0; i<xx0.size(); i++) {
    x0[i]=xx0.get(i);
    y0[i]=yy0.get(i);
  }

  x1=new float[xx1.size()];
  y1=new float[xx1.size()];
  for (int i=0; i<xx1.size(); i++) {
    x1[i]=xx1.get(i);
    y1[i]=yy1.get(i);
  }



  /*convert all x and y coords of vertices to polar coords centered
   at the origin, with getOrigin and then recToPolar*/
  r0=new float[V];
  a0=new float[V];
  r1=new float[V];
  a1=new float[V];

  float[] oo=getOrigin(sh0);
  for (int i=0; i<V; i++) {
    float[] polarCoords=recToPolar(x0[i], y0[i], 
    oo[0], oo[1]);
    r0[i]=zoom0*polarCoords[0];
    a0[i]=polarCoords[1];
  }

  //do the same for the other shape
  oo=getOrigin(sh1);
  for (int i=0; i<V; i++) {
    float[] polarCoords=recToPolar(x1[i], y1[i], 
    oo[0], oo[1]);
    r1[i]=zoom1*polarCoords[0];
    a1[i]=polarCoords[1];
    crad.add(r1[i]);
    cangle.add(a1[i]);
  }

  /*copy r and a arrays for first shape to R and A, the dynamic
   arrays that will hold a mix of coordinates from shape 1 and shape 2*/
  R=new float[V];
  A=new float[V];
  arrayCopy(r0, R);
  arrayCopy(a0, A);
}



void draw() {
  /*use the transforming_shapes_with_noise
   techniques to transform one shape into another
   with lots of deformation in between*/

  /*vertices must be drawn in the correct order,
   and this is easy with polygons--you just order them according
   to the angle they make with the x axis and vertices won't
   overlap or cross over. but with arbitrary shapes
   vertices are not necessarily ordered according to their angles,
   and crossing over seems very difficult/impractical to avoid.
   so in this sketch, the number of vertices in both shapes
   is arranged in setup() to be equal, and then vertices from 
   the starting shape are simply replaced by vertices from the target
   shape. there will also be the option to order the vertices in both
   shapes so that they begin at roughly the same angle and progress
   either in the same direction going around the shape (i.e. clockwise
   or CCW) or in the opposite direction. probably the most coherent-
   looking transformation will be that of vertices starting roughly 
   at the same angle and progressing in the same direction around
   the shape*/




  if (frameCount-1 <= round(T) ) {
    fc=(float)frameCount-1;

    nnp=nn;
    nn=n*(2/T)*( fc/2 - T*sin(2*PI*fc/T) / (4*PI) );
    /*nn, the number of vertices which have been changed,
     is the integral of a sine squared function whose argument
     is the framecount and whose period is twice the total
     transformation length specified at the top. the biggest
     changes in nn happen in the middle of this time range*/
    int d=round(nn)-round(nnp);
    if ( d > 0 ) {
      for (int i=0; i<d; i++) {
        if (crad.size() > 0) {
          int index=(int)random(crad.size());
          float rt=crad.get(index);
          float at=cangle.get(index);
          crad.remove(index);
          cangle.remove(index);

          for (int j=0; j<r1.length; j++) {
            if (rt == r1[j] && at == a1[j]) {
              if (R[j] == rt && A[j] == at);
              else {
                R[j]=rt;
                A[j]=at;
                break;
              }
            }
          }
        }
      }
    }


    weightR = 2.5 * pow( abs(sin( PI*(fc) / T )), 2);
    /*biggest noise should happen somewhere in the middle of transformation,
     so weight is given by half a period of a sine function. the noise, n,
     is multiplied by this weight below
     */
    weightA = .75 * abs(sin( PI*(fc) / T ));
  }


  background(0);


  fill(255-255*frameCount/T, 0, 0+255*frameCount/T);
  pushMatrix();
  translate(width/2, height/2);

  beginShape();
  for (int i=0; i<R.length; i++) {

    float n=noise(.1*i, frameCount*.015) - .5;
    float rr=R[i]*(1+n*weightR), aa=A[i]*(1+n*weightA);
    vertex(rr*cos(aa), rr*sin(aa));
    //float x=R[i]*cos(A[i]), y=R[i]*sin(A[i]);
    //vertex(x*(1+n*weight), y*(1+n*weight));
  }
  endShape(CLOSE);

  popMatrix();
}



/*function for getting the "origin"
 (average x and y positions of vertices)
 of a PShape*/
float[] getOrigin(PShape sh) {
  int V=sh.getVertexCodes().length;
  float xavg=0, yavg=0;
  for (int i=0; i<V; i++) {
    xavg+=sh.getVertexX(i);
    yavg+=sh.getVertexY(i);
  }
  xavg=xavg/V;
  yavg=yavg/V;
  float[] origin= {
    xavg, yavg
  };
  return origin;
}


/*function for converting X and Y coordinates to
 r and theta coordinates around any specified x0, y0 origin*/
float[] recToPolar(float X, float Y, 
float x0, float y0) {
  //x and y are point coords, x0 and y0 are origin coords
  float x=X-x0, y=Y-y0;
  float r=sqrt(sq(x)+sq(y));
  float a=atan2(y, x);
  float[] rTheta= {
    r, a
  };
  return rTheta;
}

