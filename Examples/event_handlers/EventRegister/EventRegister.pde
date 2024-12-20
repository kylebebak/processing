public class EventRegister extends PApplet {
    
    PApplet app = this;

    HFader hf1;

    public void setup() {
        size(600, 600);
        frameRate(30);
        noStroke();
        
        hf1 = new HFader();
    }

    public void draw() {
        
    }

    public class HFader {

        HFader() {
            app.registerDraw(this);
            app.registerMouseEvent(this);
        }
        
        public void draw() {
            
        }
        
        public void mouseEvent(MouseEvent e) {
            println("mouseEvent: " + e);
        }
    }
}
