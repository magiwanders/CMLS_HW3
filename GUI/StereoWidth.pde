import java.text.DecimalFormat;

public class StereoWidth{
    
  float xPan, yPan, dPan, rounded;
  
  public void setup() {
    frameRate(200);
    xPan = width * 0.82;
    yPan = height * 0.3 + (7 * height * 0.07);
    dPan = width * 0.05;
    rounded = 1;
    stroke(255);
    strokeWeight(5);
    

  }
  
  void init() {

    rectMode(CENTER);
    fill(color(20,20,20));
    rect(xPan, yPan, dPan, dPan, rounded);
    
  }
  float i = 0;
  public void reSize(float e){
  i = i + (e*5);
  if(i > width * 0.03 && i < width * 0.1){
    dPan = i;
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
  
  println(dPan);
  
  float msg = (dPan - width*0.03) / (width * 0.1 - width * 0.03);
  
  msg = round(msg*10)/10.0;
  
  println("To supercollider: " + msg);
  sendMsgOSC("/pan", msg);
  }
}
