import java.util.Arrays;
import java.util.TreeSet;

void setup() {
  /* this program takes two arrays of integers, a0 and a1,
  and finds the intersection between them efficiently. it does
  so by sorting one of the arrays, which takes linearithmic
  time in the size of the array, and then iterates through
  the elements of the other array and binary searches the sorted
  one for these elements. this also takes linearithmic time
  assuming the arrays have the same size. it adds these elements
  to a tree set (which takes linearithmic time to construct) 
  to automatically sort them and avoid duplicates, and then prints 
  the intersecting elements to the console */

  int[] a0;
  int[] a1;
  
  int N =     1000000;
  int range = 10000000;
  
  a0 = new int[N];
  a1 = new int[N];
  
  for (int i = 0; i < N; i++) {
    a0[i] = (int)random(range);
    a1[i] = (int)random(range);
  }
  
  println("done constructing");
  
  Arrays.sort(a1);
  
  TreeSet<Integer> ts = new TreeSet<Integer>();
  for (int i = 0; i < a0.length; i++) {
    if (binarySearch(a1, a0[i])) ts.add(a0[i]);
  }
  
  for (int i : ts) print(i + "  ");
  println();
  println(ts.size() + " elements intersect");
  
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

