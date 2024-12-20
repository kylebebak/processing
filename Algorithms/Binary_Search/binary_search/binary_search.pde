int[] a = {
  3, 5, 7, 8, 9, 10, 13, 21, 24, 27, 35, 39, 42, 44, 45, 46, 51, 53
};

void setup() {
  try {
    int target = binarySearch(a, 20);
    println(target);
  } 
  catch (Exception e) {
    println(e.getMessage());
  }
}

int binarySearch(int[] a, int target) throws Exception {
  int nLow = 0;
  int nHigh = a.length - 1;
  int el;
  int n;
  while (true) {
    n = (nLow + nHigh) / 2;
    el = a[n];
    if (target < el) nHigh = n - 1;
    else if (target > el) nLow = n + 1;
    else return n;

    if (nHigh < nLow) throw new Exception("Element is not in array, or array is not sorted");
  }
}

