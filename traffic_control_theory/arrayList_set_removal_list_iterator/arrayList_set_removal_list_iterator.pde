ExampleClass ob1, ob2, ob3, ob4, ob5, obA, obB, obC, obD;

void setup() {

  ob1 = new ExampleClass(1.5);
  ob2 = new ExampleClass(3.5);
  ob3 = new ExampleClass(3.5);
  ob4 = new ExampleClass(2.5);
  ob5 = new ExampleClass(4.5);

  println("actually going to do some interesting stuff now");

  println();
  println();
  println();
  println();

  Set<ExampleClass> objectSet = new HashSet<ExampleClass>();
  objectSet.add(ob1);
  objectSet.add(ob2);
  objectSet.add(ob3);
  objectSet.add(ob4);
  objectSet.add(ob5);
  objectSet.add(ob4); //this won't get added because it's already part of the set
  objectSet.add(new ExampleClass(4.5));


  Set<ExampleClass> removeSet = new HashSet<ExampleClass>();
  for (ExampleClass ob1 : objectSet) {
    for (ExampleClass ob2 : objectSet) {
      if (ob1 != ob2 && ob1.getValue() == ob2.getValue()) {
        removeSet.add(ob1);
        removeSet.add(ob2);
      }
    }
  }
  objectSet.removeAll(removeSet);

  println();
  println("these are the objects now remaining in the set after removal" +
    " by using for each to loop through HashSet");
  for (ExampleClass ob : objectSet) println(ob.getValue());





  println();
  println("now let's compare objects from two different sets");
  println();

  objectSet.add(new ExampleClass(11));
  objectSet.add(new ExampleClass(3.5));

  Set<ExampleClass> objectSet2 = new HashSet<ExampleClass>();
  obA = new ExampleClass(3.5);
  obB = new ExampleClass(5.5);
  obC = new ExampleClass(6.5);
  obD = new ExampleClass(7.5);
  objectSet2.add(obA);
  objectSet2.add(obB);
  objectSet2.add(obC);
  objectSet2.add(obD);
  objectSet2.add(new ExampleClass(3.5));

  ExampleClass.printValuesInSet(objectSet, "objectSet");
  ExampleClass.printValuesInSet(objectSet2, "objectSet2");

  /*
  removeSet = new HashSet<ExampleClass>();
  for (ExampleClass ob1 : objectSet) {
    for (ExampleClass ob2 : objectSet2) {
      if (ob1.getValue() == ob2.getValue()) {
        removeSet.add(ob1);
        objectSet2.remove(ob2);
        break;
      }
    }
  }
  objectSet.removeAll(removeSet);
  */
  /*this method seems more elegant than the iterator method below,
  and with remove sets and break and continue statements i can avoid exceptions
  and manage interaction however i want*/
  
  Iterator<ExampleClass> itr1 = objectSet.iterator();
  
  while(itr1.hasNext()) {
    ExampleClass ob1 = itr1.next();
    
    Iterator<ExampleClass> itr2 = objectSet2.iterator();
    while(itr2.hasNext()) {
      ExampleClass ob2 = itr2.next();
      
      if (ob1.getValue() == ob2.getValue()) {
        itr1.remove();
        itr2.remove();
        break;
      }
    }
  }

  println();
  println();
  println("now, after comparison and removal");
  ExampleClass.printValuesInSet(objectSet, "objectSet");
  ExampleClass.printValuesInSet(objectSet2, "objectSet2");


  /*
  ~~~~~
   ~~~~~
   */
}

/*in java you don't have to declare a class static for it to have static methods,
but in processing you do. static methods are methods that can be called from the
class definition itself, without needing to instantiate an object of the class*/
static class ExampleClass {
  float val;

  ExampleClass(float val) {
    this.val = val;
  } 

  float getValue() {
    return val;
  }

  void setValue(float val) {
    this.val = val;
  }

  static void printValuesInSet(Set<ExampleClass> s, String setName) {
    println("the ExampleClass objects in " + setName + " have the following values");
    for (ExampleClass ob : s) println(ob.getValue());
    println();
  }
}

