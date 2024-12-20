/*use this for transforming shapes with a similar number of vertices,
 with the number of vertices peaking in the middle of the transform
 and then being brought back down to its final value. also intial size
 and final size of shape can be different
 
 if nExtra is negative, this can also be used for transforming shapes
 with a large number of vertices, with the number of vertices
 hitting a low in the middle of the transform and then coming back up
 to its final value
 */
 
 //this would be better if i could get
 //perlin noise to return negative values as well
 
float n0=10, n1=30, nExtra=-15;
int num;
float fnum;
float fnumSlope=n0;
float r0=100, r1=150, r=r0;
float T=1500; //time constant tau determines total length of transformation
float a=0;
float weight;

void setup() {
  size(700, 700);
  smooth();
}

void draw() {
  
  
  /*for initial and final shapes with a similar number of vertices
   i could also use a function which goes up and then comes down,
   like sine squared + a linear function which goes from the initial
   number of vertices to the final number and then stops drawing when
   the final number is reached
   */

  if (frameCount-1 <= round(T) ) {
    fnumSlope+=(n1-n0)/T;
    fnum = fnumSlope +
      nExtra*pow( sin ( PI*((float)frameCount-1) / T ), 4 );


    r+=(r1-r0)/T;


    weight = 3*sin( PI*((float)frameCount-1) / T );
    /*biggest noise should happen somewhere in the middle of transformation,
     so weight is given by half a period of a sine function. the noise, n,
     is multiplied by this weight below
     */
  }
  
  fnum=max(fnum, 3);



  num=round(fnum);


  background(204);

  beginShape();

  for (int i=0; i<num+1; i++) {

    float n=noise(.5*(i%num), frameCount*.015) - .3;
    a=2*PI*i/num;

    vertex(width/2+r*cos(a)*(1+n*weight), height/2+r*sin(a)*(1+n*weight));
  }

  endShape();
}

