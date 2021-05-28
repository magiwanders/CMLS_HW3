public class PianoKeyboard{
  
  public float x, y, w, h;
  public String[] whiteKeys = {"C", "D", "E", "F", "G", "A", "B"};
  public String[] blackKeys = {"C#", "D#", "F#", "G#", "A#"};
  
  public PianoKeyboard(){

  }
  public void setup(){
  background(255);
    x = width*0.2;
    y = height*0.2;
    w = width*0.6;
    h = height*0.35;
}
  
  public void draw(){
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
  for( int whiteKey=0; whiteKey < 8; whiteKey++){
    stroke(1);
    float keyHeight = width*0.07 + whiteKey * whiteWidth;
    if(mouseX >= keyHeight && mouseX <= keyHeight+ whiteWidth && mouseY > y  && mouseY - y <= h &&
    mousePressed && blackHover == keyHeight){
      fill(255,0,0);
      println("");
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
    float keyHeight = width*0.07 + whiteWidth*(blackKey+1)- blackWidth/2;
    if(blackKey==2){
      keyHeight= width*0.07 + whiteWidth*(blackKey+1)-blackWidth/2+whiteWidth;
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
