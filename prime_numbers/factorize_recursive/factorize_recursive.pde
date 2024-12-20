/*program uses recursion to decompose numbers
intro products of primes*/

PrintWriter factors;

void setup() {
  factors = createWriter("prime factorization.txt");
  
  for (int i=2; i<500000; i++) factorize(i, factors);
  
  factors.flush();
  factors.close();
}


void factorize(int n, PrintWriter factors) {
  
  factors.println();
  factors.print( n + " = ");
  factorizet(n, factors);
}


void factorizet(int n, PrintWriter factors) {
  float fn=float(n);
  boolean primefactor=true;

  for (int i=2; i<=round(sqrt(n)); i++) {
    float quotient=fn/i;
    if ( quotient%1 == 0 ) {
      primefactor=false;
      factors.print(i + " ");
      factorizet( int(quotient), factors );
      break;
    }
  }

  if (primefactor) factors.print(n);
}

