public class StereoWidth{
    
  float xPad, yPad, dPad, rounded;
  
  public void setup() {
    frameRate(200);
    xPad = width * 0.82;
    yPad = height * 0.3 + (7 * height * 0.07);
    dPad = width * 0.05;
    rounded = 1;
  }
  
  void init() {
    stroke(255);
    strokeWeight(5);
    rectMode(CENTER);
    
    rect(xPad, yPad, dPad, dPad, rounded);
    noFill();
  }
  
  public void reSize(float e){
  if(dPad > width * 0.03 && dPad < width * 0.1){
    dPad = dPad + (e*5);
    if( rounded > 0){
      rounded = rounded + (e*5);  
    } else {
      rounded = 1;  
    }
    
  } else {
    if (dPad == width * 0.03 || dPad < width * 0.03 ){
      dPad =  width * 0.03 + 1;
    } else {
      dPad = width * 0.1 - 1;
    }
  }
  
  println(dPad);
  
  float msg = (dPad - width*0.03) / (width * 0.1 - width * 0.03);
  
  println("To supercollider: " + msg);
  sendMsgOSC("/pan", msg);
  }
}
