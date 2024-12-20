size(600, 600);
smooth();
noStroke();
background(0);
rectMode(CENTER);

float n=1000000;
float u=300;
float G=100;
float a=300-3*G;
float b=300+3*G;
float r;
float x;
float B;
float s;
float i;
int ii;
float j;
int jj;
float ran;
int bin=50;
float binz=50;
float[] bins=new float[bin];

for (i=0; i<=n-1; i=i+1) {
  r=random(0,1);
  x=a+(b-a)*r;
  B=pow(G/2,2)/(pow(x-u,2)+pow(G/2,2));
  s=random(0,1);
  if (B>=s) {
    //fill(127);
    //ellipse(x,height/2,1,1);
    for (j=0; j<=binz-1; j=j+1) {
      if ((x>=j*(b-a)/binz) && (x<(j+1)*(b-a)/binz)) {
        jj=round(j);
        bins[jj]=bins[jj]+1;
      }
    }
  }
}

for (j=0; j<=bin-1; j=j+1) {
  jj=round(j);
  fill(0,255,0);
  ellipse((1+j)*width/(binz+1),bins[jj]*height/(3*n/binz),5,5);
}

//put lorentzian and guassian on same plot
float e=75;
a=300-4*e;
b=300+4*e;
bins=new float[bin];

for (i=0; i<=n-1; i=i+1) {
  r=random(0,1);
  x=a+(b-a)*r;
  B=1/exp(.5*pow(((x-u)/e),2));
  s=random(0,1);
  if (B>=s) {
    //fill(127);
    //ellipse(x,height/2,1,1);
    for (j=0; j<=binz-1; j=j+1) {
      if ((x>=j*(b-a)/binz) && (x<(j+1)*(b-a)/binz)) {
        jj=round(j);
        bins[jj]=bins[jj]+1;
      }
    }
  }
}

for (j=0; j<=bin-1; j=j+1) {
  jj=round(j);
  fill(0,0,255);
  ellipse((1+j)*width/(binz+1),bins[jj]*height/(3*n/binz),5,5);
}

fill(255,0,0);
rect(u,height/2,1,height);

