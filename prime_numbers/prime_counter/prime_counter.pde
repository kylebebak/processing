int prime_counter=0;
int counter=1;
PrintWriter primes;


void setup() {
  primes = createWriter("primes ≤ n+1.txt");
  
  for (int i=2; i<100000; i++) {
    
    if ( is_prime(i) ) {
      prime_counter++;
      counter++;
    }
    
    if ( (counter % 11) == 0 ) {
      counter=1;
      
      primes.println(i/log(i) + "\t" + prime_counter);
      //primes.println(i + "\t" + prime_counter);
      
      /*typing \t in a string inserts a tab into the string,
      which allows me to import this data directly into excel
      or geogebra to do regression analysis on it*/
    }
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

