


void setup() {

  String path = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/XX__WebAndMobileApps/Projects/Spot_It/images/final_clipart/";


  File file = new File(path);
  String[] list = file.list();

  for (String fileName : list) {
    println(fileName);
  }

  File[] files = file.listFiles();



  PImage[] pics = new PImage[list.length - 1];
  for (int i = 1; i < list.length; i++) {
    // starting from 1 avoid trying to load hidden osx file .DS_Store
    pics[i - 1] = loadImage(path + list[i]);
    // pics.add(loadImage(files[i].getAbsolutePath())); // works outside of data folder
  }

  println(pics.length);







  int nx = 10;
  int ny = 10;

  int dx = 200;
  int dy = 200;

  size(nx * dx, ny * dy);
  
  for (int i = 0; i < pics.length; i++) {
    image(pics[i], dx * (i % nx), dy * (i / nx));
  }
  get().save("/Users/kylebebak/Desktop/sprites.png");
}
