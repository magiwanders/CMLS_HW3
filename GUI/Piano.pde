public class PianoKeyboard{
  
  int x, y, w, h;
  
  public PianoKeyboard(int xPosition, int yPosition, int wSize, int hSize){
    x = xPosition;
    y = yPosition;
    w = wSize;
    h = hSize;
  }
  
  public void setup(){
  background(255);
}
  
  public void draw(){
  int whiteWidth= w/8;
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
  for( int whiteKey=0; whiteKey < 8; whiteKey++){
    stroke(1);
    int keyHeight =100 + whiteKey * whiteWidth;
    if(mouseX >= keyHeight && mouseX <= keyHeight+ whiteWidth && mouseY > y  && mouseY - y <= h &&
    mousePressed && blackHover == keyHeight){
      fill(255,0,0);
    } else if(mouseX > keyHeight && mouseX <= keyHeight+ whiteWidth && blackHover == -1  && mouseY > y  && mouseY - y <= h){
      fill(255,250,200);
    }else{
      fill(255);
    }
    rect(keyHeight, y, whiteWidth, h);
  }
  
  /* Draw Black Key */
  for(int blackKey=0; blackKey<6; blackKey++){
    noStroke();
    float keyHeight = 100 + whiteWidth*(blackKey+1)- blackWidth/2;
    if(blackKey==2){
      keyHeight= 100 + whiteWidth*(blackKey+1)-blackWidth/2+whiteWidth;
    }
    fill(0);
    blackHover = blackKey;
    if( mouseX > keyHeight && mouseX <= keyHeight + blackWidth && mouseY > y  && mouseY - y  <= blackHeight
    && mousePressed && blackHover == blackKey){
      stroke(2);
      fill(0,255,255);
    }else if(mouseX > keyHeight && mouseX <= keyHeight + blackWidth && mouseY > y  && mouseY - y <= blackHeight && 
    blackHover == blackKey){
      stroke(2);
      fill(50,255,50);
    }else{
      fill(0);
    }
    rect(keyHeight, y, blackWidth, blackHeight);
  }
}
  
}
