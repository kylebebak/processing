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
 and also count overlapping successes,
 like if you have the number 133294799945747358 and you search for instances of 99
 it would find 2 of them. this would ideally be the same search algorithm
 that google chrome uses with the modification that if you find what you're searching for
 you don't begin the next search at the digit immediately following your success,
 but rather digit after the first digit of the success.
 
 more generally, for this algorithm to work properly,
 if you search a string of digits and find several matches but end up with a failure,
 you don't start after that failure, you follow these steps:
 
 each start occurs right after the previous start
 digits are checked until a success/failure occurs
 */



PrintWriter digits;
String[] lines = loadStrings("../root 2 10000000 digits, open with chrome.txt");
//println(lines);


for (int i=1; i<6; i++) {
  int n = round( 10000000 / pow(10, i) );
  digits = createWriter("root 2 " + n + " digits.txt");
  digits.print(lines[0].substring(0, n));
  digits.flush();
  digits.close();
}

