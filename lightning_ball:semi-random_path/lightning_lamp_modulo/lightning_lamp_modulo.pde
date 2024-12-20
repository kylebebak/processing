float x0, y0, x1, y1;
int nbolts=10;
float rin=50, rout=250;
float[] ain, aout, 
xin, xout, yin, yout, joints;



void setup() {
  size(500, 500);
  smooth();

  ain=new float[nbolts];
  aout=new float[nbolts];
  xin=new float[nbolts];
  xout=new float[nbolts];
  yin=new float[nbolts];
  yout=new float[nbolts];
  joints=new float[nbolts];


  for (int i=0; i<nbolts; i++) {
    ain[i]=random(0, 2*PI);
    joints[i]=random(3, 20);
  }
}



void draw() {
  noStroke();
  fill(0, 100);
  rect(0, 0, width, height);


  for (int i=0; i<nbolts; i++) {
    ain[i]+=random(-PI/30, PI/30);
    aout[i]=ain[i] + PI*( noise( .1*ain[i], frameCount*.005) - .5);


    xin[i]=rin*cos(ain[i]);
    yin[i]=rin*sin(ain[i]);

    float dA=0;
    if (mousePressed) {

      float mA=atan2(mouseY-height/2, mouseX-width/2);
      

      /*the code below loops theta so there is no discontinuity
       along the positive x axis. it is an implementations
       of the modulo operator*/
      if ( abs(mA - aout[i])>PI ) {
        if (mA > aout[i]) mA-=2*PI;
        else mA+=2*PI;
      }

      dA=mA-aout[i];
      dA=random(.9*dA, 1.1*dA);
    }

    xout[i]=rout*cos(aout[i]+dA);
    yout[i]=rout*sin(aout[i]+dA);

    joints[i]+=random(-.25, .25);
    joints[i]=constrain(joints[i], 3, 20);
  }

  translate(width/2, height/2);


  noFill();
  stroke(0, 0, 255);
  strokeWeight(2);
  ellipse(0, 0, 2*rin, 2*rin);
  ellipse(0, 0, 2*rout, 2*rout);
  /*starting coords and target coords
   are xin, yin   and    xout, yout
   they get put in to semi-random path function
   */

  for (int i=0; i<nbolts; i++) semi_random_path(xin[i], yin[i], 
  xout[i], yout[i], random(PI/6, .4*PI), 
  round(joints[i]), color(0, 255*(pow(joints[i], 1/3) / pow(20, 1/3)), 0));

  filter(BLUR);
}



void semi_random_path(float x0, float y0, 
float x1, float y1, float dA, int joints, color C) {

  stroke(C, 50);
  ellipse(x0, y0, 5, 5);
  ellipse(x1, y1, 5, 5);

  strokeWeight(2);
  stroke(C, 100);

  for (int i=0; i<joints-1; i++) {
    float len=dist(x0, y0, x1, y1);
    float a=atan2(y1-y0, x1-x0);
    len=random(len/2, 3*len/2) / (joints-i);
    a=random(a-dA, a+dA);

    float xx=x0+len*cos(a), yy=y0+len*sin(a);
    line(x0, y0, xx, yy);
    x0=xx;
    y0=yy;
  }
  line(x0, y0, x1, y1);
}



/*real modulo operator, not java's remainder operator.
 as i've discovered above it can be implemented in various ways,
 like this or with the absolute value function*/
float mod(float in, float mod) {
  float quotient=in/mod;
  quotient=float(floor(quotient));
  float out=in-mod*quotient;
  return out;
}

