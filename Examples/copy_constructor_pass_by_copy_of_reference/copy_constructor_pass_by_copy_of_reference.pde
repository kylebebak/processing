void setup() {

  int a = 10;
  int b = a;
  a = 5;

  println("a = " + a + " , b = " + b);

  int[] aa = {
    5, 10
  };
  int[] bb = aa;

  aa[0] = 10;

  println("aa = ");
  println(aa);
  println("bb = ");
  println(bb);

  Dog dog = new Dog("Kasper");
  Dog kate = dog;
  Dog kasper = dog;

  println();
  println();
  kate.setName("kate");
  println(kate.getName());
  println(kasper.getName());

  println();
  println();
  changeName(kasper, "kasper");
  println(kate.getName());
  println(kasper.getName());

  println();
  println();
  Dog jessie = new Dog(kasper);
  jessie.setName("Jessie!");
  println(jessie.getName());
  println(kasper.getName());

  println();
  println();
  kasper = jessie;
  println(kasper.getName());
  kasper = kate;
  println(kasper.getName());
  
  
  
  changeNameLocally(kasper, "beast");
  println(kasper.getName());
  // this works the same as changeName
}







public class Dog {

  private String name;

  public Dog(String name) {
    this.name = name;
  }

  // a copy constructor, or understanding why it is dangerous to directly
  // assign the value of one object to another object, and how to avoid
  // the associated dangers
  public Dog(Dog aDog) {
    this(aDog.getName());
    //no defensive copies are created here, since 
    //there are no mutable object fields (String is immutable)
  }



  public void setName(String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }
  
}



public void changeNameLocally(Dog global, String newName) {
  Dog local = global;
  local.setName(newName);
}



void changeName(Dog dog, String name) {
  dog.setName(name);
}
