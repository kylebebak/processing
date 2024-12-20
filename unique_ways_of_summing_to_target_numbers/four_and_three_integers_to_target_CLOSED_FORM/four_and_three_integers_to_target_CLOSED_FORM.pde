void setup() {
  fourdigsum(1288);  //works up to 1288, at 1289 there's an error
  //threedigsum(20);
  
  /*notice that (n+3 choose 3) / 4! is a good
 approximation an n becomes large*/ 
}

/*explicit formula for number of ways to sum
 4 digits to a target sum*/
void fourdigsum(int targetSum) {
  int A=0;
  int n=targetSum;
  float N=(float)n;

  int xxxx=0;
  int xxxo=0;
  int xxoo=0;
  int xxoi=0;

  if (n%4 == 0) xxxx+=1;

  xxxo+=floor(N/3)+1;
  if (n%4 == 0) xxxo-=1;

  if (n%2 == 0) xxoo+=ceil(N/4);



  int SR; //slots remaining
  int options; //options among these slots

    if (n%2 == 0) {

    for (int x=0; x<=n/2; x++) {
      SR=n+1-2*x;
      options=(SR-1)/2;
      if ( (x>=0 && x<=options-1) || (x>=options+1 && x<=SR-1) ) options--;
      xxoi+=options;
    }
  }
  else {
    for (int x=0; x<=(n-1)/2; x++) {
      SR=n+1-2*x;
      options=SR/2;
      if ( x>=0 && x<=SR-1 ) options--;
      xxoi+=options;
    }
  }



  A = ( ( ((n+3)*(n+2)*(n+1) / 6) - (xxxx*1) - (xxxo*4) - (xxoo*6) - (xxoi*12) ) / 24 );
  println("# of xoiy cases to " + n + " = " + A); 
  A += xxxx + xxxo + xxoo + xxoi; 
  println("# of total unique cases 4 digit sum to " + n + " = " + A);

  /* 4 choose 4 = 1
   4 choose 3 = 4
   4 choose 2 = 6
   4 choose 2, 1, 1 = 12
   */
}



/*explicit formula for number of ways to sum
3 digits to a target sum*/
void threedigsum(int targetSum) {
 int n=targetSum;
 int A=0;
 if (n%3 != 0) A=( ((n+2)*(n+1)) / 2 -
 (floor( (float)n / 2) + 1) * 3) / 6
 + floor( (float)n / 2) + 1;
 
 else A=( ((n+2)*(n+1)) / 2 -
 floor( (float)n / 2) * 3 - 1) / 6
 + floor( (float)n / 2) + 1;
 
 
 println("# of total unique cases 3 digit sum to " + n + " = " + A);
}

