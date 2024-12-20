// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

/* no import statement is needed, as long as the
.pde file containing the necessary class is in the
same root directory as the main .pde file
*/

// Interactive stripes

// An array of stripes
Stripe[] stripes = new Stripe[10];



void setup() {
  size(200,200);
  
  // Initialize all Stripe objects
  for (int i = 0; i < stripes.length; i ++ ) {
    stripes[i] = new Stripe();
  }
}

void draw() {
  
  background(100);
  // Move and display all Stripe objects
  for (int i = 0; i < stripes.length; i ++ ) {
    // Check if mouse is over the Stripe
    stripes[i].rollover(mouseX,mouseY); // Passing the mouse coordinates into an object.
    stripes[i].move();
    stripes[i].display();
  }
}
