int[] a = {
  46, 51, 53, 3, 5, 7, 8, 9, 10, 13, 21, 24, 27, 35, 39, 42, 44, 45
};

void setup() {
  try {
    int target = kShiftedBinarySearch(a, 13, 3);
    println(target);
  } 
  catch (Exception e) {
    println(e.getMessage());
  }
}

int kShiftedBinarySearch(int[] a, int target, int k) throws Exception {
  /* performs binary search on a sorted array whose elements have all been cyclically shifted
   k spaces to the right. the algorithm is identical to normal binary search, except that the
   index of the element inspected (and possibly returned) at each pass in the while loop is increased by
   k and then looped with modular arithmetic if it is greater than or equal to the length of the array */
  if (k < 0 || k > a.length - 1) throw new Exception("k must be between 0 and a.length - 1, inclusive");
  int nLow = 0;
  int nHigh = a.length - 1;
  int el;
  int n;
  while (true) {
    n = (nLow + nHigh) / 2;
    el = a[(n + k) % a.length];
    if (target < el) nHigh = n - 1;
    else if (target > el) nLow = n + 1;
    else return (n + k) % a.length;

    if (nHigh < nLow) throw new Exception("Element is not in array, or array is not sorted");
  }
}

