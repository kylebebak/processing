PrintWriter digits = createWriter(".txt");
String[] lines = loadStrings(".txt");


println(lines.length);
println(lines[0].length());


for (int j=0; j<lines.length; j++) {
  //println();
  //for (int i=0; i<10; i++) digits.print(lines[j].substring(11*i, 11*i+10));
  digits.print(lines[j]);
}

digits.flush();
digits.close();

