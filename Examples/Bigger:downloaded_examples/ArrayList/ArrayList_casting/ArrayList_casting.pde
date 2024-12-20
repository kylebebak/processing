ArrayList<Float> floats = new ArrayList<Float>();

float t;

void setup() {
  floats.add(1.6);
  floats.add(1.2);
  floats.add(2.5);
}

void draw() {
  floats.set(2, (float)5);
  floats.set(0, floats.get(0)+.1);
  for (int index = 0; index < floats.size(); index++)
    println(floats.get(index));
}
