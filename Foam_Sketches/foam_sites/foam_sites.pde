float SX, SY;
int SXindex, SYindex;
//source location, as a float or as a site number
float rmax;
//max distance from source to any position on screen, calculated in setup

boolean[][] sites, sitest;
//on or off for drawing bubbles

float[][] xx, yy;
float siteSizeX, siteSizeY;
//x and y coords of bubble at a given site, and width and height of each site

float yDrift=15;
float radialDrift=15;

float[] sitesX;
float[] sitesY;
//x and y coords for each site, initialized in setup for optimization

int numx=300;
int numy=200;
//number of sites in each dimension
float rad=1;
//bubble radius

int regions=50;
float dropOffExponent=1;
/*number of regions where bubble generation falls off as it gets away from source,
 and also exponential power according to which bubble generation
 falls off as a function of region */
int[] bnew=new int[regions];

int bdead=500;
int born=5;
int bdeadt;

float sr, stheta;
int sx, sy;
//temporary site indices
float dx, dy, r;

int neighbors;
//number of neighbors of a given site, another temporary variable



void setup() {
  smooth();

  size(600, 400);  
  SX=width/2;
  SY=0; //coordinates of "source" of bubbles
  SXindex= round (numx * SX /width);
  SYindex= round (numy * SY /height);
  siteSizeX=width / (float)numx;
  siteSizeY=height / (float)numy;

  sites=new boolean[numx][numy];
  sitest=new boolean[numx][numy];
  xx=new float[numx][numy];
  yy=new float[numx][numy];
  sitesX=new float[numx];
  sitesY=new float[numy];

  for (int i=0; i<numx; i++) sitesX[i]=width * (i+.5) / numx;
  for (int i=0; i<numy; i++) sitesY[i]=height * (i+.5) / numy;

  float rmax1=max( dist(SX, SY, 0, 0), dist(SX, SY, width, 0) );
  float rmax2=max( dist(SX, SY, 0, height), dist(SX, SY, width, height) );
  rmax=max(rmax1, rmax2);
}



void draw() {

  background(0);



  bdeadt=(int)random(bdead-bdead/2, bdead+bdead/2);

  for (int i=0; i<bdeadt; i++) {

    neighbors=0;
    sx=(int)random(0, numx);
    sy=(int)random(0, numy);

    if (sites [max(0, sx-1)] [sy] ) neighbors++;
    if (sites [min(numx-1, sx+1)] [sy] ) neighbors++;
    if (sites [sx] [max(0, sy-1)] ) neighbors++;
    if (sites [sx] [min(numy-1, sy+1)] ) neighbors++;

    if ( random(0, 1) * neighbors < 1.5 ) sites[sx][sy]=false;
  }



  for (int j=0; j<regions; j++) bnew[j]=(int)random(born-born/2, born+born/2)
    /  round(pow((j+1), dropOffExponent));

  for (int j=0; j<regions; j++) {
    for (int i=0; i<bnew[j]; i++) {

      neighbors=0;
      sr=random( rmax * (float)j / (float)regions, rmax * ((float)j + 1) / (float)regions );
      stheta=random(0, PI);
      sx= round( SX * numx  /  width ) + round( sr * cos(stheta) );
      sy= round( SY * numy  /  height ) + round( sr * sin(stheta) );

      if ( sx > 0 && sx < numx && sy > 0 && sy < numy ) { 
        if (sites [max(0, sx-1)] [sy] ) neighbors++;
        if (sites [min(numx-1, sx+1)] [sy] ) neighbors++;
        if (sites [sx] [max(0, sy-1)] ) neighbors++;
        if (sites [sx] [min(numy-1, sy+1)] ) neighbors++;
        if (sites [max(0, sx-1)] [max(0, sy-1)] ) neighbors++;
        if (sites [max(0, sx-1)] [min(numy-1, sy+1)] ) neighbors++;
        if (sites [min(numx-1, sx+1)] [max(0, sy-1)] ) neighbors++;
        if (sites [min(numx-1, sx+1)] [min(numy-1, sy+1)] ) neighbors++;

        if ( random(0, 1) * (neighbors + 1) / 8 > (1/12) ) sites[sx][sy]=true;
      }
    }
  }



  stroke(0, 255, 255);
  noFill();
  for (int i=0; i<numx; i++) {
    for (int j=0; j<numy; j++) {
      if (sites[i][j]) {
        ellipse(sitesX[i], sitesY[j], 4*rad, 4*rad);

        r = sqrt(sq(i-SXindex)+sq(j-SYindex));
        dx = radialDrift * ((i-SXindex) / r) / r;     //     cosø / r
        dy = yDrift / r + radialDrift * ((j-SYindex) / r) / r;
        xx[i][j]+=dx;
        yy[i][j]+=dy;
        if ( abs(xx[i][j]) > siteSizeX || abs(yy[i][j]) > siteSizeY) {


          if ( xx[i][j] > siteSizeX ) {
            sites[min(i+1, numx-1)][j]=true;
            xx[min(i+1, numx-1)][j]=-dx/2;
            yy[min(i+1, numx-1)][j]=yy[i][j];
          }
          if ( -xx[i][j] > siteSizeX ) {
            sites[max(i-1, 0)][j]=true;
            xx[max(i-1, 0)][j]=-dx/2;
            yy[max(i-1, 0)][j]=yy[i][j];
          }
          if ( yy[i][j] > siteSizeY ) {
            if (sites[i][min(j+1, numy-1)]) {
              sites[i][min(j+2, numy-1)]=true;
              xx[i][min(j+2, numy-1)]=xx[i][j+1];
              yy[i][min(j+2, numy-1)]=-dy/2;
              xx[i][min(j+1, numy-1)]=xx[i][j];
              yy[i][min(j+1, numy-1)]=-dy/2;
            } 
            else {
              sites[i][min(j+1, numy-1)]=true;
              xx[i][min(j+1, numy-1)]=xx[i][j];
              yy[i][min(j+1, numy-1)]=-dy/2;
            }
          }
          if ( -yy[i][j] > siteSizeY ) {
            sites[i][max(j-1, 0)]=true;
            xx[i][max(j-1, 0)]=xx[i][j];
            yy[i][max(j-1, 0)]=-dy/2;
          }

          xx[i][j]=0;
          yy[i][j]=0;
          sites[i][j]=false;
        }
      }
    }
  }
}

