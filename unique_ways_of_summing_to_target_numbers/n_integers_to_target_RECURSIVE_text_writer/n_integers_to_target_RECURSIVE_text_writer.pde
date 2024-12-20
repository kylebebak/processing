/*this code is written recursively so that the number of digits
 being summed up to the target value can be changed. the recursive
 function allows for a dynamic number of for loops to be called
 */

int counter=0;
PrintWriter nums;
/*print in the font marker felt, it looks good.
also, try printing different digits in different colors*/

void setup() {

  nums = createWriter("numbers.txt");
  checksum(30, 30);

}



void checksum(int digits, int target) {

  int[] indices=new int[digits];
  checksumt(digits+1, digits, target, 0, 0, indices);
  
  println(counter);
  nums.println(counter);
  nums.flush();
  nums.close();
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
    for (int j=0; j<indices.length; j++) nums.print(indices[j] + "  ");
    nums.println();
  }
}

