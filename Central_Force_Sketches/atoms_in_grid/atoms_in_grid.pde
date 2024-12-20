int rp=4;
//rp is square root of number of nuclei. for example,
//if rp=3, there will be 3 rows of 3 nuclei each
int z=3;
//z is number of protons and electrons per atom
float K=150;
//interaction strength
float K2=15000;
//very strong short-length repulsive force
float d=3;
//diameter of electrons
float dt=.02;
//length of time steps
int counter=20;
//counts number of operations between drawing each frame
float bound=0;
//bound is a fraction that allows the electrons to go
//"bound" beyond the limits of the screen before they are looped
//to give electrons which haven't been shot off really quickly
//a chance to come back before looping them and killing their velocity
float sep=4.5;
//sep prevents electrons from getting within this distance of the nuclei.
//this keeps the integration scheme more accurate
int nume=rp*rp*z;
//number of electrons in total, this is equal to number of nuclei times z
int nump=rp*rp;
//number of nuclei in total
float sign(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 1;
}


float[][] px= new float[rp][rp];
float[][] py= new float[rp][rp];
float[] Px=new float[nump];
float[] Py=new float[nump];
float[] prx=new float[nume];
float[] pry=new float[nume];
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
  size(700, 700);
  for(int j=0; j<rp; j++) {
    for(int i=0; i<rp; i++) {
      px[i][j]=(2*i+1)*width/(2*rp);
      py[i][j]=(2*j+1)*height/(2*rp);
    }
  }
  
  //i need to change these 2 dimensional arrays for nucleus positions
  //to a one dimensional array
 
  for(int j=0; j<rp; j++) {
    for(int i=0; i<rp; i++) {
      Px[j*rp+i]=px[i][j];
      Py[j*rp+i]=py[i][j];
    }
  }
  
  //so, now the nuclei are listed in order, their number is
  //Pn=rp*(row-1) + (column-1)
  
  for(int j=0; j<z; j++) {
    for(int i=0; i<nump; i++) {
    prx[j*nump+i] = Px[i];
    pry[j*nump+i] = Py[i];
    }
  }
  
  for(int j=0; j<z; j++) {
    for(int i=0; i<nump; i++) {
    ex[j*nump+i] = Px[i];
    ey[j*nump+i] = Py[i]+pow(-1,j)*height/((3+j)*rp);
    vx[j*nump+i] = pow(-1,j)*random(1.5,2.5);
    vy[j*nump+i] = random(0,0);
    }
  }
  
  //now the electrons and protons are listed in order, 1 through Pn for z = 1,
  //Pn + 1 through 2*Pn for z=2, etc...
  
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
  
  for (int m=0; m<counter; m++) {
  
    for(int i=0; i<nume; i++) {
    //change position first, initialize accelerations
      ax[i]=0;
      ay[i]=0;
      axe[i]=0;
      aye[i]=0;
      ex[i]+=dt*vx[i];
      ey[i]+=dt*vy[i];
    }
    
    //before calculating interactions, we must keep electrons 
    //away from nuclei if they have gotten to close--if they get too close 
    //the integration fails and they shoot off like pinballs because
    //dt is bigger than than 1/w, one divided by the orbital frequency
    for (int i=0; i<nume; i++) {
      for (int j=0; j<nump; j++) {
        if (dist(ex[i],ey[i],Px[j],Py[j])<sep) {
          
          if (abs(ex[i]-Px[j])<=abs(ey[i]-Py[j])) {
            ex[i]=Px[j]+sign(ex[i]-Px[j])*25;
            ey[i]=Py[j];
            vx[i]=0;
            vy[i]=.5*sign(vy[i])*pow(pow(vx[i],2)+pow(vy[i],2),.5);
          } else {
            ex[i]=Px[j];
            ey[i]=Py[j]+sign(ey[i]-Py[j])*25;
            vx[i]=.5*sign(vx[i])*pow(pow(vx[i],2)+pow(vy[i],2),.5);
            vy[i]=0;
          }
          
        }
      }
    }
    
    //electron-nuclei interactions
  for(int i=0; i<nume; i++) {
    for(int j=0; j<rp; j++) {
      for(int k=0; k<rp; k++) {
        ax[i]+=-z*K*(ex[i]-px[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),3);
        ax[i]+=K2*(ex[i]-px[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),5);
        ay[i]+=-z*K*(ey[i]-py[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),3);
        ay[i]+=K2*(ey[i]-py[k][j])/pow(dist(ex[i],ey[i],px[k][j],py[k][j]),5);
      }
    }
  }
    
    //electron-electron interactions
    for(int i=0; i<nume; i++) {
      for(int j=0; j<nume; j++) {
        if(j!=i) {
          axe[i]+=K*(ex[i]-ex[j])/pow(dist(ex[i],ey[i],ex[j],ey[j]),3);
          aye[i]+=K*(ey[i]-ey[j])/pow(dist(ex[i],ey[i],ex[j],ey[j]),3);
        }
      }
    }
     
    for(int i=0; i<nume; i++) {
    vx[i]+=dt*ax[i]+dt*axe[i];
    vy[i]+=dt*ay[i]+dt*aye[i];
    }
    
    //replacing electrons with their original protons if they go out of bounds,
    //or just slowing them down and looping them
    for(int i=0; i<nume; i++) {
    
    //if((ex[i]>width*(1+bound)) || (ex[i]<-width*bound) || (ey[i]>height*(1+bound)) || (ey[i]<-height*bound)) {
      //ex[i]=prx[i];
      //ey[i]=pry[i]+height/(rp*random(2,4));
      //vx[i]=random(8,12);
      //vy[i]=0;
    //}
   
    if(ex[i]>width*(1+bound)) {
      ex[i]=0;
      vx[i]=vx[i]/2;
      vy[i]=vy[i]/2;
    }
    if(ex[i]<-width*bound) {
      ex[i]=width;
      vx[i]=vx[i]/2;
      vy[i]=vy[i]/2;
    }
    if(ey[i]>height*(1+bound)) {
      ey[i]=0;
      vx[i]=vx[i]/2;
      vy[i]=vy[i]/2;
    }
    if(ey[i]<-height*bound) {
      ey[i]=height;
      vx[i]=vx[i]/2;
      vy[i]=vy[i]/2;
    }
    }
    
    
  }
    
   for(int i=0; i<nume; i++) { 
    fill(135,190,255);
    ellipse(ex[i],ey[i],d,d);
  }
  
  //fill(255,0,0);
  //ellipse(width/2, height/4, 2,2);
  //a reference to check if there's precession or not
  
}
