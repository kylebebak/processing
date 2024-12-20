float[][] Counter;
float counter=0;
float n;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  noStroke();

  for (int i=0; i<40; i++) {
    for (int j=0; j<40; j++) {
      fill(40+20*noise(.15*(i+j), .15*(i-j)), 
      80+20*noise(.15*(i-j), .15*(i+j)), 
      100-20*noise(.15*(.8*i+j), .15*(j-i)));
      rect(15*i, 15*j, 15, 15);
    }
  }
  filter(BLUR, 5);
  
  Counter=new float[40][40];
}



void draw() {
  counter+=random(.013, .025);

  if (frameCount%5==0) {

    for (int i=0; i<40; i++) {
      for (int j=0; j<40; j++) {
        
        fill(37.5+25*noise(.15*(i+j), .15*(i-j), counter), 
        60+40*noise(.15*(i-j), .15*(i+j), -.85*counter), 
        100-40*noise(.15*(i+j), .15*(j-i), .85*counter));
        rect(15*i, 15*j, 15, 15);
      }
    }

    filter(BLUR, 3);
  }

  println(frameRate);
  println(n);
}

