size(300, 300);


float W=300;
float H=300;
int numc=8;

noStroke();
for (int j=0; j<numc; j++) {
  fill(j*255/(numc-1));
  rect(j*W/numc, 0, W/numc, H/4);
}

colorMode(HSB, 360, 100, 100);
for (int j=0; j<numc; j++) {
  fill(j*360/numc, 100, 50); 
  rect(j*W/numc, H/4, W/numc, H/4);
}
for (int j=0; j<numc; j++) {
  fill(j*360/numc, 100, 100); 
  rect(j*W/numc, 2*H/4, W/numc, H/4);
}
for (int j=0; j<numc; j++) {
  fill(j*360/numc, 50, 100); 
  rect(j*W/numc, 3*H/4, W/numc, H/4);
}
