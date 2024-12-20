/*this code is written recursively so that the number of digits
 being summed up to the target value can be changed. the recursive
 function allows for a dynamic number of for loops to be called
 */

/* simply place the .jar file in a folder called "code" in
 the same directory as the .pde file, and all packages found
 in the .jar file will automatically be added as import statements
 in the sketch, although this is invisible to the user*/

/* this sketch won't run within the dropbox folder, but it will
 run from the desktop--somehow the classpath is incorrect. then all
 i did was rename the folder containing it and everything was OK*/



int counter=0;

void setup() {

  Stopwatch stopwatch = new Stopwatch();
  checksum(20, 30);
  println();
  println("Took " + stopwatch.elapsedTime() + " seconds to run");
}



void checksum(int digits, int target) {

  int[] indices=new int[digits];
  checksumt(digits+1, digits, target, 0, 0, indices);

  println(counter);
}

void checksumt(int digits, int d0, int target, int indexSum, int index, int[] indices) {


  digits-=1;
  indexSum+=index;
  if (digits != d0) indices[(d0-1)-digits]=index;


  if (indexSum<=target) {

    if (digits>0) {
      for (int i=index; i<=target; i++) {
        checksumt(digits, d0, target, indexSum, i, indices);
      }
    }
  }


  if (digits==0) if (indexSum==target) {
    counter++;
    for (int j=0; j<indices.length; j++) print(indices[j] + "  ");
    println();
  }
}

