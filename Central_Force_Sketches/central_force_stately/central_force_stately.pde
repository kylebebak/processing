//changed to leap-frog integration to conserve energy
int nume=3000;
//number of orbiters
float d=6;
//max diameter of orbiters
float K=180;
//K determines strength of interactions. if dt is small, K must be big
//or else the electron won't move. but making K big makes errors big
int counter=2;
//counts number of operations between drawing each frame
float dt=.5;
//determines "length" of each time step
//because error goes like dt^2, small dt will make leapfrog very accurate.
//with K=180, v0=random(.55,1.05), and dt=.005, the orbit is perfectly
//reversible, i.e. changing r from positive to negative will return all
//orbiters to their initial position
PFont f;
//for drawing K in the image

//note--K, dt, and (px,py), the center of attraction, can be changed
//in real time with "-, =" "n, m" and "w, a, s, d" respectively

//side note: framerate determines speed at which things are drawn
//to make this look good, one would have to have a very small dt,
//and a _very large_ frame rate. because we can't have a frame rate
//of, say, 10000, we can have the program run through a bunch
//of iterations, like 100, between drawing each frame. this way 
//K can be small even if dt is small, hence small errors

float px;
float py;
//position of proton
float[] ex= new float[nume];
float[] ey= new float[nume];
//position arrays for electron
float[] vx= new float[nume];
float[] vy= new float[nume];
//velocity arrays for electrons
float[] ax= new float[nume];
float[] ay= new float[nume];
//acceleration arrays for electrons
float[][] colors=new float[nume][3];
float[] sizes=new float[nume];
//if notebook is being used to make a solar system, these
//are the colors and sizes of the planets orbiting the sun

String wasd = "WASD to move center";
String dK = "-, = to change K";
String mn = "n, m to change dt";
String r = "r to reverse";


void setup() 
{
  
  size(1000, 800);
  
  f=loadFont("Courier-20.vlw");
  
  px=width/2;
  py=height/2;
  for(int i=0; i<nume; i++) {
    //ex[i] = random(.2*width,.8*width);
    ex[i]=width/2;
    //ey[i] = random(.2*height,.8*height);
    ey[i]= random(.7,1.3)*(height/4);
    vx[i] = random(.55,1.05);
    //vy[i] = random(-5,5);
    vy[i]= 0;
  }
  
  
  for(int i=0; i<nume; i++) {
    for(int j=0; j<3; j++) {
      colors[i][j]=random(0,255);
    }
  }
  
  for(int i=0; i<nume; i++) {
    sizes[i]=random(d/3,d);
    //change to random(d,d) to make all orbiters equal size
  }
  
  
  frameRate(30);
  ellipseMode(CENTER);
  smooth();
  noStroke();
}

void draw()
{
  
  if (keyPressed) {
    
    if (key == '=') {
      K+=.5;
    }
    if (key == '-') {
      K-=.5;
    }
    //increase or decrease K
    if (key == 'm') {
      dt+=.1;
    }
    if (key == 'n') {
      dt-=.1;
    }
    if (key == 'r') {
      dt=-dt;
    }
    //increase or decrease dt, reverse dt
    if (key == 'a') {
      px-=1;
    }
    if (key == 'd') {
      px+=1;
    }
    if (key == 'w') {
      py-=1;
    }
    if (key == 's') {
      py+=1;
    }
    //move center around
  }
  
for (int k=0; k<counter; k++) {
    
    for(int i=0; i<nume; i++) {
    //change position first
      ex[i]+=dt*vx[i];
      ey[i]+=dt*vy[i];
    }
    
    for(int i=0; i<nume; i++) {
      //change acceleration with new position
      ax[i]=-K*(ex[i]-px)/pow(dist(ex[i],ey[i],px,py),3);
      ay[i]=-K*(ey[i]-py)/pow(dist(ex[i],ey[i],px,py),3);
    }
    
    for(int i=0; i<nume; i++) {
    //change velocity with new acceleration
      vx[i]+=dt*ax[i];
      vy[i]+=dt*ay[i];
    }
}

  background(0);
  fill(255,255,255);
  ellipse(px,py,2,2);
  
    
  for(int i=0; i<nume; i++) {
    fill(colors[i][0],colors[i][1],colors[i][2]);
    ellipse(ex[i],ey[i],sizes[i],sizes[i]);
  } 
  
  String Kval = "K = " + nf(K,1,1);
  String dtval = "dt = " + nf(dt,1,1); 
    textFont(f,20);
    fill(255,255,255);
    text(Kval,20,25);
    text(dtval,20,50);
    text(wasd,width-250,height-150);
    text(dK,width-250,height-125);
    text(mn,width-250,height-100);
    text(r,width-250, height-75);
}
