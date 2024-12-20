int num=100;
size(700, 600);
background(0);
smooth();

strokeWeight(3);
stroke(0, 255, 255, 40);

for(int i=0; i<num; i++) {
   line(i*width/num, 0, width, i*height/num);
}
