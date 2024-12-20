//this is the one!

size(200,200);

int W=200;
int H=200;

noStroke();
colorMode(HSB, W, H, H);
for (int i = 0; i < W; i++) {
  for (int j = 0; j < 4*H/5; j++) {
    stroke(i, H*pow( (float)j / (4*(float)H/5), .65 ), 
    H*pow( (float)j / (4*(float)H/5), .65 ));
    point(i, j);
  }
  for (int j = 4*H/5; j < H; j++) {
    stroke(i, H-(j-4*H/5)*5, H);
    point(i, j);
  }
}
