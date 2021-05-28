void settings() {
  float screenWidth = displayWidth - (displayWidth*0.05);
  float screenHeight = displayHeight - (displayHeight*0.1);
  // Processing settings
  size((int)screenWidth, (int) screenHeight, P2D);
  smooth(24);
}

PFont customFont;
PianoKeyboard pianoKeyboard = new PianoKeyboard();
BubbleNotes bubbleNotes = new BubbleNotes();
StereoWidth stereoWidth = new StereoWidth();

void setup(){
  customFont = createFont("Consolas", 20);
  textFont(customFont);
  textSize(25);
  text("LOADING . . .", width/2.3, height/2);
  cp5Init();
  controllerInit();
  pianoKeyboard.setup();
  bubbleNotes.setup();
  stereoWidth.setup();
  


}


void draw(){
  background(color(20,20,20));
  
  if(isMidi == true){       //Midi GUI
    pianoKeyboard.draw();
    bubbleNotes.draw();
    dropdownHide();
    textHide();
  } else {                    
    textShow();
    dropdownShow();
    cp5.draw();
  }
  stereoWidth.init();

}


public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  stereoWidth.reSize(e);
}

  
//Restart all the Mover objects randomly
 public void mousePressed() {
  bubbleNotes.reset();
}
