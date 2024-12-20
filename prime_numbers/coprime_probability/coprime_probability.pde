/*program uses euler's totient function
 to calculate the probability that two
 numbers picked randomly between 1 and n
 are coprime. this value should approach
 6 / pi^2 for large values of n*/

int[] temp;
/*this array gets filled with the factors
 of a given index each time coprimet() is called
 within coprime()*/

void setup() {

  coprime(10000);
}


void coprime(int nfinal) {

  float totient_sum = 1; /*start totient sum at 1
   for the coprime pair 1, 1 which is not indexed in
   the loop below*/

  for (int i=2; i<=nfinal; i++) {
    int[] factors = {
    };
    coprimet(i, factors);
    float totient = float(i);
    for (int j=0; j<temp.length; j++) totient *= ( 1 - 1 / float(temp[j]));
    totient_sum += totient;
  }
  println("sum of totients (# coprime pairs for 1 ≤ a, b ≤ " + nfinal + ") = " 
  + round(totient_sum));
  float pp = ( 2 * totient_sum - 1 ) / sq(float(nfinal));
  println("probability of a, b coprime = " + pp);
  println();
  println("compare with 1 ≤ a, b < ∞");
  println("prob of a, b coprime = 6 / πˆ2 = " + 6 / sq(PI));
}



void coprimet(int n, 
int[] factors) {
  float fn=float(n);
  boolean primefactor=true;

  for (int i=2; i<=round(sqrt(n)); i++) {
    float quotient=fn/i;

    if ( quotient%1 == 0 ) {
      primefactor=false;
      if (factors.length != 0) {
        if (i != factors[factors.length-1]) factors = append(factors, i);
      }
      else {
        factors = append(factors, i);
      }
      coprimet( int(quotient), factors );
      break;
    }
  }

  if (primefactor) {
    if (factors.length != 0) {
      if (n != factors[factors.length-1]) factors = append(factors, n);
    }
    else { 
      factors = append(factors, n);
    }
    temp = factors;
  }
}

