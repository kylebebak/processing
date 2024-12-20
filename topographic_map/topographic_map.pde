PImage img;
int numV=25; //number of vertices per contour
int numC=12; //number of contours at a given site
int numS=15; //number of sites
float R=200;
float a, rr;
float panx=0, pany=0, px=0, py=0;
float W, H;

void setup() {
  size(5000, 4000);
  W=width;
  H=height;
  fill(255, 125);
  smooth();

  for (int k=0; k<numS; k++) {
    float w=random(width/10, 9*width/10), h=random(height/10, 9*height/10);
    float r=random(R/2, 3*R/2);

    //for (int j=1; j<numC+1; j++) {
    for (int j=numC+4; j>=5; j--) {
      beginShape();
      float fj=(float)j;

      for (int i=0; i<numV+3; i++) {

        float n=noise(.5*(i%numV), j*.15, 10*k);
        a=2*PI*i/numV;

        //input r as a function of theta here for ellipses, ovals, other shapes
        //make sure that r(i=numV+1) = r(i=1) for continuity

        rr=r; //this is for a circle

        //these are for an oval
        float d=7;
        if (i<=numV/2+1) rr=r+d*i;
        if (i>numV/2+1) rr=r+(numV+2)*d-d*i;
        if (i==numV+1) rr=r+d;

        //these are for an ellipse
        //float d=7;
        //rr=r+d*abs(sin(a));
        //rr=r+d*abs(cos(a));



        //curveVertex(w+(rr/sqrt(fj))*cos(a)*(.5+.5*n), 
        //h+(rr/sqrt(fj))*sin(a)*(.5+.5*n));

        curveVertex(w+(rr*pow(fj, 3)/pow(numC, 3))*cos(a)*(.5+.5*n), 
        h+(rr*pow(fj, 3)/pow(numC, 3))*sin(a)*(.5+.5*n));
      }
      endShape();
    }
  }

  img=get();

  size(1250, 750);
}

void draw() {
  px+=.05*(panx-px);
  py+=.05*(pany-py);
  if (abs(panx-px)<3) px=panx;
  if (abs(pany-py)<3) py=pany;
  set(-(int)px, -(int)py, img);
}

void mouseDragged() {
  panx+=5*(pmouseX-mouseX);
  pany+=5*(pmouseY-mouseY);
  panx=constrain(panx, 0, W-width);
  pany=constrain(pany, 0, H-height);
}

