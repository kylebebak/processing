import java.util.Arrays;
import java.util.TreeSet;

void setup() {
  /* this program sorts two arrays of integers by brute force,
  comparing each element of the first array with each element
  of the second array */

  int[] a0;
  int[] a1;

  int N = 100000;
  int range = 1000000;

  a0 = new int[N];
  a1 = new int[N];

  for (int i = 0; i < N; i++) {
    a0[i] = (int)random(range);
    a1[i] = (int)random(range);
  }

  println("done constructing");

  TreeSet<Integer> ts = new TreeSet<Integer>();
  for (int i = 0; i < a0.length; i++) 
    for (int j = 0; j < a1.length; j++) 
      if (a0[i] == a1[j]) ts.add(a0[i]); 

  for (int i : ts) print(i + "  ");
}



boolean binarySearch(int[] a, int target) {
  int nLow = 0;
  int nHigh = a.length - 1;
  int el;
  int n;
  while (true) {
    n = (nLow + nHigh) / 2;
    el = a[n];
    if (target < el) nHigh = n - 1;
    else if (target > el) nLow = n + 1;
    else return true;

    if (nHigh < nLow) return false;
  }
}

