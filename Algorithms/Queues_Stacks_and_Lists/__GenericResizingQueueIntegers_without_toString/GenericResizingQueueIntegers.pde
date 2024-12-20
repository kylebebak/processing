import java.util.Iterator;
import java.util.NoSuchElementException;

ResizingQueue<Integer> q;

void setup() {
  /* test client for queue class. splits a string
   sentence into an array of string words
   and enqueues them, except for the characeter
   "-", which calls dequeue */
  q = new ResizingQueue();

  String s = "1 5 32 6 - 4 11 - - - 68 7 81 - - 3 - 22 5 5 1 - - - - 3 4 5 6 7 8";
  String[] numbers = s.split(" ");

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i].equals("-")) q.dequeue();
    else q.enqueue(Integer.parseInt(numbers[i]));


    String arrayElement;
    String[] a = new String[q.getLength()];
    for (int j = 0; j < q.getLength(); j++) { 
      if (q.getElement(j) == null) arrayElement = null;
      else arrayElement = Integer.toString(q.getElement(j));
      a[j] = arrayElement;
    }
    printStringArray(a);
  }
}

void printStringArray(String[] a) {
  String oneLine = "";
  for (int i = 0; i < a.length - 1; i++) oneLine += (a[i] + ", ");
  oneLine += a[a.length - 1];
  println(oneLine);
}




public class ResizingQueue<Item> implements Iterable<Item> {
  private Item[] a;
  private int N = 0;
  private int last = 0;
  private int first = 0;

  public ResizingQueue() {
    a = (Item[]) new Object[1];
  }

  public boolean isEmpty() { 
    return N == 0;
  }

  public int getSize() { 
    return N;
  }

  public int getLength() {
    return a.length;
  }

  public Item getElement(int index) {
    return a[index];
  }


  public void enqueue(Item item) {
    if (N == a.length) resize(a.length * 2);
    a[last++] = item;
    if (last == a.length) last = 0;
    N++;
  }

  public Item dequeue() {
    if (isEmpty()) throw new RuntimeException("Stack underflow error");

    Item item = a[first];
    a[first++] = null;
    if (first == a.length) first = 0;
    N--;
    if (N <= a.length / 4) resize(a.length / 2);
    return item;
  } 

  private void resize(int max) {
    assert max >= N;
    Item[] temp = (Item[]) new Object[max];
    for (int i = 0; i < N; i++) {
      temp[i] = a[(first + i) % a.length];
    }
    a = temp;
    first = 0;
    last = N;
  }


  public Iterator<Item> iterator() { 
    return new QueueIterator();
  }

  private class QueueIterator implements Iterator<Item> {
    private int i;

    public QueueIterator() {
      i = first;
    }

    public boolean hasNext() {
      return i < N + first;
    }

    public void remove() {
      throw new UnsupportedOperationException();
    }

    public Item next() {
      if (!hasNext()) throw new NoSuchElementException();
      return a[(i++ % a.length)];
    }
  }
}

