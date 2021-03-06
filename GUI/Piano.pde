class PianoKeyboard{
  
  float x, y, w, h;
  int[] whiteKeys = {0, 2, 4, 5, 7, 9, 11};
  int[] blackKeys = {1, 3, 6, 8, 10};
  int[] playedNotes;

  void setup(){
  background(255);
    x = width*0.125; //<>//
    y = height*0.2;
    w = width*0.6;
    h = height*0.35;
    playedNotes  = new int[]{-1,-1,-1};
    
}
  
  void draw(){
  rectMode(0);
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
    float xPosition = x +indexWK * whiteWidth;
    
    if(isInArray(playedNotes, whiteKeys[indexWK])){
      fill(SECONDARY);
    }
    else{
      fill(255);
    }
    rect(xPosition, y, whiteWidth, h);
  }
  
  /* Draw Black Key */
  float marginLeft = x;
  float xPosition = marginLeft - blackWidth/2;
  for (int indexBK = 0; indexBK < blackKeys.length; indexBK++){
    
    xPosition = xPosition + whiteWidth;
    if (indexBK == 2){
      xPosition = xPosition + whiteWidth;
    }
    fill(0);
    
    if (isInArray(playedNotes, blackKeys[indexBK])){
      fill(SECONDARY);
    }
    else{
      fill(0);
    }
    rect(xPosition, y, blackWidth, blackHeight);
  } 
}

    /* Method to set note played by midi */
    void setPlayedNote(int[] indexes){
      playedNotes = indexes;
      println("Test: " + isInArray(playedNotes, 0));
    
    }
    /* Method to see if note played is in array */
    boolean isInArray( int[] playedNotes, int note){
       for (int i = 0; i < playedNotes.length; i++){
           if (playedNotes[i] == note){
             return true;
           }
       }
       return false;
    }




  
}
