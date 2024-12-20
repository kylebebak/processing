/*long pseudorandom number
*/

int digits = 6;

PrintWriter writer;
writer = createWriter("pseudorandom " + digits + " digits.txt");

for (int i=0; i < round(pow(10, digits)); i++) {
  writer.print(int(random(0, 10)));
}

writer.flush();
writer.close();
