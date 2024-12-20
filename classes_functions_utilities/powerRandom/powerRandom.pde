void setup() {
  float sum=0;
  for (int i=0; i<10000; i++) 
    sum += (powerRand(0, 5, 1)); 
  println(sum/10000);
}

float powerRand(float minval, float maxval, float power) {

  if (power == -1) power=0;
  if (power < 0) {
    if (minval==0) minval=1;
    if (maxval==0) maxval=1;
  }

  if (minval>=maxval) maxval=minval+1;

  float r=0;
  if (power != -1) {

    float rmax=pow(maxval, power+1);
    float rmin=pow(minval, power+1);

    if (power>-1) r=pow(random(rmin, rmax), 1 / (power+1));
    if (power<-1) r=pow(random(rmax, rmin), 1 / (power+1));
  }
  return(r);
}

