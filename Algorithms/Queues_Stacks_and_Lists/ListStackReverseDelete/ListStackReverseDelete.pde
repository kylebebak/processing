/*************************************************************************
 *  Compilation:  javac Stack.java
 *  Execution:    java Stack < input.txt
 *
 *  A generic stack, implemented using a linked list. Each stack
 *  element is of type Item.
 *  
 *  % more tobe.txt 
 *  to be or not to - be - - that - - - is
 *
 *  % java Stack < tobe.txt
 *  to be not that or be (2 left on stack)
 *
 *************************************************************************/

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;


void setup() {
  /* test client for stack class. splits a string
   sentence into an array of string words
   and pushes them to the stack, except for the character
   "-", which calls pop */
  Stack<Integer> st = new Stack<Integer>();

  //  String s = "to be or not to - be - - that is - - - the - question -";
  //  String[] input = s.split(" ");

  String s = "1 5 32 6 16 0 13 17 9 8";
  String[] input = s.split(" ");

  for (int i = 0; i < input.length; i++) {
    if (input[i].equals("-")) st.pop();
    else st.push(Integer.parseInt(input[i]));
  }

  println(st.toString());

  st.reverse();
  println(st.toString());


  ArrayList<Integer> a = new ArrayList<Integer>();
  for ( Integer i : st ) a.add(i);
  Collections.shuffle(a);

  for ( Integer i : a ) {
    st.delete(i);
    println();
    println("key deleted :     " + i);
    println("remaining array:  " + st.toString());
  }
}





/**
 *  The <tt>Stack</tt> class represents a last-in-first-out (LIFO) stack of generic items.
 *  It supports the usual <em>push</em> and <em>pop</em> operations, along with methods
 *  for peeking at the top item, testing if the stack is empty, and iterating through
 *  the items in LIFO order.
 *  <p>
 *  All stack operations except iteration are constant time.
 *  <p>
 *  For additional documentation, see <a href="/algs4/13stacks">Section 1.3</a> of
 *  <i>Algorithms, 4th Edition</i> by Robert Sedgewick and Kevin Wayne.
 */
public class Stack<Item> implements Iterable<Item> {
  private int N;          // size of the stack
  private Node first;     // top of stack

  // helper linked list class
  private class Node {
    private Item item;
    private Node next;
  }

  /**
   * Create an empty stack.
   */
  public Stack() {
    first = null;
    N = 0;
    assert check();
  }

  /**
   * Is the stack empty?
   */
  public boolean isEmpty() {
    return first == null;
  }

  /**
   * Return the number of items in the stack.
   */
  public int size() {
    return N;
  }

  /**
   * Add the item to the stack.
   */
  public void push(Item item) {
    Node oldfirst = first;
    first = new Node();
    first.item = item;
    first.next = oldfirst;
    N++;
    assert check();
  }

  /**
   * Delete and return the item most recently added to the stack.
   * @throws java.util.NoSuchElementException if stack is empty.
   */
  public Item pop() {
    if (isEmpty()) throw new NoSuchElementException("Stack underflow");
    Item item = first.item;        // save item to return
    first = first.next;            // delete first node
    N--;
    assert check();
    return item;                   // return the saved item
  }


  /**
   * Return the item most recently added to the stack.
   * @throws java.util.NoSuchElementException if stack is empty.
   */
  public Item peek() {
    if (isEmpty()) throw new NoSuchElementException("Stack underflow");
    return first.item;
  }

  /**
   * Return string representation.
   */
  public String toString() {
    StringBuilder s = new StringBuilder();
    for (Item item : this)
      s.append(item + " ");
    return s.toString();
  }


  // check internal invariants
  private boolean check() {
    if (N == 0) {
      if (first != null) return false;
    }
    else if (N == 1) {
      if (first == null)      return false;
      if (first.next != null) return false;
    }
    else {
      if (first.next == null) return false;
    }

    // check internal consistency of instance variable N
    int numberOfNodes = 0;
    for (Node x = first; x != null; x = x.next) {
      numberOfNodes++;
    }
    if (numberOfNodes != N) return false;

    return true;
  }


  /**
   * non-standard stack operations, reverse and delete
   */

  public void reverse() {
    // reverse the order of the stack, takes time linear in N
    if (N != 0) reverse(first, null);
  } 

  private void reverse(Node current, Node previous) {
    if (current.next != null) reverse(current.next, current);
    else first = current;
    current.next = previous;
  }


  // this is the implementation i want! elegant and readable
  public void delete(Item item) {
    if (first == null) return;
    if (first.item.equals(item)) {
      if (first.next == null) first = null;
      else first = first.next;
    } 
    else delete(item, first.next, first);
  }

  private void delete(Item item, Node current, Node previous) {
    if (current == null) return;
    if (current.item.equals(item)) previous.next = current.next;
    else delete(item, current.next, current);
  }

  // here's another, which passes only one node to the
  // private helper function
  /*
  public void delete(Item item) {
   if (first == null) return;
   if (first.item.equals(item)) {
   if (first.next == null) first = null;
   else first = first.next;
   } 
   else delete(item, first);
   }
   
   private void delete(Item item, Node current) {
   if (current.next == null) return;
   if (current.next.item.equals(item)) {
   if (current.next.next == null) current.next = null;
   else current.next = current.next.next;
   }
   else delete(item, current.next);
   }
   */



  /**
   * Return an iterator to the stack that iterates through the items in LIFO order.
   */
  public Iterator<Item> iterator() { 
    return new ListIterator();
  }

  // an iterator, doesn't implement remove() since it's optional
  private class ListIterator implements Iterator<Item> {
    private Node current = first;
    public boolean hasNext() { 
      return current != null;
    }
    public void remove() { 
      throw new UnsupportedOperationException();
    }

    public Item next() {
      if (!hasNext()) throw new NoSuchElementException();
      Item item = current.item;
      current = current.next; 
      return item;
    }
  }
}

