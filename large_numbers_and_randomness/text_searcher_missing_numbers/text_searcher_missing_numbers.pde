/*make "pi no spaces" for 10 million digits, a million digits,
 100,000 digits, 10000 digits, 1000 digits, 100 digits
 
 do data analysis on these as well, see where assumptions of randomness
 and expected values start to break down
 
 
 
 the binomial distribution for number of successes, with lots of trials
 (and lots of successes too? i don't remember, look up binomial/normal equivalence again)
 becomes approximately normal, i could work out the probability
 of not finding any given 5 digit number in the 1,000,000 digit file 
 (this would be about .0000454 according to binomial probabilities)
 
 if i search this file successively for all 5 digit numbers
 (there would 100000 thousand searches to do on the million digit file, 
 which would probably take hours, i would expect to not find 4.54 of them,
 i.e. 4 or 5 of the numbers 0 - 99,999 would be missing from this file)
 
 easier to do would be the following. according to binomial probabilities
 the probability of not finding any given 5 digit number in the 100,000 digit file,
 or not finding any given 4 digit number in the 10,000 digit file, is about .368
 
 if i search these files respectively for a missing 5 digit and 4 digit numbers,
 i would expect to find 36,800 of them missing the in 100,000 digit file,
 and 3,680 of them missing in the 10,000 digit file.
 the first search would take roughly 10 times less than the one described in the previous paragraph.
 the second search would take 100 times less than the first search described here, certainly less than a minute
 
 
 
 also i could write a text-searching program that would look for numbers
 and also count overlapping successes, like if you have the number 133294799945747358
 and you search for instances of 99 it would find 2 of them.
 this would ideally be the same search algorithm that google chrome uses 
 with the modification that if you find what you're searching for
 you don't begin the next search at the digit immediately following your success,
 but rather the digit following the first digit of the success.
 
 more generally, for this algorithm to work properly,
 if you search a string of digits and find several matches but end up with a failure,
 you don't start after that failure, you follow these steps:
 
 each start occurs right after the previous start
 digits are checked until a success/failure occurs
 */




PrintWriter no_matches;
String filename = "root 2 100000 digits copy.txt";
String[] lines = loadStrings(filename);

String target = "00000";
int l = target.length();
int num_targets = round( pow(10, l) - 1 );
no_matches = createWriter("missing strings " + target + " - "
+ num_targets + " in " + filename);

int counter = 0;


for (int k=0; k < pow(10, l); k++) {

  target=String.valueOf(k);
  //for counting total number of strings identical to the target. this program
  //will use iteration to test every string with the same number of digits
  //as the initial target

  if (target.length() < l) {
    int d = l - target.length();
    for (int j=0; j<d; j++) target="0"+target;
  }

  boolean missing = true;
  for (int i=0; i <= lines[0].length() - target.length(); i++) {
    if ( target.equals(lines[0].substring( i, i+target.length() ) ) ) {
      missing = false;
      break;
    }
  }

  if (missing) {
    counter++;
    no_matches.println(target);
  }
}


no_matches.println();
no_matches.println(counter + " numbers missing");
no_matches.flush();
no_matches.close();


/*
SOME RESULTS
there are 3634 numbers 0000 - 9999 missing from pi 10000 digits
binomial probability predicts around 3680

there are 3651 numbers 0000 - 9999 missing from root 2 10000 digits
binomial probability predicts around 3680


there are 36722 numbers 00000 - 99999 missing from pi 100000 digits
binomial probability predicts around 36800

there are 36892 numbers 00000 - 99999 missing from root 2 100000 digits
binomial probability predicts around 3680
*/
