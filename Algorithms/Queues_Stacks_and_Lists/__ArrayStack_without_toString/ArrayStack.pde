/*************************************************************************
 *  Compilation:  javac DoublingStackOfStrings.java
 *  Execution:    java DoublingStackOfStrings
 *  
 *  Stack of strings implementation with an array.
 *  Resizes by doubling and halving.
 *
 *************************************************************************/

import java.util.Iterator;
import java.util.NoSuchElementException;

GenericResizingStack<String> st;

void setup() {
  /* test client for stack class. splits a string
   sentence into an array of string words
   and pushes them to the stack, except for the character
   "-", which calls pop */
  st = new GenericResizingStack<String>();

  String s = "to be or not to - be - - that is - - - the - question -";
  String[] words = s.split(" ");

  for (int i = 0; i < words.length; i++) {
    if (words[i].equals("-")) st.pop();
    else st.push(words[i]);


    String arrayElement;
    String[] a = new String[st.getLength()];
    for (int j = 0; j < st.getLength(); j++) { 
      arrayElement = st.getElement(j);
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




public class GenericResizingStack<Item> implements Iterable<Item> {
  private Item[] a;
  private int N;

  public GenericResizingStack() {
    a = (Item[]) new Object[1];
    N = 0;
  }

  // is the stack empty?
  public boolean isEmpty() {  
    return (N == 0);
  }

  public int getLength() {
    return a.length;
  }

  public Item getElement(int index) {
    return a[index];
  }


  // resize the underlying array holding the elements
  private void resize(int capacity) {
    Item[] temp = (Item[]) new Object[capacity];
    for (int i = 0; i < N; i++) {
      temp[i] = a[i];
    }
    a = temp;
  }

  // push a new item onto the stack
  public void push(Item item) {
    if (N == a.length) resize(2*a.length);
    a[N++] = item;
  }

  // delete and return the item most recently added
  public Item pop() {
    if (isEmpty()) { 
      throw new RuntimeException("Stack underflow error");
    }
    Item item = a[--N];
    a[N] = null;  // to avoid loitering
    if (N > 0 && N == a.length/4) resize(a.length/2);
    return item;
  }


  public String toString() {
    StringBuilder s = new StringBuilder();
    for (int i = 0; i < a.length - 1; i++) s.append(a[i] + ", ");
    s.append(a[a.length-1]);
    return s.toString();
  } 



  public Iterator<Item> iterator() {  
    return new ReverseArrayIterator();
  }

  // an iterator, doesn't implement remove() since it's optional
  private class ReverseArrayIterator implements Iterator<Item> {
    private int i = N;
    public boolean hasNext() { 
      return i > 0;
    }
    public void remove() { 
      throw new UnsupportedOperationException();
    }

    public Item next() {
      if (!hasNext()) throw new NoSuchElementException();
      return a[--i];
    }
  }
}

