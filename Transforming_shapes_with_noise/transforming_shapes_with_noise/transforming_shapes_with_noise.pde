float n0=4, n1=50;
int num;
float fnum=n0;
float T=200; //time constant tau determines length of transformation
float a=0, r=150;

void setup() {
  size(700, 700);
  smooth();
}

void draw() {

  fnum+=(n1-fnum)/T;
  /*number of vertices drops from initial number to final number
   like a decaying exponential
   */



  /*for initial and final shapes with a similar number of vertices
   i could also use a function which goes up and then comes down,
   like sine squared + a linear function which goes from the initial
   number of vertices to the final number and then stops drawing when
   the final number is reached
   */


  float weight=3*sin(PI*abs(fnum-n0)/abs(n1-n0));
  /*biggest noise should happen somewhere in the middle of transformation,
   so weight is given by half a period of a sine function. the noise, n,
   is multiplied by this weight below
   */

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

