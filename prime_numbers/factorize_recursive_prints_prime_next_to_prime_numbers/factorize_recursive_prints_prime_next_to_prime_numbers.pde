/*program uses recursion to decompose numbers
 intro products of primes*/
 
/*to format correctly with \t, i can make a string
and then print the string to the line for
each number that is factored, because i can use
string.length() to get the length of the string
and put in the appropriate number of tabs depending
on its length*/



void setup() {

  factorize(2, 1000000);
  
}


void factorize(int nstart, int nfinal) {
  
  boolean is_prime=true;

  PrintWriter factors;
  factors = createWriter("prime factorization.txt");

  for (int i=nstart; i<=nfinal; i++) {
    String s = "";
    factors.println();
    s += i + " = ";
    factorizet(i, is_prime, factors, s);
  }

  factors.flush();
  factors.close();
}


void factorizet(int n, boolean is_prime,
PrintWriter factors, String s) {
  float fn=float(n);
  boolean primefactor=true;

  for (int i=2; i<=round(sqrt(n)); i++) {
    float quotient=fn/i;
    
    if ( quotient%1 == 0 ) {
      primefactor=false;
      is_prime=false;
      s += i + " ";
      factorizet( int(quotient), is_prime, factors, s );
      break;
    }
  }

  if (primefactor) s += n;
  if (is_prime) {
    int ntabs = 6 - s.length() / int(8);
    for (int i=0; i<ntabs; i++) s += "\t";
    s += "prime";
  }
  if (primefactor) factors.print(s);
}
