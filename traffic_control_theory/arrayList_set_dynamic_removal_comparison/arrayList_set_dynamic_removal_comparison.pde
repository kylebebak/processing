ExampleClass ob1, ob2, ob3, ob4, ob5, obA, obB, obC, obD;

void setup() {
  int[] nums = {
    1, 2, 3
  };
  for (int num : nums) println(num);


  println();
  println();


  ArrayList<Integer> numbers = new ArrayList<Integer>();
  numbers.add(1);
  numbers.add(3);
  numbers.add(5);
  numbers.add(1);
  for (float num : numbers) println(num);

  println("get indices");

  for (int num : numbers) {
    int index = numbers.indexOf(num);
    println(index);
  }


  println();
  println();


  ob1 = new ExampleClass(1.5);
  ob2 = new ExampleClass(3.5);
  ob3 = new ExampleClass(3.5);
  ob4 = new ExampleClass(2.5);
  ob5 = new ExampleClass(4.5);

  ArrayList<ExampleClass> objects = new ArrayList<ExampleClass>();
  objects.add(ob1);
  objects.add(ob2);
  objects.add(ob3);
  objects.add(ob4);
  objects.add(ob5);
  for (ExampleClass ob : objects) {
    ob.setValue(ob.getValue() + 1.0);
    //    ob.val += 1;
    println(ob.getValue());
  }

  println("get indices");

  for (ExampleClass ob : objects) {
    int index = objects.indexOf(ob);
    println(index);
  }

  /*
  this shows that instances of a class built with the same constructor
   method are still stored in different places in memory and have
   different pointers associated with them when iterating through an arrayList
   that contains both objects. ob1 and ob4 were constructed with the same
   constructor, and if they had been primitives like ints they wouldn't
   have different pointers
   */

  println();
  println();

  ArrayList<ExampleClass> objectsCopy = new ArrayList<ExampleClass>(objects);
  for (ExampleClass ob : objectsCopy) {
    int index = objectsCopy.indexOf(ob);
    println(index + " is the index of this object");
    println(ob.getValue() + " is its value");
  }

  println();
  println();

  for (ExampleClass ob1 : objectsCopy) {
    for (ExampleClass ob2 : objectsCopy) {
      if (ob1.getValue() == ob2.getValue()) {
        println(objectsCopy.indexOf(ob1) + " is the first index and " + 
          objectsCopy.indexOf(ob2) + " is the second index");
      }
    }
  }






  println();
  println();
  println();
  println();

  println("actually going to do some interesting stuff now");

  println();
  println();
  println();
  println();

  objectsCopy.add(new ExampleClass(4.5));
  println("printing object values from ArrayList objectsCopy");
  for (ExampleClass ob : objectsCopy) println(ob.getValue());

  Set<Integer> indices = new TreeSet<Integer>();
  for (int i = objectsCopy.size()-1; i >= 0; i--) {
    for (int j = i - 1; j >= 0; j--) {
      if (objectsCopy.get(i).getValue() == objectsCopy.get(j).getValue()) {
        indices.add(i);
        indices.add(j);
      }
    }
  }
  Integer[] indicesArray = indices.toArray(new Integer[indices.size()]);
  //indicesArray = sort(indicesArray);
  //i don't have to sort this array because tree sets are automatically sorted
  for (int i = indicesArray.length - 1; i>=0; i--) objectsCopy.remove((int)indicesArray[i]);


  println();
  println("these are the objects now remaining in the list after removal" +
    " by looping through arrayList");
  for (ExampleClass ob : objectsCopy) println(ob.getValue());


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

  println();
  println("printing object values from HashSet objectSet");
  for (ExampleClass ob : objectSet) println(ob.getValue());


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

  println("by the way, here are different ways of getting the name of a class as a string");
  println(ob1.getClass().getName());
  println(ExampleClass.class.getName());

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
  //objectSet2.add(new ExampleClass(3.5));

  printValuesInSet(objectSet, "objectSet");
  printValuesInSet(objectSet2, "objectSet2");


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


void printValuesInSet(Set<ExampleClass> s, String setName) {
  println("the ExampleClass objects in " + setName + " have the following values");
  for (ExampleClass ob : s) println(ob.getValue());
  println();
}

