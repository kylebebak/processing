void setup() {
  println(factorial(8));
}

int factorial(int n)
{
  
  if (n <= 1) return 1;
  else return n * factorial(n - 1);
  
}

