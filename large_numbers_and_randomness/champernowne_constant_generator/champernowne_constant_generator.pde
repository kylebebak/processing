/*Champernowne Constant
*/

int digits = 6;

PrintWriter writer;
writer = createWriter("champernowne up to " + digits + " digits.txt");

for (int i=0; i < round(pow(10, digits)); i++) {
  writer.print(i);
}

writer.flush();
writer.close();
