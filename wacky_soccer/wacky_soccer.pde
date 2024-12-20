//to make this game for 2 players, i could put the goals
//on opposite ends, and then put the jailbreak circles
//on the sides. i could also make the field bigger. there
//would be red balls and white balls, with each player
//trying to get all his balls into the goal
int swarm=15;
int a=0;
int b;
int c=0;
int d=0;
int e;
int oneoverchance=4;
float newx;
float newy;
float vratio;
float dvratio;

int dim=500;
float diameter=2;
float t=3;

float vmax=2;
float dvmax=.65;
float L=75;
float K=2;

float[] x;
float[] y;
float[] vx;
float[] vy;
float[] dvx;
float[] dvy;

void setup() {
  size(dim,dim);
  frameRate(50);
  smooth();
  noCursor();
  rectMode(CENTER);
  ellipseMode(CENTER);
  
  x=new float[swarm];
  y=new float[swarm];
  vx=new float[swarm];
  vy=new float[swarm];
  
  for (int i=0; i<=swarm-1; i=i+1) {
    x[i]=random(0,width);
    y[i]=random(0,height);
    vx[i]=random(-vmax,vmax);
    vy[i]=random(-vmax,vmax);
  }
}

void draw() {
  background(0);
  
  a=a+1;
  stroke(255/pow(a,.5));
  fill(0);
  ellipse(mouseX,mouseY,2*L,2*L);
  line(width/2-width/15,2*height/15,width/2+width/15,2*height/15);
  stroke(255);
  ellipse(width/2,4*height/5,width/15,height/15);
  noStroke();
  if (a==100) {
    a=0;
  }
  if (d!=0) {
    d=d+1;
    noStroke();
    fill(127);
    rect(4*width/5,9*height/10,width*d/(5*500),5);
  }
  if (d==500) {
    d=0;
  }
  
  if (c!=0) {
    c=c+1;
    stroke(2.5*c);
    fill(0);
    ellipse(newx,newy,width/50,height/50);
  }
  if (c==100) {
    c=0;
    if (e==0) {
      for (int i=0; i<=swarm-1; i=i+1) {
        x[i]=newx;
        y[i]=newy;
      }
    } else {
      x[b]=newx;
      y[b]=newy;
    }
  }
  
  fill(127);
  ellipse(mouseX,mouseY,2*diameter,2*diameter);
  
  rect(width/2,height/15,width/7.5,t);
  rect(width/2-width/15,height/15+height/30,t,height/15);
  rect(width/2+width/15,height/15+height/30,t,height/15);
  
  dvx=new float[swarm];
  dvy=new float[swarm];
  
  for (int i=0; i<=swarm-1; i=i+1) {
    fill(255);
    ellipse(x[i],y[i],diameter,diameter);
  }
  
  for (int i=0; i<=swarm-1; i=i+1) {
    if (dist(x[i],y[i],mouseX,mouseY)<=L) {
      if (dist(x[i],y[i],mouseX,mouseY)==0) {
        dvx[i]=0;
      } else {
        dvx[i]=K*(x[i]-mouseX)/pow(dist(x[i],y[i],mouseX,mouseY),2);
      }
      
      if (dist(x[i],y[i],mouseX,mouseY)==0) {
        dvy[i]=0;
      } else {
        dvy[i]=K*(y[i]-mouseY)/pow(dist(x[i],y[i],mouseX,mouseY),2);
      }  
    }
  }
  
  for (int i=0; i<=swarm-1; i=i+1) {
    if ((pow(dvx[i],2)+pow(dvy[i],2))>pow(dvmax,2)) {
      dvratio=dvmax/pow(pow(dvx[i],2)+pow(dvy[i],2),.5);
      dvx[i]=dvratio*dvx[i];
      dvy[i]=dvratio*dvy[i];
    }
    vx[i]=vx[i]+dvx[i];
    vy[i]=vy[i]+dvy[i];
    
    if ((pow(vx[i],2)+pow(vy[i],2))>pow(vmax,2)) {
      vratio=vmax/pow(pow(vx[i],2)+pow(vy[i],2),.5);
      vx[i]=vratio*vx[i];
      vy[i]=vratio*vy[i];
    }
    
    if ((mousePressed==true) && (d==0)) {
      if (dist(x[i],y[i],mouseX,mouseY)<=L) {
        if (dist(x[i],y[i],mouseX,mouseY)==0) {
          vx[i]=0;
          vy[i]=0;
        } else {
          vx[i]=vmax*(x[i]-mouseX)/dist(x[i],y[i],mouseX,mouseY);
          vy[i]=vmax*(y[i]-mouseY)/dist(x[i],y[i],mouseX,mouseY);
        }
      }
    }
    
    x[i]=x[i]+vx[i];
    y[i]=y[i]+vy[i];
    
    if ((x[i]>(width/2-width/15-1)) && (x[i]<(width/2+width/15+1))) {
      if ((y[i]>(height/15-t/2)) && (y[i]<(height/15+t/2))) {
        if (vy[i]>=0) {
            y[i]=height/15-t/2;
        }
          
        if (vy[i]<0) {
            y[i]=height/15+t/2;
        }
          
        vy[i]=-vy[i];
      }
    }
    
    if ((x[i]>(width/2-width/15-1)) && (x[i]<(width/2+width/15+1))) {
      if ((y[i]>(2*height/15-t/2)) && (y[i]<(2*height/15+t/2))) {
        if (vy[i]>0) {
            y[i]=2*height/15-t/2;
            vy[i]=-vy[i];
        }
      }
    }
    
    if ((y[i]>(height/15-1)) && (y[i]<(2*height/15+1))) {
      if ((x[i]>(width/2-width/15-t/2)) && (x[i]<(width/2-width/15+t/2))) {
        if (vx[i]>=0) {
            x[i]=width/2-width/15-t/2;
        }
          
        if (vx[i]<0) {
            x[i]=width/2-width/15+t/2;
        }
          
        vx[i]=-vx[i];
      }
    }
    
    if ((y[i]>(height/15-1)) && (y[i]<(2*height/15+1))) {
      if ((x[i]>(width/2+width/15-t/2)) && (x[i]<(width/2+width/15+t/2))) {
        if (vx[i]>=0) {
            x[i]=width/2+width/15-t/2;
        }
          
        if (vx[i]<0) {
            x[i]=width/2+width/15+t/2;
        }
          
        vx[i]=-vx[i];
      }
    }
      
    if (x[i]>width) {
      x[i]=x[i]-width;
    }
    if (x[i]<0) {
      x[i]=x[i]+width;
    }
    
    if (y[i]>height) {
      y[i]=y[i]-height;
    }
    if (y[i]<0) {
      y[i]=y[i]+height;
    }
    
    if ((c==0) && (dist(x[i],y[i],width/2,4*height/5)<width/30)) {
      b=(int)random(0,swarm-1);
      e=(int)random(0,oneoverchance-1);
      newx=random(0,width);
      newy=random(height/4,3*height/4);
      c=c+1;
    }
  }
  if ((mousePressed==true) && (d==0)) {
    d=d+1;
  }
}
