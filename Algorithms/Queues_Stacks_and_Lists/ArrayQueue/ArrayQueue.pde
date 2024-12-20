import java.util.Iterator;
import java.util.NoSuchElementException;

void setup() {
  /* test client for queue class. splits a string
   sentence into an array of string words
   and enqueues them, except for the character
   "-", which calls dequeue */
  ResizingQueue<String> q = new ResizingQueue<String>();

  String s = "to be or not to - be - - that is - - - the - question - - -";
  String[] input = s.split(" ");

  for (int i = 0; i < input.length; i++) {
    if (input[i].equals("-")) q.dequeue();
    else q.enqueue(input[i]);

    println(q.toString());
  }
}




public class ResizingQueue<Item> implements Iterable<Item> {
  private Item[] a;
  private int N = 0;
  private int last = 0;
  private int first = 0;

  public ResizingQueue() {
    a = (Item[]) new Object[2];
  }

  public boolean isEmpty() { 
    return N == 0;
  }

  public int getSize() { 
    return N;
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


  public String toString() {
    StringBuilder s = new StringBuilder();
    for (int i = 0; i < a.length - 1; i++) s.append(a[i] + ", ");
    s.append(a[a.length - 1]);
    return s.toString();
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

