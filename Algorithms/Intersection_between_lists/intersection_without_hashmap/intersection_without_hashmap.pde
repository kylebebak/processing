import java.util.Arrays;

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

  int[] a;
  int[] b;

  int N =     1000000;
  int range = 10000000;

  a = new int[N];
  b = new int[N];

  for (int i = 0; i < N; i++) {
    a[i] = (int)random(range);
    b[i] = (int)random(range);
  }

  println("done constructing");

  Arrays.sort(a);
  Arrays.sort(b);

  ArrayList<Integer> intersectionList = new ArrayList<Integer>();

  int pointer = 0;
  for (int i = 0; i < a.length; i++) {
    int ai = a[i];

    for (int j = pointer; j < b.length; j++) {
      if (ai == b[j]) {
        intersectionList.add(ai);
        pointer = j;
        break;
      } 
      else if (b[j] > ai) {
        pointer = j;
        break;
      }
    }
  }

  for (int i : intersectionList) print(i + "  ");
  println();
  println(intersectionList.size() + " elements intersect");
}

