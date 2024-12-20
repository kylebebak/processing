PFont myFont;
String[] myString;
int numLines;
int lineSpacing = 14;
int counter;
int cursorBlinkDelay = 15;
int numColumns = 75;

void setup(){
  size(640,480);
  frameRate(30);
  numLines = (int) (height/lineSpacing);
  smooth();
  myString = new String[numLines];
  for (int i=0; i<numLines; i++){
    myString[i] = "";
  }
  consolePrint("Welcome to the simple Processing console.");
  consolePrint("You can't do much here, the only command that's implemented is");
  consolePrint("printfile - just type 'printfile /filename.ext' to try it out.");
  counter = 0;
  myFont = createFont("Courier",48);
  textFont(myFont,14);
}

void draw(){
  background(0);
  fill(255);

  for (int i=0; i<numLines-1; i++){
    text(myString[i],5,(i+1)*lineSpacing);
  }
  String addMe = "";
  if (counter++ > cursorBlinkDelay) addMe = "_";
  if (counter > 2*cursorBlinkDelay) counter = 0;
  text(myString[numLines-1]+addMe,5,numLines*lineSpacing);
}

// This is the function you use to deal with the input
void processCommand(String s){
  if (s.length()>9 && s.substring(0,9).toLowerCase().equals("printfile")){
    printFile(s.substring(10));
  }
  else{  
    consolePrint("You said \""+s+"\"");
  }
}

void consolePrint(String s){
  myString[numLines-1] = s;
  advanceLine();
}

void advanceLine(){
  for (int i=0; i<numLines-1; i++){
    myString[i] = myString[i+1];
  }
  myString[numLines-1] = ">>> ";
}

void keyPressed(){
  if (key==ENTER||key==RETURN){
    advanceLine();
    String s = myString[numLines-2].substring(4);
    processCommand(s);
    return;
  }
  //Mac doesn't send BACKSPACE, it uses DELETE instead
  if (key==BACKSPACE||key==DELETE){
    if (myString[numLines-1].length()>4) myString[numLines-1] = myString[numLines-1].substring(0,myString[numLines-1].length()-1);
    return;
  }
  println(keyCode);
  if (key==CODED && keyCode==SHIFT) return;
  else if (key==CODED) return;
  myString[numLines-1] += key;
}

void printFile(String fileName){
  String[] tryAdding = { "","/" };
  for (int j=0; j<tryAdding.length; j++){
    String tryFileName = tryAdding[j]+fileName;
    try{
  String[] myStrings = loadStrings(tryFileName);
  for (int i=0; i<myStrings.length; i++){
    consolePrint(myStrings[i]);
  }
  return;
    } 
    catch(Exception e){
    }
  }
  consolePrint("Sorry, \""+fileName+"\" was not found.");
  return;
}
