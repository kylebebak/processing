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

void setup() {
  /* test client for stack class. splits a string
   sentence into an array of string words
   and pushes them to the stack, except for the character
   "-", which calls pop */
  GenericResizingStack<Integer> st = new GenericResizingStack<Integer>();

//  String s = "to be or not to - be - - that is - - - the - question -";
//  String[] input = s.split(" ");
  
  String s = "1 5 32 6 - 4 11 - - - 68 7 81 - - 3 - 22 5 5 1 - - - - 3 4 5 6 7 8";
  String[] input = s.split(" ");

  for (int i = 0; i < input.length; i++) {
    if (input[i].equals("-")) st.pop();
    else st.push(Integer.parseInt(input[i]));
    
    println(st.toString());
  }
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

