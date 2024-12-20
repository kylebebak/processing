//right, up, left, down...
//% is modulo, e.g. 5%20=5, and 35%20=15

int num=14;
float[] side=new float[num];
//side is the side length of each square
float[] x=new float[num];
float[] y=new float[num];
//x and y are arrays with the x and y coordinates of the top corner
//of each square

size(1200, 800);
stroke(255, 0, 0);
smooth();
background(0);
fill(127);

side[0]=2;
side[1]=2;
x[0]=.3*width;
y[0]=.265*height;
rect(x[0], y[0], side[0], side[0]);
x[1]=x[0]+side[0];
y[1]=y[0];
rect(x[1], y[1], side[1], side[1]);

for (int i=2; i<num; i++) {
  side[i]=side[i-1]+side[i-2];

  if (i%2==0) {
    int t=i/2;
    if (t%2==1) {
      x[i]=x[i-2];
      y[i]=y[i-1]-side[i];
    } 
    else {
      x[i]=x[i-1];
      y[i]=y[i-1]+side[i-1];
    }
  }
  //going up, going down

  if (i%2==1) {
    int t=(i-1)/2;
    if (t%2==1) {
      x[i]=x[i-1]-side[i];
      y[i]=y[i-1];
    } 
    else {
      x[i]=x[i-1]+side[i-1];
      y[i]=y[i-2];
    }
  }
  //going left, going right

  rect(x[i], y[i], side[i], side[i]);
}

//for drawing arc in green
//arc(center_x, center_y, 2*width, 2*height, start angle, start angle + angle subtended by arc)

float[] xc=new float[num];
float[] yc=new float[num];
float[] start=new float[num];
float[] end=new float[num];
//start and end are for angles, xc and yc are for centers or arcs

xc[0]=x[0]+side[0];
yc[0]=y[0];
start[0]=PI/2;
end[0]=PI;

PFont f;
f=loadFont("Courier-14.vlw");

for (int i=1; i<num; i++) {

  if (i%4==1) {
    xc[i]=x[i];
    yc[i]=y[i];
    start[i]=0;
    end[i]=PI/2;
  }
  if (i%4==2) {
    xc[i]=x[i];
    yc[i]=y[i-1];
    start[i]=3*PI/2;
    end[i]=2*PI;
  }
  if (i%4==3) {
    xc[i]=x[i-1];
    yc[i]=y[i-2]+side[i-2];
    start[i]=PI;
    end[i]=3*PI/2;
  }
  if (i%4==0) {
    xc[i]=x[i-2]+side[i-2];
    yc[i]=y[i];
    start[i]=PI/2;
    end[i]=PI;
  }

    if (side[i]>50) {
      fill(0,0,255);
      text(nf(side[i], 1, 0), x[i]+.4*side[i], y[i]+.4*side[i]);
      text(nf(i+1,1,0), x[i]+.4*side[i], y[i]+.4*side[i]+15);
  }
}

stroke(0, 255, 0);
noFill();

for (int i=1; i<num; i++) {
    arc(xc[i], yc[i], 2*side[i], 2*side[i], start[i], end[i]);
}

