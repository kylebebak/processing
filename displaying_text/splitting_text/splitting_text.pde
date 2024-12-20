//String[] test = loadStrings("test.rtf"); //rtf files don't work, but simple text files do
String[] test= loadStrings("test3.txt");

ArrayList allWords = new ArrayList();

for (int l=0; l<test.length; l++) {
  String[] words=split(test[l], " ");
  allWords.add(words);
}

for (int i=0; i<allWords.size(); i++) {

  String[] temp=(String[]) allWords.get(i);

  for (int j=0; j<temp.length; j++) {
    println(temp[j]);
  }
}

