String[] lines;
String url = "http://www.gmail.com";
lines = loadStrings(url);
//loadStrings can load a file or connect to a url!

/*the following is for avoiding a printing error if
the sketch can't load strings from the website*/

if (lines == null) {
  // If a problem occurs connecting to the URL, we’ll just fill the array with dummy text so that the sketch can still run.
  lines = new String[3];
  lines[0] = "I could not connect to " + url + "!!!"; 
  lines[1] = "But here is some stuff to work with"; 
  lines[2] = "anyway.";
}

println(lines);
