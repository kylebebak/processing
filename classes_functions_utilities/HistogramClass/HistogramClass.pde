String[] lines;
float[] inputarray;
boolean[] buttonstates;

Histogram hist;
Button button;


void setup() { 
  size(1200, 600);
  smooth();

  // must use absolute path of file for some stupid reason
  String fileName = "/Users/kylebebak/Desktop/Dropbox/Programming/Processing/classes_functions_utilities/HistogramClass/data/percolationFractionsMedium.txt";
  lines = loadStrings(fileName);
    inputarray=new float[lines.length];
  for (int i=0; i < lines.length; i++) {
    inputarray[i]=float(lines[i]);
  }
  println("there are " + lines.length + " data values");

  hist=new Histogram(fileName, inputarray, .001, 50.0, 1150.0, 50.0, 550.0, color(255));
  String[] names= {
    "Min/Max", "Mean/Sdev", "Median", "Mode"
  };


  button=new Button(width-150, height-150, 25, 75, 4, 0, names);
  button.changeTextColor(0);


  buttonstates=new boolean[4];
}



void draw() {
  background(127);

  button.update();

  hist.display();
  hist.disableClickZoom(button.over);
  for (int i=0; i<4; i++) buttonstates[i]=button.toggle[i];
  hist.toggleDisplayValues(buttonstates);

  button.display();
}



void keyPressed() {
  hist.keysPressed();
}

void keyReleased() {
  hist.keysReleased();
  hist.dragZoomCanceled();
  hist.toggleCumReleased();
  button.arrowKeysReleased();
}

void mousePressed() {
  hist.clickZooms();
  hist.dragZoomPressed();
  hist.dragQueryPressed();
}

void mouseDragged() {
  hist.mousePan();
}

void mouseReleased() {
  hist.dragZoomReleased();
  hist.dragQueryReleased();
  button.mouseButtonReleased();
}





class Histogram {
  /*
  i don't know why, but import java.awt.event.*; here throws an exception
  */
  float[] arr; //input array
  float binwidth, binsize, binsmax;
  float xmin, xmax, ymin, ymax;
  float minval, maxval;
  float sum, mean, sdev, median, mode;
  int binnum;
  int[] bins, cumBins;
  float[] binval;
  color c;
  boolean[] keys, toggleValues;
  float x, y;
  float w, h;
  float X, Y; //mouseX and mouseY normalized for zoom, rotations, and pans
  float mX, mY, pmX, pmY; //variables for calculating X and Y above
  float angle=0;
  float panx, pany, px, py, dpx, dpy; //variables for pan and easing
  float keypanx=0, keypany=0, kxt=0, kyt=0;
  float easing=.075;
  float mxD, myD, mxDf, myDf; //variables for box/drag zooming
  PFont font;
  float mina, maxa;
  float meanx, stanDevWidth, medianx, modex; //location of these values on histogram
  int index, indexI, indexF; //for highlighting and querying individual bin info
  boolean disableClickZoom=false, dragZoom=false, query=false, 
  dragQuery=false, dragQueryCheck=false, toggleCum=false;
  int dragZoomCounter=0, binQuerySum=0;
  String fileName;
  
  import java.awt.event.*; // for mouse wheel listener
  import java.awt.event.KeyEvent; // for VK_META and VK_SPACE 

  Histogram (String tfileName, float[] tarr, float tbinwidth, 
  float txmin, float txmax, float tymin, float tymax, color tc) {

    addMouseWheelListener(new MouseWheelListener() { 
      public void mouseWheelMoved(MouseWheelEvent mwe) {
        if (mwe.getWheelRotation() != 0) {
          float zoom=1 - (float)mwe.getWheelRotation() / 250;
          x += .5 * w * ( 1 - 1 / zoom );
          y += .5 * h * ( 1 - 1 / zoom );
          w *= 1 / zoom;
          h *= 1 / zoom;
        }
      }
    }
    );

    fileName=tfileName;
    arr=tarr;
    binwidth=tbinwidth;
    xmin=txmin;
    xmax=txmax;
    ymin=tymin;
    ymax=tymax;
    c=(color)tc;

    font=createFont("EurostileBold", 48);
    toggleValues=new boolean[4];

    keys=new boolean[9];
    w=width;
    h=height;
    x=0;
    y=0;
    panx=0;
    pany=0;
    px=0;
    py=0;
    dpx=0;
    dpy=0;

    int binnummin=floor( min(arr) / binwidth );
    int binnummax=floor( max(arr) / binwidth ) + 1;
    binnum=binnummax-binnummin;
    minval=binnummin * binwidth;
    maxval=binnummax * binwidth;

    sum=0;

    bins=new int[binnum];
    binval=new float[binnum];
    cumBins=new int[binnum];

    //the highest binval is highest array value floored to the nearest integer binwidth, plus one binwidth
    for (int i=0; i<binval.length; i++) binval[i]=minval+(i+1)*binwidth;


    /***************************************/
    //for populating the bins and calculating the mean
    for (int i=0; i<arr.length; i++) {
      bins[ floor( (arr[i]-minval) / binwidth ) ]+=1; //bins populated here!
      sum+=arr[i];
    }
    int cumSum=0;
    for (int i=0; i<cumBins.length; i++) {
      cumSum+=bins[i];
      cumBins[i]=cumSum;
    }
    /***************************************/


    mean=sum/arr.length;
    sum=0;

    //for calculating standard deviation
    for (int i=0; i<arr.length; i++) sum+=sq(arr[i]-mean);
    sdev=sqrt(sum/arr.length);

    binsmax = (float)max(bins);
    binsize = (xmax - xmin) / (float)binnum;

    /*calculate mode and median in the following blocks of code
     */
    float currentmax=min(bins); //find index of max(bins) to get mode
    int pos=0;
    for (int i=0; i<bins.length; i++) {
      if (bins[i]>currentmax) {
        pos=i;
        currentmax=bins[i];
      }
    }
    mode=minval + (pos + .5) * binwidth;
    //get the value from the middle of the bin, best estimate of mode

    float binssum=0;
    for (int i=0; i<bins.length; i++) {
      binssum+=bins[i];
      if (binssum>arr.length/2) {
        pos=i;
        break;
      }
    }
    median=minval + (pos + .5) * binwidth;

    /*variables for optimizing draw rate*/
    meanx=xmin + (floor( (mean-minval) / binwidth ) + .5 ) * binsize;
    stanDevWidth=sdev * binsize / binwidth;
    medianx=xmin + (floor( (median-minval) / binwidth ) + .5 ) * binsize;
    modex=xmin + (floor( (mode-minval) / binwidth ) + .5 ) * binsize;

    mina=min(arr);
    maxa=max(arr);

    println("min = " + min(arr));
    println("max = " + max(arr));
    println("mean = " + mean);
    println("median = " + median);
    println("mode = " + mode);
    println("standard deviation = " + sdev);
    println();
    countValues(mean - sdev, mean + sdev); // ____ values between ____ and ____
    countValues(mean - 2*sdev, mean + 2*sdev);
    countValues(mean - 3*sdev, mean + 3*sdev);
  }



  void display() {

    try { /*all the code in display has to be tried, because certain transforms,
     especially zooms, cause exceptions when histogram is drawn*/

      rectMode(CORNER);
      stroke(0);
      fill(c);

      /*mouse and key pan doesn't happen instantaneously, it eases
       towards its target value like a capacitor filling up */
      if (abs(panx - px) * width / w < .02 ) px=panx;
      if (abs(pany - py) * height / h < .02 ) py=pany;
      //above code prevents "neverending inchworm pan"
      if (px != panx || py != pany) {
        dpx= (panx - px) * easing;
        dpy= (pany - py) * easing;
        x -= dpx;
        y -= dpy;
        px += dpx;
        py += dpy;
      }

      if (keys[0]) angle+=radians(-2);
      if (keys[1]) angle+=radians(2);


      /*******************************************/
      pushMatrix();

      //code for rotation about the center of the screen
      translate(width/2, height/2);
      rotate(angle);
      translate(-width/2, -height/2);
      //these are the only scales and translates necessary for non-rotated frames
      scale( width / w, height / h);
      translate(-x, -y);
      /*******************************************/


      strokeWeight( min(w/width, h/height) ); //scale it so it doesn't get huge if you zoom in


      /*******************************************/
      //drawing bins in histogram
      fill(255);
      for (int i=0; i<bins.length; i++) rect(xmin + binsize*i, ymin, binsize, 
      (ymax-ymin) * (float)bins[i] / binsmax);
      if (query) {
        fill(255, 0, 0, 100);
        if (!toggleCum) rect(xmin + binsize*index, ymin, binsize, 
        (ymax-ymin) * (float)bins[index] / binsmax);
        else rect(xmin + binsize*index, ymin, binsize, 
        (ymax-ymin) * (float)cumBins[index] / arr.length);
      }
      if (dragQueryCheck) {
        if (max(indexI, indexF) >= 0  &&  min(indexI, indexF) < bins.length) {
          fill(255, 0, 0, 100);
          for ( int i = min(indexI, indexF); i <= max(indexI, indexF); i++) {
            binQuerySum+=bins[i];
            rect(xmin + binsize*i, ymin, binsize, 
            (ymax-ymin) * (float)bins[i] / binsmax);
          }
        }
      }
      fill(0, 0, 255, 50);
      if (toggleCum) {
        for (int i=0; i<cumBins.length; i++) rect(xmin + binsize*i, ymin, binsize, 
        (ymax-ymin) * cumBins[i] / arr.length);
      }
      /*******************************************/


      /*values displayed on graph that can be toggled on and off*/
      textAlign(CENTER);
      textFont(font, 20);
      fill(255, 150);
      text(fileName, width/2, ymin-20);

      textFont(font, 6);

      if (toggleValues[0]) { //min and max
        line(xmin+binsize/2, ymin, xmin+binsize/2, ymin-10);
        text("min", xmin+binsize/2, ymin-18);
        text(nf(mina, 1, 4), xmin+binsize/2, ymin-12);

        line(xmax-binsize/2, ymin, xmax-binsize/2, ymin-10);
        text("max", xmax-binsize/2, ymin-18);
        text(nf(maxa, 1, 4), xmax-binsize/2, ymin-12);
      }

      if (toggleValues[1]) { //mean and sdev
        line(meanx, ymin, meanx, ymin-10);
        text("mean", meanx, ymin-18);
        text(nf(mean, 1, 4), meanx, ymin-12);

        line(meanx, ymin, meanx, ymin-10);
        text("mean", meanx, ymin-18);
        text(nf(mean, 1, 4), meanx, ymin-12);
        strokeWeight( 2 * min(w/width, h/height) );
        stroke(255, 0, 0, 150);
        line(meanx - stanDevWidth, ymin+10, meanx + stanDevWidth, ymin+10);
        line(meanx - stanDevWidth, ymin+2.5, meanx - stanDevWidth, ymin+17.5);
        line(meanx + stanDevWidth, ymin+2.5, meanx + stanDevWidth, ymin+17.5);
        stroke(0);
        strokeWeight( min(w/width, h/height) );
      }

      if (toggleValues[2]) { //median
        line(medianx, ymin, medianx, ymin-10);
        text("median", medianx, ymin-18);
        text(nf(median, 1, 4), medianx, ymin-12);
      }

      if (toggleValues[3]) { //mode
        line(modex, ymin, modex, ymin-10);
        text("mode", modex, ymin-18);
        text(nf(mode, 1, 4), modex, ymin-12);
      }

      strokeWeight(1.0); //scale it back to 1 for non-scaled shapes in sketch

      popMatrix();


      //for displaying queried values
      if (query) {
        fill(0);
        textFont(font, 15);
        if (!toggleCum) {
          text((minval + index*binwidth) + "  -  " + (minval + (index+1)*binwidth), mouseX, mouseY-15);
          text(bins[index], mouseX, mouseY);
        } 
        else text(cumBins[index] + "  less than  " + (minval + (index+1)*binwidth), mouseX, mouseY-15);
        query=false;
      }

      if (dragQueryCheck) {
        fill(0);
        textFont(font, 15);
        text(binval[min(indexI, indexF)] - binwidth + " thru " 
          + binval[max(indexI, indexF)], mouseX, mouseY-15);
        text(binQuerySum, mouseX, mouseY);
        binQuerySum=0;
      }


      //for drawing drag zoom and drag query boxes
      dragZoomDraw();
      dragQueryDraw();

      //keys[2] is tied to 'shift' for query
      if (keys[2] && !dragQuery) {
        float[] m=mouseRotate(constrain(mouseX, 0, width), 
        constrain(mouseY, 0, height), angle, width/2, height/2);
        mX=m[0];
        mY=m[1];
        X= x + mX * w/width;
        Y= y + mY * h/height;
        if (X>xmin && X<xmax) {
          index=constrain( floor( (X-xmin) / binsize), 0, bins.length-1);
          if (!toggleCum) {
            if (Y > ymin && Y < ymin + (ymax-ymin) * (float)bins[index] / binsmax ) query=true;
          } 
          else {
            if (Y > ymin && Y < ymin + (ymax-ymin) * (float)cumBins[index] / arr.length ) query=true;
          }
        }
      }


      if (dragQuery) {
        float[] m=mouseRotate(constrain(mxD, 0, width), 
        constrain(myD, 0, height), angle, width/2, height/2);
        mX=m[0];
        mY=m[1];
        X= x + mX * w/width;
        Y= y + mY * h/height;
        indexI=constrain(floor( (X-xmin) / binsize), 0, bins.length-1);
        if (Y > ymin && Y < ymin + (ymax-ymin) * (float)bins[indexI] / binsmax ) dragQueryCheck=true;

        m=mouseRotate(constrain(mouseX, 0, width), 
        constrain(mouseY, 0, height), angle, width/2, height/2);
        mX=m[0];
        mY=m[1];
        X= x + mX * w/width;
        Y= y + mY * h/height;
        indexF=constrain(floor( (X-xmin) / binsize), 0, bins.length-1);
      }


      /*key panning, WASD tied to booleans. also, holding keys
       will cause panning speed to increase towards a threshold*/
      if (keys[5] || keys[6] || keys[7] || keys[8]) {
        if (abs(keypanx) < 3.5) {
          if (keys[5]) keypanx += 7;
          if (keys[6]) keypanx -= 7;
        }
        if (abs(keypany) < 3.5) {
          if (keys[7]) keypany += 7;
          if (keys[8]) keypany -= 7;
        }
        if (keys[5] && keys[6]) keypanx=0;
        if (keys[7] && keys[8]) keypany=0;

        if (keypanx<0 && keys[5] && !keys[6]) keypanx += 8;
        if (keypanx>0 && keys[6] && !keys[5]) keypanx -= 8;
        if (keypany<0 && keys[7] && !keys[8]) keypany += 8;
        if (keypany>0 && keys[8] && !keys[7]) keypany -= 8;

        if (keys[5]) keypanx += .02 * abs(keypanx);
        if (keys[6]) keypanx -= .02 * abs(keypanx);
        if (keys[7]) keypany += .02 * abs(keypany);
        if (keys[8]) keypany -= .02 * abs(keypany);
        keypanx=constrain(keypanx, -30, 30);
        keypany=constrain(keypany, -30, 30);

        kxt = keypanx * cos(-angle) - keypany * sin(-angle);
        kyt = keypanx * sin(-angle) + keypany * cos(-angle);
        panx += kxt * w/width;
        pany += kyt * h/height;
      }
      if (!keys[5] && !keys[6]) keypanx=0;
      if (!keys[7] && !keys[8]) keypany=0;


      /*mouse trackpad scrolling. if keys[4] is true image can be panned with trackpad.
       pan is speed sensitive, i.e. fast movements result in larger pans*/
      if (keys[4]) { //keys[4] tied to SPACE to scroll and query simultaneously
        float[] m=mouseRotate(mouseX, mouseY, angle, width/2, height/2);
        mX=m[0];
        mY=m[1];

        m=mouseRotate(pmouseX, pmouseY, angle, width/2, height/2);
        pmX=m[0];
        pmY=m[1];

        panx += .03 * (mX-pmX) * max(35, dist(mouseX, mouseY, pmouseX, pmouseY)) * w/width; 
        pany += .03 * (mY-pmY) * max(35, dist(mouseX, mouseY, pmouseX, pmouseY)) * h/height;
      }


      if (keyPressed) { //this resets translate, scale, and rotate transformations
        if (key == 'r' || key == 'R') {
          x=0;
          y=0;
          w=width;
          h=height;
          mX=0;
          mY=0;
          angle=0;
        }
      }
    }
    catch (Exception e) { //this catches any exception in display()
      println("Probably too much zoom! Had to reset...");
      x=0;
      y=0;
      w=width;
      h=height;
      mX=0;
      mY=0;
      angle=0;
    }
  }


  void keysPressed() {
    if (keyCode == LEFT) keys[0]=true;
    if (keyCode == RIGHT) keys[1]=true;
    if (keyCode == SHIFT) keys[2]=true;
    if (keyCode == KeyEvent.VK_META) keys[3]=true;
    if (keyCode == KeyEvent.VK_SPACE) keys[4]=true;
    if (key == 'a' || key == 'A') keys[5]=true;
    if (key == 'd' || key == 'D') keys[6]=true;
    if (key == 'w' || key == 'W') keys[7]=true;
    if (key == 's' || key == 'S') keys[8]=true;
  }

  void keysReleased() {
    if (keyCode == LEFT) keys[0]=false;
    if (keyCode == RIGHT) keys[1]=false;
    if (keyCode == SHIFT) keys[2]=false;
    if (keyCode == KeyEvent.VK_META) keys[3]=false;
    if (keyCode == KeyEvent.VK_SPACE) keys[4]=false;
    if (key == 'a' || key == 'A') keys[5]=false;
    if (key == 'd' || key == 'D') keys[6]=false;
    if (key == 'w' || key == 'W') keys[7]=false;
    if (key == 's' || key == 'S') keys[8]=false;
  }


  void clickZooms() {
    //call in void mousePressed()
    if (disableClickZoom==false) {
      if (mouseEvent.getClickCount()==2) {
        float zoom=2.5;
        float[] m=mouseRotate(constrain(mouseX, 0, width), 
        constrain(mouseY, 0, height), angle, width/2, height/2);
        mX=m[0];
        mY=m[1];

        X= x + mX * w/width;
        Y= y + mY * h/height;
        x= X - (1 / zoom) * (X - x);
        y= Y - (1 / zoom) * (Y - y);
        w *= 1 / zoom;
        h *= 1 / zoom;
      }
    }
    if (mouseButton == RIGHT) {
      float zoom=2.5;
      float[] m=mouseRotate(constrain(mouseX, 0, width), 
      constrain(mouseY, 0, height), angle, width/2, height/2);
      mX=m[0];
      mY=m[1];

      X= x + mX * w/width;
      Y= y + mY * h/height;
      x= X - w / (2 * zoom);
      y= Y - h / (2 * zoom);
      w *= 1 / zoom;
      h *= 1 / zoom;
    }
  }


  void dragZoomPressed() {
    //called in mousePressed(). keys[3] is tied to COMMAND, keyEvent.VK_META
    if (keys[3] && dragZoom==false && dragQuery==false) {
      dragZoom=true;
      mxD=mouseX;
      myD=mouseY;
    }
  }

  void dragZoomDraw() {
    //called by default in void display
    if (dragZoom) {
      rectMode(CORNERS);
      stroke(0, 127);
      fill(127, 50);
      rect(mxD, myD, mouseX, mouseY);
    }
  }

  void dragZoomReleased() {
    //called in mouseReleased()
    if (dragZoom) {
      dragZoom=false;
      mxDf=mouseX;
      myDf=mouseY;

      float[] m=mouseRotate(constrain(mxD, 0, width), 
      constrain(myD, 0, height), angle, width/2, height/2);
      float MX=m[0];
      float MY=m[1];
      m=mouseRotate(constrain(mxDf, 0, width), 
      constrain(myDf, 0, height), angle, width/2, height/2);
      float MXf=m[0];
      float MYf=m[1];

      float zoomX=width / ( abs(MXf - MX) );
      float zoomY=height / ( abs(MYf - MY) );

      mX = min(MX, MXf);
      mY = min(MY, MYf);
      x= x + mX * w/width;
      y= y + mY * h/height;
      w *= 1 / zoomX;
      h *= 1 / zoomY;

      dragZoomCounter=0;
    }
  }

  void dragZoomCanceled() {
    //called in keyReleased(), make sure key is the same key used for zoom
    if (dragZoom) if (keyCode == KeyEvent.VK_META) dragZoomCounter++;
    if (dragZoomCounter==2) {
      dragZoomCounter=0;
      dragZoom=false;
    }
  }


  void dragQueryPressed() {
    //called in mousePressed(). keys[2] is tied to shift
    if (keys[2] && dragQuery==false && dragZoom==false) {
      dragQuery=true;
      mxD=mouseX;
      myD=mouseY;
    }
  }

  void dragQueryDraw() {
    //called by default in void display
    if (dragQuery) {
      rectMode(CORNERS);
      stroke(0, 127);
      fill(127, 50);
      rect(mxD, myD, mouseX, mouseY);
    }
  }

  void dragQueryReleased() {
    //called in mouseReleased()
    if (dragQuery) {
      dragQuery=false;
      dragQueryCheck=false;
    }
  }

  void toggleCumReleased() {
    if (key == 't' || key == 'T') toggleCum=!toggleCum;
  }


  void mousePan() {
    //call in mouseDragged(). won't do anything if dragZoom is true
    if (dragZoom==false && dragQuery==false) {
      float[] m=mouseRotate(constrain(mouseX, 0, width), 
      constrain(mouseY, 0, height), angle, width/2, height/2);
      mX=m[0];
      mY=m[1];

      m=mouseRotate(constrain(pmouseX, 0, width), 
      constrain(pmouseY, 0, height), angle, width/2, height/2);
      pmX=m[0];
      pmY=m[1];

      panx += (mX - pmX) * w/width;
      pany += (mY - pmY) * h/height;
    }
  }



  /*for counting the number of data values between a min
   and a max, this function is called by default in histogram's
   setup, for µ ± σ, 2σ, 3σ*/
  void countValues(float minval, float maxval) {
    int n=0;
    for (int i=0; i<arr.length; i++) { 
      if (arr[i]>minval && arr[i]<maxval) n++;
    }
    println( n + " values between " + nf(minval, 1, 3) + " and " + nf(maxval, 1, 3) );
    println( nf( 100 * (float)n / (float)arr.length, 1, 3) + "%");
  }

  /*for disabling the click zooms so that double clicking
   the toggle button doesn't make the histogram disappear*/
  void disableClickZoom(boolean disable) {
    if (disable) disableClickZoom=true;
    else disableClickZoom=false;
  }

  void toggleDisplayValues(boolean[] vals) {
    toggleValues=vals;
  }

  /*if the screen is rotated, this function must be called any time
   the mouse is used for zooming or panning, see above for examples*/
  float[] mouseRotate(float mx, float my, float angle, 
  float xc, float yc) { //rotate by "angle" about xc and yc
    float mtx=mx;
    float mty=my;
    mx= xc + (mtx-xc) * cos(-angle) - (mty-yc) * sin(-angle);
    my= yc + (mtx-xc) * sin(-angle) + (mty-yc) * cos(-angle);
    float[] mxmy= {
      mx, my
    };
    return mxmy;
  }
}



