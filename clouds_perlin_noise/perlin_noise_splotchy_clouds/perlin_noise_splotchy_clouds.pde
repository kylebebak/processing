size(400, 400);

color sky=#A2F8FF;
color clouds=#FFFFFF;
float n;

loadPixels();
 for(int j=0; j<height; j++) {
for(int i=0; i<width; i++) {
   
   n=noise(.04*i, .04*j);
   
  if (n>=.4) pixels[i+j*width]=sky;
  else pixels[i+j*width]=clouds;
  
 }
}
updatePixels();
