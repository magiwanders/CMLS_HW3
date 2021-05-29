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

public color PRIMARY = color(11, 78, 108);
public color SECONDARY = color(245, 158, 36);
public color ACTIVE = color(50, 150, 150);
public color BACKGROUND = color(0,14,41);

void setup(){
  customFont = createFont("Consolas", 20);
  textFont(customFont);
  textSize(25);
  text("LOADING . . .", width/2.3, height/2);
  cp5Init();
  controllerInit();
  stereoWidth.setup();
  pianoKeyboard.setup();
  bubbleNotes.setup();
  
  


}


void draw(){
  background(BACKGROUND);
  stereoWidth.init();
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


public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  stereoWidth.reSize(e);
}

  
/*//Restart all the Mover objects randomly
 public void mousePressed() {
  bubbleNotes.reset();
}*/
