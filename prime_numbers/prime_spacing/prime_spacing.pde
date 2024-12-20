int prime_counter=0;
int[] pp=new int[2]; //array for storing 2 most recent primes
PrintWriter primes;


void setup() {
  primes = createWriter("prime spacing.txt");

  for (int i=2; i<1000000; i++) {

    if ( is_prime(i) ) {
      pp[1]=pp[0];
      pp[0]=i;
      int d=pp[0]-pp[1];
      primes.println(log(i) + "\t" + d);
      /*the spacing between primes goes like the
      natural logarithm of the primes themselves,
      which means plotting one vs the other
      should give us a line*/
      //primes.println(i + "\t" + d);
    }

    /*typing \t in a string inserts a tab into the string,
     which allows me to import this data directly into excel
     or geogebra to do regression analysis on it*/
  }

  primes.flush();
  primes.close();
}



boolean is_prime(int n) {
  boolean prime=true;
  float fn=float(n);

  for (int i=2; i<=round(sqrt(n)); i++) {
    if ( (fn/i)%1 == 0 ) {
      prime=false;
      break;
    }
  }

  return(prime);
}

