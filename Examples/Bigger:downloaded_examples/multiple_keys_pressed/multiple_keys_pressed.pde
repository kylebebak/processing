float x=50; float y=50;


/**
Modified version of Option 1 multiplekeys (should provide improved performance and accuracy)
@author Yonas Sandbæk http://seltar.wliia.org (modified by jeffg)
*/
 
// usage: 
// if(checkKey(KeyEvent.VK_CONTROL) && checkKey(KeyEvent.VK_S)) println("CTRL+S");  
 

 
void setup(){
  size(200,200);
}

void draw(){
  fill(255,0,0);
  
  x=leftRightIncrement(x,1);
  y=upDownIncrement(y,-1);
  
  //if (arrowkeys[0]) y--;
  //if (arrowkeys[1]) y++;
  //if (arrowkeys[2]) x--;
  //if (arrowkeys[3]) x++;
  rect(x,y,10,10);
}
 

 
void keyPressed() {
  arrowKeyPressed();
}

void keyReleased() {
  arrowKeyReleased();
}


boolean[] keys = new boolean[526];
boolean[] arrowkeys = new boolean[4];

boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];  
  }
  return false;
}

float leftRightIncrement(float paramLeftRight, float increment) {
    if (arrowkeys[0]) paramLeftRight-=increment;
    if (arrowkeys[1]) paramLeftRight+=increment;
    return paramLeftRight;
  }

  float upDownIncrement(float paramUpDown, float increment) {
    if (arrowkeys[2]) paramUpDown-=increment;
    if (arrowkeys[3]) paramUpDown+=increment;
    return paramUpDown;
  }

void arrowKeyPressed()
{ 
  keys[keyCode] = true;
  arrowkeys[0]=checkKey(KeyEvent.VK_LEFT);
  arrowkeys[1]=checkKey(KeyEvent.VK_RIGHT);
  arrowkeys[2]=checkKey(KeyEvent.VK_DOWN);
  arrowkeys[3]=checkKey(KeyEvent.VK_UP);
  //println(KeyEvent.getKeyText(keyCode));
  //if(checkKey(CONTROL) && checkKey(KeyEvent.VK_S)) println("CTRL+S");
}
 
void arrowKeyReleased()
{ 
  keys[keyCode] = false; 
  arrowkeys[0]=checkKey(KeyEvent.VK_LEFT);
  arrowkeys[1]=checkKey(KeyEvent.VK_RIGHT);
  arrowkeys[2]=checkKey(KeyEvent.VK_DOWN);
  arrowkeys[3]=checkKey(KeyEvent.VK_UP);
}


