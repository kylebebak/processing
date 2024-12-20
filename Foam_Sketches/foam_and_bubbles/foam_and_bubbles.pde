float SX, SY;
//source location

boolean[][] sites;
//on or off for drawing bubbles

float[] sitesX;
float[] sitesY;
//x and y coords for each site, initialized in setup for optimization

int num=100;
//number of sites in each dimension
float rad=3;
//bubble radius

int regions=10;
float dropOffExponent=2;
/*number of regions where bubble generation falls off as it gets away from source,
 and also exponential power according to which bubble generation
 falls off as a function of region */
int[] bnew=new int[regions];

int bdead=250;
int born=100;
int bdeadt;

int sx;
int sy;
//temporary site indices

int neighbors;
//number of neighbors of a given site, another temporary variable



void setup() {
  size(600, 600);  
  SX=width/2;
  SY=0; //coordinates of "source" of bubbles

  sites=new boolean[num][num];
  sitesX=new float[num];
  sitesY=new float[num];

  for (int i=0; i<num; i++) {
    sitesX[i]=width * (i+.5) / num;
    sitesY[i]=height * (i+.5) / num;
  }
}



void draw() {

  background(0);



  bdeadt=(int)random(bdead-bdead/2, bdead+bdead/2);

  for (int i=0; i<bdeadt; i++) {

    neighbors=0;
    sx=(int)random(0, num);
    sy=(int)random(0, num);

    if (sites [max(0, sx-1)] [sy] ) neighbors++;
    if (sites [min(num-1, sx+1)] [sy] ) neighbors++;
    if (sites [sx] [max(0, sy-1)] ) neighbors++;
    if (sites [sx] [min(num-1, sy+1)] ) neighbors++;

    if ( random(0, 1) * neighbors < 1.5 ) sites[sx][sy]=false;
  }



  for (int j=0; j<regions; j++) bnew[j]=(int)random(born-born/2, born+born/2)
    /  round(pow((j+1), dropOffExponent));

  for (int j=0; j<regions; j++) {
    for (int i=0; i<bnew[j]; i++) {

      neighbors=0;
      sx=(int)random(0, num);
      sy=(int)random(num * (float)j / (float)regions, num * ((float)j + 1) / (float)regions);

      if (sites [max(0, sx-1)] [sy] ) neighbors++;
      if (sites [min(num-1, sx+1)] [sy] ) neighbors++;
      if (sites [sx] [max(0, sy-1)] ) neighbors++;
      if (sites [sx] [min(num-1, sy+1)] ) neighbors++;
      if (sites [max(0, sx-1)] [max(0, sy-1)] ) neighbors++;
      if (sites [max(0, sx-1)] [min(num-1, sy+1)] ) neighbors++;
      if (sites [min(num-1, sx+1)] [max(0, sy-1)] ) neighbors++;
      if (sites [min(num-1, sx+1)] [min(num-1, sy+1)] ) neighbors++;

      if ( random(0, 1) * (neighbors + 1) / 8 > (1/12) ) sites[sx][sy]=true;
    }
  }

  stroke(0, 255, 255);
  noFill();
  for (int i=0; i<num; i++) {
    for (int j=0; j<num; j++) {
      if (sites[i][j]) ellipse(sitesX[i], sitesY[j], 2*rad, 2*rad);
    }
  }
}

