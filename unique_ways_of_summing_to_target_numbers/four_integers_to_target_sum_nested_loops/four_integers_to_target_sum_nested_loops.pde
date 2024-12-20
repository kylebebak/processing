/*number of digits being added here is 4, target is the
target sum that we're trying to reach. this code is optimized
to test as few cases as possible, and not test cases for which
the sum will obviously be larger than the target sum*/
int target=50;
int counter=0;

for (int i=0; i<=target; i++) {
  for (int j=i; j<=target; j++) {
    for (int k=j; k<=target; k++) {
      for (int l=k; l<=target; l++) {

        if (i+j+k+l==target) {
          counter++;
          println( i + ", " + j + 
          ", " + k + ", " + l);
          break;
        }
        
      }
    }
  }
}

println(counter + " ways in total");

