String s = "to be, or not to be - - -";
//String[] words = s.split("\\s+");
String[] words = s.split(" ");
for (int i = 0; i < words.length; i++) {
  // You may want to check for a non-word character before blindly
  // performing a replacement
  // It may also be necessary to adjust the character class
  //    words[i] = words[i].replaceAll("[^\w]", "");
  println(words[i]);
  if (words[i].equals("-")) println("minus sign");
}

