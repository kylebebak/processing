PImage img;
PrintWriter output;
void setup() {
  size(360, 240);
  output = createWriter("rgbvalues.txt");
}
void draw() {
    float[] numbers = new float[5000000];
    numbers[0]=0;
    
 for (int i = 0; i < 2; i ++ ) {
    img = loadImage( "test" + i + ".jpg" ); 
    img.loadPixels(); 
    image(img,0,0);
 
    output.println("Image "+i);
    output.println();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int loc = x + y*width;      
        float r = red(img.pixels[loc]);
        float g = green(img.pixels[loc]);
        float b = blue(img.pixels[loc]);
        
        output.println(int(r) + "," + int(g) + "," + int(b));            
      }
    }
    
    output.println();
 }
 
output.flush(); // Writes the remaining data to the file
output.close(); // Finishes the file
exit();
}
