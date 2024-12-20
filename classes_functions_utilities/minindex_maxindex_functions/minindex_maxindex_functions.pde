float[] test={1,3,4};
float[] test2={0,0,1,0};
int k=maxindex(test);

void setup() {
  println(k);
  println(minindex(test));
  println(maxindex(test2));
}




int maxindex(float[] input) {
  float currentmax=min(input);
  int pos=0;
  for (int i=0; i<input.length; i++) {
    if (input[i]>currentmax) {
      pos=i;
      currentmax=input[i];
    }
  }
  return(pos);
}



int minindex(float[] input) {
  float currentmin=max(input);
  int pos=0;
  for (int i=0; i<input.length; i++) {
    if (input[i]<currentmin) {
      pos=i;
      currentmin=input[i];
    }
  }
  return(pos);
}



