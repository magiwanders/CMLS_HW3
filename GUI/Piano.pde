public class PianoKeyboard{
  
  int x, y, w_size, h_size;
  
  public PianoKeyboard(int xPosition, int yPosition, int w, int h){
    x = xPosition;
    y = yPosition;
    w_size = w;
    h_size = h;
  }
  
  void setup(){
  size(w_size,h_size);
  background(255);
}
  
  void draw(){
  int keyWidth= 0;
  int whiteWidth= w_size/8;
  float blackHeight= h_size*3/5;
  float blackWidth= whiteWidth/2;
  int blackHover= -1;
 
  for (int i=0; i<8; i++){
    float keyHeight= whiteWidth*(i+1)- blackWidth/2;
    if(mouseX> keyHeight && mouseX <= keyHeight+blackWidth && 
    mouseY <= blackHeight && i !=2){
    blackHover = i;
    }
  }
  for( int whiteKey=0; whiteKey < 8; whiteKey++){
    stroke(1);
    int keyHeight = whiteKey * whiteWidth;
    if(mouseX >= keyHeight && mouseX <= keyHeight+ whiteWidth && mouseY<= whiteWidth &&
    mousePressed && blackHover == keyHeight){
      fill(255,0,0);
    } else if(mouseX> keyHeight && mouseX <=keyHeight+ whiteWidth && blackHover == -1){
      fill(255,250,200);
    }else{
      fill(255);
    }
    rect(keyHeight, keyWidth, whiteWidth, height);
  }
  for(int blackKey=0; blackKey<6; blackKey++){
    noStroke();
    float keyHeight= whiteWidth*(blackKey+1)- blackWidth/2;
    if(blackKey==2){
      keyHeight= whiteWidth*(blackKey+1)-blackWidth/2+whiteWidth;
    }
    fill(0);
    blackHover= blackKey;
    if(mouseX> keyHeight&&mouseX<=keyHeight+blackWidth && mouseY<= blackHeight
    && mousePressed &&blackHover== blackKey){
      stroke(2);
      fill(0,255,255);
    }else if(mouseX>keyHeight&& mouseX<= keyHeight+ blackWidth&& mouseY <= blackHeight&& 
    blackHover== blackKey){
      stroke(2);
      fill(50,255,50);
    }else{
      fill(0);
    }
    rect(keyHeight, keyWidth, blackWidth, blackHeight);
  }
}
  
}
