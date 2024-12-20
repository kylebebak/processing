//has damping to make things more tolerable
//runge-kutta integration, energy _not_ conserved
int nume=36;
//make sure number of nuclei is a perfect square
//rp is square root of number of nuclei
int rp=6;
//z is number of protons per nucleus
float z=1;
float d=3;
float K=100;
float kd=.05;
//damping coefficient

float[][] px= new float[rp][rp];
float[][] py= new float[rp][rp];
float[] ex= new float[nume];
float[] ey= new float[nume];
float[] vx= new float[nume];
float[] vy= new float[nume];
float[] ax= new float[nume];
float[] ay= new float[nume];
float[] axe= new float[nume];
float[] aye= new float[nume];


void setup() 
{
  size(650, 650);
  for(int j=0; j<rp; j++) {
    for(int i=0; i<rp; i++) {
      px[i][j]=(i+1)*width/(rp+1);
      py[i][j]=(j+1)*height/(rp+1);
    }
  }
  
  for(int i=0; i<nume; i++) {
    ex[i] = random(0,width);
    ey[i] = random(0,height);
    vx[i] = random(-1,1);
    vy[i] = random(-1,1);
  }
  frameRate(50);
  ellipseMode(CENTER);
  smooth();
  noStroke();
}

void draw() 
{
  background(0);
  fill(255,90,0);
  for(int j=0; j<rp; j++) {
    for(int i=0; i<rp; i++) {
      ellipse(px[i][j],py[i][j],3*d,3*d);
    }
  }
  
  for(int i=0; i<nume; i++) {
    //initialize accelerations
    ax[i]=0;
    ay[i]=0;
    axe[i]=0;
    aye[i]=0;
    //electron-nuclei interactions
    for(int j=0; j<rp; j++) {
      for(int k=0; k<rp; k++) {
        ax[i]=ax[i]-z*K*(ex[i]-px[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),3);
        ay[i]=ay[i]-z*K*(ey[i]-py[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),3);
      }
    }
    //electron-electron interactions
      for(int j=0; j<nume; j++) {
        if(j!=i) {
          axe[i]=axe[i]+K*(ex[i]-ex[j])/pow(dist(ex[i],ey[i],ex[j],ey[j]),3);
          aye[i]=aye[i]+K*(ey[i]-ey[j])/pow(dist(ex[i],ey[i],ex[j],ey[j]),3);
        }
      }
      
    vx[i] = vx[i]+ax[i]+axe[i]-kd*vx[i];
    vy[i] = vy[i]+ay[i]+aye[i]-kd*vy[i];
    //damping with last term in each sum
    ex[i] += vx[i];
    ey[i] += vy[i];
    
    //looping and slowing (necessary but not realistic)
    if((ex[i]>width) || (ex[i]<0) || (ey[i]>height) || (ey[i]<0)) {
      vx[i]=vx[i]/2;
      vy[i]=vy[i]/2;
    }
    if(ex[i]>width) {
      ex[i]=ex[i]-width;
    }
    if(ex[i]<0) {
      ex[i]=ex[i]+width;
    }
    if(ey[i]>height) {
      ey[i]=ey[i]-height;
    }
    if(ey[i]<0) {
      ey[i]=ey[i]+height;
    }
    
    fill(135,190,255);
    ellipse(ex[i],ey[i],d,d);
  }
}
