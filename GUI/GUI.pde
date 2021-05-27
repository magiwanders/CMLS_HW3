PFont customFont;


void settings() {
  // Processing settings
  size(1500, 900, P2D);
  smooth(24);

}
  PianoKeyboard pianoKeyboard = new PianoKeyboard(100, 200, 800, 280);
  BubbleNotes bubbleNotes = new BubbleNotes (0, 750, 1000, 250);

void setup(){
  cp5Init();
  controllerInit();
  pianoKeyboard.setup();
  bubbleNotes.setup();
  customFont = createFont("Consolas", 20);
  textFont(customFont);
  textSize(25);
  text("LOADING . . .", width/2.3, height/2);
  
}


  

void draw(){
  background(color(20,20,20));

  /* All CP5 elements*/
  
  if(isMidi == true){
    pianoKeyboard.draw();
    bubbleNotes.draw();
    dropdownHide();
    textHide();
  }else{
    dropdownShow();
    cp5.draw();
  }

}
