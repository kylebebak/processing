/*
find a function that will return the clock time on the computer,
call it when the program starts and again when it ends to see
exactly long it takes to run. i want to know if putting the chars
into an array like this and then comparing them from the array
is faster than using the method string.charAt(index). 

TURNS OUT IT IS MUCH FASTER. the other text searcher uses substring
to compare the targets with the characters in the text file, and this
populates an array of chars with all the chars from the text file
and then checks these chars against the target simply by accessing
them from the array
*/



Stopwatch stopwatch = new Stopwatch();

PrintWriter matches;
String fileName = "root 2 100000 digits.txt";
String fileDirectory = "../text files and formatters/" + fileName;
String[] lines = loadStrings(fileDirectory);
int linesLength = lines[0].length();
/* these text files are formatted such that there is only one line
of text in them, so lines[0].length is really the length of the whole
text file */


char[] linesc = new char[linesLength];
for (int i=0; i<linesLength; i++) linesc[i] = lines[0].charAt(i);
/* populate the linesc array with all the characters in the text
file */


String target = "0000";
int targetLength = target.length();
int num_targets = round( pow(10, targetLength) - 1 );
matches = createWriter("matches in " + fileName + ", for strings "
+ target + " - " + num_targets + ".txt");


for (int k=0; k < round(pow(10, targetLength)); k++) {

  target = nf( k, targetLength );
  char[] targetc = new char[targetLength];
  for (int i=0; i < targetLength; i++) targetc[i] = target.charAt(i);
  
  int counter=0;
  boolean check_target;
  
  
  
  /* for counting total number of strings identical to the target. this program
  will use iteration to test every string with the same number of digits
  as the initial target */
    for (int i=0; i <= linesLength - targetLength; i++) {
    check_target=true;
    
    for (int index=0; index < targetLength; index++) {

        if ( targetc[index] != linesc[i + index] ) {
        check_target=false;
        break;
      }
    }
    if (check_target) counter++;
  }

  matches.println(counter);
}

matches.flush();
matches.close();

println("Took " + stopwatch.elapsedTime() + " seconds to run");




//nf(4, 4) returns the string "0004"
//nf(17, 4) returns the string "0017"


