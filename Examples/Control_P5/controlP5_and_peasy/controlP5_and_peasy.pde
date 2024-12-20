import controlP5.*;
import peasy.*;
import processing.opengl.*;
PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

int R = 40;
int G = 200;
int B = 200;

ControlP5 MyController;

color CL = #00FF1B;
int ON_OF = 0;

void setup() {

size(800, 800, OPENGL);

g3 = (PGraphics3D)g;

cam = new PeasyCam(this, 200,300,100, 500);

MyController = new ControlP5(this);

MyController.addSlider("R",0,255,128,20,100,10,100);
MyController.controller("R").setColorForeground(#FC0000);

MyController.addSlider("G",0,255,128,70,100,10,100);
MyController.controller("G").setColorForeground(#0BFC00);

MyController.addSlider("B",0,255,128,120,100,10,100);
MyController.controller("B").setColorForeground(#002CFC);

MyController.addButton("On_Of",10,20,60,80,20);

MyController.setAutoDraw(false);

}

void draw(){

if( ON_OF == 1){
strokeWeight(0);
}

else{
strokeWeight(1);}

background(R,G,B);
noFill();

stroke(R);
pushMatrix();
translate(300,200,40);
sphere(50);
popMatrix();

gui();

MyController.controller("On_Of").setColorBackground(CL);

}

void gui() {
currCameraMatrix = new PMatrix3D(g3.camera);
camera();
MyController.draw();
g3.camera = currCameraMatrix;
}

public void On_Of(){
if(ON_OF == 0){
ON_OF = 1;
CL = #FF0022;
}

else{
ON_OF = 0;
CL = #00FF1B;
}
}
