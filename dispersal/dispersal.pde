int r1=16;
int r2=16;
//r1*r2 is total number of squares
int rx;
int ry;
int k1;
int k2;
//k values used for drawing creatures at end of each draw loop
int barren=20;
int counter=150;
int count=counter+1;
//barren is number of gray squares that are barren, i.e. that don't support life
//counter determines how often barren sites are changed
float p=.06;
int pm=round(1/p);
float f1=.5;
float f2=.5;
float chance=.13;
//p, f, and chance must all be on interval [0,1]
//p is probability of successfully dispersing, implemented here as a fraction
//f values are fractions of offspring that disperse for each team, they can
//be changed in real time with 9, 0 and o, p
//chance is chance that a given square will expire at end of round
float rate=1.5;
//reproduction rate, if f=.5 and r=1, then the population at a given
//will increase to 4 and stay constant after that. so, i've set r to 1.5
float cap1=50;
float cap2=12;
//cap is the carrying capacity of each site, cap1 and cap2 allow 2 species
//to exist at a square even if one is much more numerous than the other
float rad;
float a;
float b;
float closeness=2;
//closeness determines how closely drawn creatures at a given square will be
//it doesn't affect "gameplay", it's just visual
int res=400;

float resf=res;
//for drawing a graph of their respective populations in real time
boolean toggleGraph;
//for toggling graph on and off
boolean toggleCreatures=true;

PFont f;
//0, 9 and p, o, to increase and decrease f1 and f2
//1, 2 to add more of species 1 or more of species 2

float[][] sx= new float[r1][r2];
float[][] sy= new float[r1][r2];
float[][] N1= new float[r1][r2];
float[][] N2= new float[r1][r2];
int[][] bar= new int[r1][r2];

float[] s1a=new float[res];
float[] s2a=new float[res];

void setup() 
{
  size(1000, 750);
  frameRate(15);
  rectMode(CENTER);

  f=loadFont("Courier-16.vlw");

  for (int j=0; j<r2; j++) {
    for (int i=0; i<r1; i++) {
      sx[i][j]=(i+1)*width/(r1+1);
      sy[i][j]=(j+1)*height/(r2+1);
    }
  }
}

void draw() {  
  background(0);
  noStroke();

  count+=1;
  if (count>counter) {
    for (int j=0; j<r2; j++) {
      for (int i=0; i<r1; i++) {
        bar[i][j]=0;
      }
    }
    count=0;
    for (int i=0; i<barren; i++) {
      bar[(int)random(0, r1)][(int)random(0, r2)]=1;
    }
  }
  //makes new barren squares every set number of frames

  if (keyPressed) {
    if (key == '1') {
      rx=floor(constrain(mouseX, 1, width-1)*r1/width);
      ry=floor(constrain(mouseY, 1, height-1)*r2/height); 
      N1[rx][ry]+=2;
    }
    if (key == '2') {
      rx=floor(constrain(mouseX, 1, width-1)*r1/width);
      ry=floor(constrain(mouseY, 1, height-1)*r2/height); 
      N2[rx][ry]+=2;
    }
    if (key == '0') {
      f1+=.005;
    }
    if (key == '9') {
      f1-=.005;
    }
    if (key == 'p') {
      f2+=.005;
    }
    if (key == 'o') {
      f2-=.005;
    }
    if (f1<.1) {
      f1=.1;
    }
    if (f1>.9) {
      f1=.9;
    }
    if (f2<.1) {
      f2=.1;
    }
    if (f2>.9) {
      f1=.9;
    }
  }
  //sets number of creatures in given square to 1 at square where mouse is placed


  float[][] NN1= new float[r1][r2];
  float[][] NN2= new float[r1][r2];
  //these NNs are temporary arrays used for adding creatures that disperse
  //to new squares, they prevent creatures from dispersing to new squares
  //and either reproducing there or dispersing again in the same round. 
  //they are used again to avoid asymmetry during normalization of squares exceeding 
  //capped population

  for (int j=0; j<r2; j++) {
    for (int i=0; i<r1; i++) {
      float n1=0;
      int e1=floor(f1*N1[i][j]);
      float e1f=e1;
      //explorers from group 1 leaving square
      for (int k=0; k<e1; k++) {
        int t=(int)random(1, pm);
        if (t==1) {
          n1+=1;
        }
      }
      float n2=0;
      int e2=floor(f2*N2[i][j]);
      float e2f=e2;
      //explorers from group 2 leaving square
      for (int k=0; k<e2; k++) {
        int t=(int)random(1, pm);
        if (t==1) {
          n2+=1;
        }
      }
      N1[i][j]-=e1f;
      N1[i][j]+=rate*N1[i][j];
      N2[i][j]-=e2f;
      N2[i][j]+=rate*N2[i][j];
      //in these steps here, reproduction and dispersal at a give square happen
      //first is dispersal, and then reproduction, i.e., creatures can't 
      //reproduce at a given square and disperse in the same round

      if (i+1<r1) {
        NN1[i+1][j]+=round(.25*n1);
        NN2[i+1][j]+=round(.25*n2);
      }
      if (i-1>=0) {
        NN1[i-1][j]+=round(.25*n1);
        NN2[i-1][j]+=round(.25*n2);
      }
      if (j+1<r2) {
        NN1[i][j+1]+=round(.25*n1);
        NN2[i][j+1]+=round(.25*n2);
      }
      if (j-1>=0) {
        NN1[i][j-1]+=round(.25*n1);
        NN2[i][j-1]+=round(.25*n2);
      }
    }
  }
  //NN1 and NN2 are used so that so that creatures can't spread and then 
  //breed or be born and then spread in the same round. numbers are rounded
  //so that a small fraction of one disperser can't arrive and begin 
  //to colonize a square. this places more importance on the value of cap2

    for (int j=0; j<r2; j++) {
    for (int i=0; i<r1; i++) {
      N1[i][j]+=NN1[i][j];
      //int tempi1=floor(N1[i][j]);
      //float tempf1=tempi1;
      //N1[i][j]=tempf1;
      N2[i][j]+=NN2[i][j];
      //int tempi2=floor(N2[i][j]);
      //float tempf2=tempi2;
      //N2[i][j]=tempf2;
      //creatures that dispersed to other squares are now added
      //to these other squares. also, creatures at each square can
      //be floored here, but i don't feel it's necessary
      NN1[i][j]=N1[i][j];
      NN2[i][j]=N2[i][j];
      if ((N1[i][j]<cap1) && (N2[i][j]<cap1)) {
        if (N1[i][j]+N2[i][j]>cap1+cap2) {
          NN1[i][j]=(cap1+cap2)*N1[i][j]/(N1[i][j]+N2[i][j]);
          NN2[i][j]=(cap1+cap2)*N2[i][j]/(N1[i][j]+N2[i][j]);
        }
      } 
      else {
        if (NN1[i][j]>cap1) {
          NN1[i][j]=cap1;
          if (NN2[i][j]>cap2) {
            NN2[i][j]=cap2;
          }
        }
        if (NN2[i][j]>cap1) {
          NN2[i][j]=cap1;
          if (NN1[i][j]>cap2) {
            NN1[i][j]=cap2;
          }
        }
      }
      N1[i][j]=NN1[i][j];
      N2[i][j]=NN2[i][j];

      if (random(0, 1)<chance) {
        N1[i][j]=0;
        N2[i][j]=0;
      }

      if (bar[i][j]==1) {
        N1[i][j]=0;
        N2[i][j]=0;
        fill(100, 100, 100);
        rect((i+1)*width/(r1+1), (j+1)*height/(r2+1), width/(r1+1), height/(r2+1));
      }
      //draw in barren squares

      if (toggleCreatures) {
        k1=floor(N1[i][j]);
        fill(0, 200, 200);
        for (int m=0; m<k1; m++) {
          rad=random(-.5, .5)*width/(r1+1);
          a=random(0, 2*PI);
          b=random(0, 1);
          ellipse(sx[i][j]+pow(b, closeness)*rad*cos(a), sy[i][j]+pow(b, closeness)*rad*sin(a), 3, 3);
        }

        k2=floor(N2[i][j]);
        fill(255, 0, 0);
        for (int m=0; m<k2; m++) {
          rad=random(-.5, .5)*width/(r1+1);
          a=random(0, 2*PI);
          b=random(0, 1);
          ellipse(sx[i][j]+pow(b, closeness)*rad*cos(a), sy[i][j]+pow(b, closeness)*rad*sin(a), 3, 3);
        }
        //draw in both species at each square
      }
    }
  }

  float s1=0;
  float s2=0;
  for (int j=0; j<r2; j++) {
    for (int i=0; i<r1; i++) {
      s1+=N1[i][j];
      s2+=N2[i][j];
    }
  }
  //sum up total number ot species 1 and species 2 for continuous display

  for (int i=res-1; i>0; i--) {
    s1a[i]=s1a[i-1];
    s2a[i]=s2a[i-1];
  }

  s1a[0]=s1;
  s2a[0]=s2;

  String f1val = "f1 = " + nf(f1, 1, 3);
  String f2val = "f2 = " + nf(f2, 1, 3);
  String n1val = "blue = " + nf(s1, 1, 1);
  String n2val = "red = " + nf(s2, 1, 1);
  textFont(f, 16);
  fill(0, 200, 200);
  text(f1val, 20, height-45);
  fill(255, 0, 0);
  text(f2val, 20, height-20);
  fill(0, 200, 200);
  text(n1val, width-150, height-45);
  fill(255, 0, 0);
  text(n2val, width-150, height-20);
  fill(255, 255, 0);
  text("1, 2 to colonize", width-175, 15);
  text("09,PO to change f", width-175, 40);

  if (toggleGraph) {
    for (int j=0; j<res-1; j++) {
      float jf=j;
      stroke(0, 200, 200);
      line(.75*width*(1-jf/resf), height-.2*s1a[j], .75*width*(1-(jf+1)/resf), height-.2*s1a[j+1]);
      stroke(255, 0, 0);
      line(.75*width*(1-jf/resf), height-.2*s2a[j], .75*width*(1-(jf+1)/resf), height-.2*s2a[j+1]);
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    toggleGraph = !toggleGraph;
  }
}

void keyPressed() {
  if (key == 'g') {
    toggleCreatures = !toggleCreatures;
  }
}

