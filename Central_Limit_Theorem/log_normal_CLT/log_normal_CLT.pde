int variables=1;
float range=10;
//upper range for any variable is normalized to the value entered here
float minrange=0;
//minrange must be set depending on which random variable is being used
//minrange=0 for power and exponential variables
//minrange=1 for negative power and natural log variables
int resolution=900;
float resolutionf=resolution;
//if width/resolution is an integer, then there are no black spaces 
//in between the columns
//columns
float resf=resolution;
int trials=1000000;

float power=2;
//change power to change shape of random power variables
//pow=0 is flat, power=1 is linear, power=2 is quadratic, etc 
//power must be negative for negative power variables.
//for the reciprocal function, power=-1, a separate distribution
//is activated below, because the antiderivative of 1/x is not
//a constant--it's ln(x)
float xprod;
//product of random variables
int[] frequency=new int[resolution];
//screen will be split into a number of columns equal to
//the value of "resolution"
int pos;
//used for finding index of most common value
float r;

float zoom=1;
//allows user to zoom in and out on distribution

void setup() {
  size(1200, 600);
  smooth();
  noStroke();
  noLoop();
}

PFont f;

void draw() {

  if (key == '=') {
    zoom=2*zoom;
  }

  if (key == '-') {
    zoom=.5*zoom;
  }

  if (key == 's') {
    zoom=1;
  }

  if (key == '2') {
    variables+=1;
  }

  if (key == '1') {
    variables-=1;
  }

  if (variables<1) {
    variables=1;
  }

  if (key == 'w') {
    range+=1;
  }

  if (key == 'q') {
    range-=1;
  }

  if (range<1) {
    range=1;
  }

  float maxprod=pow(range, variables);
  float ratio=resf/(maxprod/zoom);
  frequency=new int[resolution];


  float rpow=pow(range, power+1);
  float rpow0=pow(0, power+1);

  float rrecip=log(range);
  float rrecip0=log(1);
  //corresponds to lower range =1, upper range must be greater than 1

    float rexp=exp(range);
  float rexp0=exp(0);

  float rln=range*log(range)-range;
  float rln0=1*log(1)-1;
  //corresponds to lower range =1, upper range must be greater than 1
  //i can't implement this function without the lambert w function

  float negpow=pow(range, power+1);
  float negpow0=pow(1, power+1);
  //corresponds to lower range =1, upper range must be greater than 1
  
  float u=5;
  //mean of lorentz and bell shaped distributions
  float s=.5;
  //width parameter
  float lor=-atan((u-range)/s)/s;
  float lor0=-atan((u-0)/s)/s;
  
  //this actually works really well, it's a bell curve that drops off like exp(-x)
  //instead of exp(-x^2)
  float bell=pow(1+exp(-(1/s)*(range-u)),-1);
  float bell0=pow(1+exp(-(1/s)*(0-u)),-1);
  
    for (int i=0; i<trials; i=i+1) {
    xprod=1;
    for (int j=0; j<variables; j=j+1) {
      
      if (power>=0) {
      r=pow(random(rpow0, rpow), 1 / (power+1));
      }
      //positive power variables

      if ((power>-1) && (power<0)) {
        r=pow(random(negpow0, rpow), 1 / (power+1));
      }
      if (power<-1) { 
        r=pow(random(negpow, negpow0), 1 / (power+1));
      }
      //negative power variables, random is chosen between negpow and negpow0
      //instead of other way around because variable has a negative derivative
      
      if (power==-1) {
      r=exp(random(rrecip0, rrecip));
      }
      //reciprocal (1/x) variable
      
      //r=log(random(rexp0,rexp));
      //exponential variable. it's calculated last so that the code above doesn't
      //have to be grayed out
      
      //r=-(-u+(s*tan(-s*random(lor0,lor))));
      //lorentzian variable. it doesn't converge because its moments
      //aren't defined!
      
      r=u-s*log(-1+1/ (random(bell0,bell)));
      //bell shaped variable with mean u and width parameter s

      //float r=random(rln0,rln);
      //natural log variable, lower range is 1, upper range must be greater than 1
      //i need the inverse of x*ln(x)-x, the lambert w function, to make this work

      xprod=r*xprod;
    }
    int xprodi=floor(ratio*xprod);
    if ((xprodi<=resolution-1) && (xprodi>-1)) {
      frequency[xprodi]=frequency[xprodi]+1;
    }
    //this keeps program from trying to enter values that don't
    //fit into this array
  }

  background(0);

  for (int k=0; k<resolution; k=k+1) {
    fill(255, 0, 0);
    rect(k*width/resolution, height, width/resolution, -.75*height*frequency[k]/max(frequency));
    //max(array) returns the largest value in an array, very useful
  }

  int maxv=0;
  //lowest possible value in the array
  for (int i=0; i<resolution; i++) {
    if (frequency[i]>maxv) {
      pos=i;
      maxv=frequency[i];
    }
  } 
  float posf=pos;

  String lower = "lower = 0";
  String upper = "upper = " + nf(maxprod/zoom, 1, 5);
  f=loadFont("Courier-16.vlw");
  textFont(f, 16);
  fill(255, 255, 0);
  textAlign(LEFT);
  text(lower, 0, 20);
  textAlign(RIGHT);
  text(upper, width, 20);
  textAlign(CENTER);
  text("variable range = " + nf(minrange, 1, 1) + " through " + nf(range, 1, 1), .5*width, .1*height);
  text("number of variables = " + nf(variables, 1, 0), .5*width, .1*height+25);
  text(nf((maxprod/zoom)*posf/resolutionf, 1, 2), posf*width/resolutionf, .25*height-10);
}

void keyPressed() {
  redraw();
}

