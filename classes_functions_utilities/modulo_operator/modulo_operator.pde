void setup() {

  println(mod(-19, 12));
}


float mod(float in, float mod) {
  float quotient = in / mod;
  quotient = float(floor(quotient));
  float out = in - mod * quotient;
  return out;
}



