PFont customFont;
PianoKeyboard pianoKeyboard = new PianoKeyboard(100, 200, 800, 280);
BubbleNotes bubbleNotes = new BubbleNotes (0, 750, 1000, 250);

void settings() {
  float screenWidth = displayWidth - (displayWidth*0.05);
  float screenHeight = displayHeight - (displayHeight*0.1);
  // Processing settings
  size((int)screenWidth, (int) screenHeight, P2D);
  smooth(24);
}

void setup(){
  frame.setResizable(true);
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

}
