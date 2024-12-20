float[] arr=new float[10];
// The code that might produce an error goes within the “try” section.  
try {
  arr[13] = 200;
// The code that should happen if an error occurs goes in the “catch” section.
} 
catch (Exception e){ //this will catch any kind of exception
  println("Hey, that’s not a valid index!");
}
/*

catch (ArrayIndexOutOfBoundsException e){
  println("Hey, that’s not a valid index!"); //this will also work
}
*/

/*
catch (NullPointerException e){
  println("Hey, that’s not a valid index!");
  //this won't work because it's looking for the wrong kind of exception
}
*/
