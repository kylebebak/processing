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


int N = 100000;


void setup() {
  
  println(N);

  Stopwatch stopwatch = new Stopwatch();

  int sum = 0;
  for (int i = 1; i <= 4*N; i = i*4)
    for (int j = 0; j < i; j++)
      sum++;

  println();
  println("Took " + stopwatch.elapsedTime() + " seconds to run");
}

