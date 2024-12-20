float r=0;
float range=5;

DrawGraph graph;

void setup() {
  size(300, 300);
  graph=new DrawGraph(r, range, 100, color(0, 255, 0), 
  250, .5, .9);
}

void draw() {

  background(0);

  r=random(0, range);
  graph.update(r);
  graph.display();
}

//DrawGraph class
class DrawGraph {
  float[] plot;
  int res;
  float input, inputrange, resf, heightfrac, widthfrac, jf, h0;
  float wp, wm, hm;
  color c;

  DrawGraph (float tinput, float tinputrange, int tres, color tc, 
  float th0, float theightfrac, float twidthfrac) {
    input=tinput;
    inputrange=tinputrange;
    res=tres;
    resf=res;
    plot=new float[res];
    plot[0]=input;

    heightfrac=theightfrac;
    widthfrac=twidthfrac;
    h0=th0;

    wp=widthfrac*width;
    wm=widthfrac*width/resf;
    hm=height*heightfrac/inputrange;

    c=tc;
  }

  void update(float newinput) {

    plot[0]=newinput;
    for (int j=res-1; j>0; j--) {
      plot[j]=plot[j-1];
    }
  }


  void display() {

    for (int j=0; j<res-1; j++) {
      float jf=j;
      stroke(c);
      line(wp-wm*jf, h0-hm*plot[j], wp-wm*(jf+1), h0-hm*plot[j+1]);
      //line(widthfrac*width*(1-jf/resf), h0-height*heightfrac*plot[j]/inputrange, 
      //widthfrac*width*(1-(jf+1)/resf), h0-height*heightfrac*plot[j+1]/inputrange);
    }
  }
}

