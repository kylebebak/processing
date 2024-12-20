size(1000, 500);
smooth();
background(0);
//rectmode(CENTER);

int variables=20;
int range=10;
// range will be from 0 to the value entered here
int trials=1000000;
int i;
int j;
int k;
float[] sums=new float[range+1];
float distribution=3;
//change distribution to change shape of random power variable
//dist=0 is uniform distribution, dist=1 is linear, etc
int xsum;
int[] frequency=new int[variables*range+1];


sums[0]=1;
for (k=1; k<=range; k=k+1) {
  sums[k]=sums[k-1]+pow(k+1,distribution); //power variables
  //set distribution=0, range=1 for binomial experiment
  //sums[k]=sums[k-1]+exp(k); //exponential variables
  //sums[k]=sums[k-1]+log(exp(1)+k); //logarithmic variables
  //sums[k]=sums[k-1] //other variables
  //switch between power, exponential, logarithmic and other variables
}


for (i=0; i<=trials-1; i=i+1) {
  xsum=0;
  for (j=0; j<=variables-1; j=j+1) {
    float r = random(0,sums[range]);
    if (r<sums[0]) {
    xsum=xsum+0;
    }
    for (k=1; k<=range; k=k+1) {
      if ((r>=sums[k-1]) && (r<sums[k])) {            
      xsum=xsum+k;
      }
    }
  }
  frequency[xsum]=frequency[xsum]+1;
}


for (k=0; k<=variables*range; k=k+1) {
  fill(255,0,0);
  rect(k*width/(variables*range+1),0,width/(variables*range+1),.75*height*frequency[k]/max(frequency));
  //max(array) returns the largest value in an array, very useful
}
