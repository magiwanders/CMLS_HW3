public class PianoKeyboard{
  
  float x, y, w, h;
  int[] whiteKeys = {0, 2, 4, 5, 7, 9, 11};
  int[] blackKeys = {1, 3, 6, 8, 10};

  
  public void setup(){
  background(255);
    x = width*0.2;
    y = height*0.2;
    w = width*0.6;
    h = height*0.35;
}
  
  void draw(){
  rectMode(0);
  int notePlayed;
    
  int whiteWidth= (int)w/8;
  float blackHeight= h*3/5;
  float blackWidth= whiteWidth/2;
  int blackHover= -1;
 
  for (int i=0; i<8; i++){
    float keyHeight = whiteWidth*(i+1)- blackWidth/2;
    if(mouseX > keyHeight && mouseX <= keyHeight+blackWidth && 
    mouseY > y  && mouseY - y <= blackHeight && i !=2){
      blackHover = i;
    }
  }
  
  /* Draw White Key */
  for( int indexWK=0; indexWK < whiteKeys.length; indexWK++){
    stroke(1);
    float xPosition = width*0.07 +indexWK * whiteWidth;
    if(mouseX >= xPosition && mouseX <= xPosition+ whiteWidth && mouseY > y  && mouseY - y <= h &&
    mousePressed && blackHover == xPosition){
      fill(255,0,0);
    } else if(mouseX > xPosition && mouseX <= xPosition+ whiteWidth && blackHover == -1  && mouseY > y  && mouseY - y <= h){
      fill(255,250,200);
    }else{
      fill(255);
    }
    
    /*if(whiteKeys[indexWK] == notePlayed){
      fill(150);
    }*/
    rect(xPosition, y, whiteWidth, h);
  }
  
  /* Draw Black Key */
  float marginLeft = width*0.07;
  float xPosition = marginLeft - blackWidth/2;
  for (int indexBK = 0; indexBK < blackKeys.length; indexBK++){
    
    xPosition = xPosition + whiteWidth;
    if (indexBK == 2){
      xPosition = xPosition + whiteWidth;
    }
    fill(0);
    if(mouseX > xPosition && mouseX <= xPosition + blackWidth && mouseY > y  && mouseY - y  <= blackHeight){
      
    }
    /*if(blackKeys[indexBK] == notePlayed){
      fill(150);
    }*/
    rect(xPosition, y, blackWidth, blackHeight);
  }
  
}
  
}
