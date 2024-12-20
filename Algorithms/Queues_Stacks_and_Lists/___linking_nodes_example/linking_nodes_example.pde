void setup() {
  
  Node first = new Node(5, null);
  println();
  println(first.val);
  
  Node oldFirst = first;
  first = new Node(10, oldFirst);
  
  println();
  println(first.val);
  println(first.next.val);
  
  oldFirst = first;
  first = new Node(15, oldFirst);
  
  println();
  println(first.val);
  println(first.next.val);
  println(first.next.next.val);
}


class Node {
  int val;
  Node next;

  Node(int val, Node next) {
    this.val = val;
    this.next = next;
  }
}

