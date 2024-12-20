//changed to leap-frog integration to conserve energy
int nume=4;
//number of orbiters
float d=12;
//maximum diameter of orbiters
float K=500000;
//K determines strength of interactions. if dt is small, K must be big
//or else the orbiter won't move. but making K big makes errors big
int counter=5000;
//counts number of operations between drawing each frame
float dt=.00005;
//determines "length" of each time step
//because error goes like dt^2, small dt will make leapfrog very accurate
float compare;

//side note: framerate determines speed at which things are drawn
//to make this look good, one would have to have a very small dt,
//and a _very large_ frame rate. because we can't have a frame rate
//of, say, 10000, we can have the program run through a bunch
//of iterations, like 100, between drawing each frame. this way 
//K can be small even if dt is small, hence small errors

float px;
float py;
//position of anchor
float[] x= new float[nume];
float[] y= new float[nume];
//position arrays for orbiters
float[] vx= new float[nume];
float[] vy= new float[nume];
//velocity arrays for orbiters
float[] ax= new float[nume];
float[] ay= new float[nume];
//acceleration arrays for orbiters
float[][] colors=new float[nume][3];
float[] sizes=new float[nume];
//if notebook is being used to make a solar system, these
//are the colors and sizes of the planets orbiting the sun


void setup() 
{
  size(1000, 800);
  px=width/2;
  py=height/2;

  //for (int i=0; i<nume; i++) {
    //ex[i] = random(.2*width,.8*width);
    //x[i]=width/2;
    //ey[i] = random(.2*height,.8*height);
    //y[i]= random(.75, 1.3)*(height/4);
    //vx[i] = random(65, 110);
    //vy[i] = random(-5,5);
    //vy[i]= 0;
  //}
  x[0]=500;
  y[0]=500;
  vx[0]=80;
  vy[0]=0;
  
  x[1]=500;
  y[1]=300;
  vx[1]=-40;
  vy[1]=0;
  
  x[2]=600;
  y[2]=400;
  vx[2]=0;
  vy[2]=-40;
  
  x[3]=400;
  y[3]=400;
  vx[3]=0;
  vy[3]=40;
  compare=max(y);

  for (int i=0; i<nume; i++) {
    for (int j=0; j<3; j++) {
      colors[i][j]=random(0, 255);
    }
  }

  for (int i=0; i<nume; i++) {
    sizes[i]=random(d/3, d);
    //change to random(d,d) to make all orbiters equal size
  }

  frameRate(50);
  ellipseMode(CENTER);
  smooth();
  noStroke();
}

void draw()
{
  for (int k=0; k<counter; k++) {

    for (int i=0; i<nume; i++) {
      //change position first
      x[i]+=dt*vx[i];
      y[i]+=dt*vy[i];
    }

    for (int i=0; i<nume; i++) {
      for (int j=0; j<nume; j++) {
        if (j!=i) {
          //change acceleration with new position
          ax[i]=-K*(x[i]-x[j])/pow(dist(x[i], y[i], x[j], y[j]), 3);
          ay[i]=-K*(y[i]-y[j])/pow(dist(x[i], y[i], x[j], y[j]), 3);
        }
      }
    }

    for (int i=0; i<nume; i++) {
      //change velocity with new acceleration
      vx[i]+=dt*ax[i];
      vy[i]+=dt*ay[i];
    }
  }

  background(0);
  //fill(255, 0, 0);
  //ellipse(px, py, 4*d, 4*d);
  //anchor is 4 times wider than orbiters, and it's red!
  fill(255, 255, 255);
  ellipse(width/2, compare, 2, 2);
  //to see if orbits closest to anchor are precessing

  for (int i=0; i<nume; i++) {
    fill(colors[i][0], colors[i][1], colors[i][2]);
    ellipse(x[i], y[i], sizes[i], sizes[i]);
  }
}

