public class PianoKeyboard{ 
  
  float x, y, radius, angle; 
  int numPoints;
  
  public PianoKeyboard(float x_piano, float y_piano){
    x = x_piano;
    y = y_piano;    
  }
  
  int[] blackRect = {1, 1, 0, 1, 1, 1, 0, 1};
   
  String[] blackName = {"ais", "cis", "dis", "eis", "fis", "gis", "b", "cis"};
  String[] blackNote = {"ais", "cis", "dis", "eis", "fis", "gis", "b", "cis"};
   
  String[] whiteName = {"a", "c", "d", "e", "f", "g", "h", "c", "d", "e"};
   
  // this doesn't make much sense: 0 = ? But color(0) is ok.
  color[] couleur = {color(0), color(0), 0, color(0), color(0), color(0), 0, color(0)};
   
  ArrayList<Key> keys = new ArrayList();
   
  void setup() {
   
    size(300, 150);
   
   
    int width_black = 19; // width 
    int width_white = 38;// width
   
   
    // defining all keys  
   
   
    // white Rect
   
    for (int i = 0; i < 9; i++) { 
      // fill(128);
      // stroke(0);
      keys.add ( new Key (30-(i*width_white), 110, width_white, 186, 
        whiteName[i], "C-Note", 
        color(255), color(0), 
        new PVector(103, 100, 150)));
    }//for
   
    //black Rect
    for (int x = 0; x < 8; x++) {
      // fill(couleur[x]);
      // -1 is for noStroke();
      if (blackRect[x] == 1)
        keys.add ( new Key (30-(2 * x * width_black), 110, width_black, 140, 
          blackName[x], blackNote[x]+"-Note", 
          couleur[x], -1, 
          new PVector(94, 99, 151) ));
    }//for 
   
   
    //
  }// func 
   
  void mousePressed() {
    // all keys
    for (Key k : keys) {
      /*
      if (k...................) {
       // 
       println(k.name
       +" -> "
       +k.note);
       MusicBox.playNote(k.noteNumber, 1000);
       }//if
       */
    }//for
  }//func 
   
  public void draw() {
    background(0);
    
    // box
    stroke(111);
    noFill();
    //box(680, 400, 1000);
   
    // all keys
    for (Key k : keys) {
      k.display();
    }
  }
   
   
  void keyPressed() {
    //
  }
}
 
// ===========================================
// the class - a blueprint for one key 
 
class Key {
 
  float x;
  float y; 
 
  float w; 
  float h; 
 
  String name;
  String note; 
 
  color colFill;
  color colStroke; 
  color colKey; 
 
  PVector translatePVector;
 
  //constr
  Key(float x_, float y_, 
    float w_, float h_, 
    String name_, 
    String note_, 
    color colFill_, 
    color colStroke_, 
    PVector translatePVector_) {
    //
    x=x_;
    y=y_;
 
    w=w_;
    h=h_;
 
    name=name_;
    note=note_;
 
    colFill = colFill_;
    colStroke = colStroke_; 
 
    translatePVector = translatePVector_;
  }//constr
 
  void display() {
    pushMatrix();
    translate(translatePVector.x, 
      translatePVector.y   ); 
    fill(colFill);
    if (colStroke==-1) 
      noStroke(); 
    else
    stroke(colStroke);
    rect(x, y, w, h);
    popMatrix();
  }//method
 

}
