color sky=#2D89C1;
color clouds=#FFFFFF;
float n;

void setup() {
size(500, 500, P2D);
}


void draw() {
background(sky);


//loadPixels();

for (int j=0; j<height; j++) {
  for (int i=0; i<width; i++) {

    n=noise(.02*i, .02*j, frameCount*.02);

    //pixels[i+j*width]=color(clouds, 255*n);
    stroke( clouds, constrain(500*pow(n,3), 0, 255) );
    point(i, j);
  }
}

//updatePixels();
}
