float angle, oldAngle = 0;

void mouseDragged(){
   angle = atan2(mouseY-height/2,mouseX-width/2) + oldAngle;
}

void mouseReleased() {
  oldAngle = angle;
}

void draw(){
      background(150);
      translate(width/2,height/2);
      rotate(angle);
      rectMode(CENTER);
      rect(0,0,25,25);
}
