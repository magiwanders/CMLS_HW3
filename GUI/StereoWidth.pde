import java.text.DecimalFormat;

public class StereoWidth{
    
  float xPad, yPad, dPad, rounded;
  
  public void setup() {
    frameRate(200);
    xPad = width * 0.82;
    yPad = height * 0.3 + (7 * height * 0.07);
    dPad = width * 0.05;
    rounded = 1;
    stroke(255);
    strokeWeight(5);
    

  }
  
  void init() {

    rectMode(CENTER);
    fill(color(20,20,20));
    rect(xPad, yPad, dPad, dPad, rounded);
    
  }
  float i = 0;
  public void reSize(float e){
  i = i + (e*5);
  if(i > width * 0.03 && i < width * 0.1){
    dPad = i;
    if( rounded > 0){
      rounded = rounded + (e*5);  
    } else {
      rounded = 1;  
    }
    
  } else {
    if (i < width * 0.03 ){
      i =  width * 0.03 + 0.01;
    } else {
      i = width * 0.1 - 0.1;
    }
  }
  
  println(dPad);
  
  float msg = (dPad - width*0.03) / (width * 0.1 - width * 0.03);
  
  int msg1 = (int)(msg * 10);
  println(msg1);
  
  msg = (float) msg1 / 10;
  
  println("To supercollider: " + msg);
  sendMsgOSC("/pan", msg);
  }
}
