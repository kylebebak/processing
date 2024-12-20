//monte carlo simulation to determine pi, make sure to set width=height
size(600, 600);
smooth();
noStroke();
background(0);

float n=10000000;
float i;
float r=300;
float numin=0;
float x;
float y;
float pi;

for (i=0; i<=n-1; i++) {
  x=random(0,width);
  y=random(0,height);
  //fill(127);
  //ellipse(x,y,1,1);
  if (dist(x,y,width/2,height/2)<=width/2) {
    numin=numin+1;
  }
}

pi=4*numin/n;
fill(0,0,255);
ellipse(width/2,pi*100,10,10);
fill(255,0,0);
ellipse(width/2,PI*100,5,5);

println(pi);
println(PI);
