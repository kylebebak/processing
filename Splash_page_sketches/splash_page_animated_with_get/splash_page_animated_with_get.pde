int num=400;
float[] x=new float[num];
float[] y=new float[num];
float[] vx=new float[num];
float[] vy=new float[num];
float[] r=new float[num];

float power=-2;
float rad=10;
float randmax=pow(15*rad, power+1);
float randmin=pow(rad, power+1);
float maxv=1;

color background1=color(0, 0, 50);
color background2=color(255);
color backgroundColor=background1;


ArrayList<Integer>[] neighbors=new ArrayList[num];

int numIndicesPerBlock=400;
int indices = 1 + num / numIndicesPerBlock;
int[] updateIndex=new int[indices];
int counter=0;


float xjt, yjt;




void setup() {
  size(1250, 750);
  background(backgroundColor);
  smooth();

  for (int i=0; i<indices; i++) updateIndex[i]=i * numIndicesPerBlock;

  for (int i=0; i<num; i++) neighbors[i]=new ArrayList();
  //initialize array of arraylists

  noStroke();
  fill(0, 79, 232, 40);
  for (int i=0; i<num; i++) {
    x[i]=random(0, width);
    y[i]=random(0, height);
    vx[i]=random(-maxv, maxv);
    vy[i]=random(-maxv, maxv);


    r[i]=pow( random(randmax, randmin), 1 / (power+1) );
    ellipse(x[i], y[i], 2*r[i], 2*r[i]);
  }

  strokeWeight(.5);
  stroke(0);
  for (int i=0; i<num; i++) {
    for (int j=i+1; j<num; j++) {

      if ( dist(x[i], y[i], x[j], y[j]) < r[i] + r[j] ) {
        line(x[i], y[i], x[j], y[j]);
        neighbors[i].add(j);
      }
    }
  }

  strokeWeight(2);
  stroke(0);
  fill(255);
  for (int i=0; i<num; i++) ellipse(x[i], y[i], 4, 4);
}




void draw() {

  background(backgroundColor);

  noStroke();
  fill(0, 79, 232, 40);
  for (int i=0; i<num; i++) {
    x[i]+=vx[i];
    y[i]+=vy[i];

    if (x[i]>width) x[i]=0;
    if (x[i]<0) x[i]=width;
    if (y[i]>height) y[i]=0;
    if (y[i]<0) y[i]=height;

    ellipse(x[i], y[i], 2*r[i], 2*r[i]);
  }

  strokeWeight(.5);
  stroke(0);
  for (int i=0; i<num; i++) {
    for (int j=0; j<neighbors[i].size(); j++) {
      xjt=x[neighbors[i].get(j)];
      yjt=y[neighbors[i].get(j)];

      if ( dist(x[i], y[i], xjt, yjt) < 500 ) 
        line(x[i], y[i], xjt, yjt);
    }
  }  

  strokeWeight(2);
  stroke(0);
  fill(255);
  for (int i=0; i<num; i++) ellipse(x[i], y[i], 4, 4);

  updateNeighbors(updateIndex[counter], updateIndex[counter+1]);

  counter++;
  if (counter>=updateIndex.length-1) counter=0;


  println(frameRate);
}




void keyReleased() {
  if (backgroundColor == background1) backgroundColor=background2;
  else backgroundColor = background1;
}

void mouseReleased() {
  for (int i=0; i<num; i++) {
    vx[i]=random(-maxv, maxv);
    vy[i]=random(-maxv, maxv);
  }
}




void updateNeighbors(int minIndex, int maxIndex) {

  for (int i=minIndex; i<maxIndex; i++) {
    neighbors[i]=new ArrayList();
    for (int j=i+1; j<num; j++) {

      if ( dist(x[i], y[i], x[j], y[j]) < r[i] + r[j] ) neighbors[i].add(j);
    }
  }
}

