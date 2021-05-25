PFont customFont;
PianoKeyboard pianoKeyboard = new PianoKeyboard(100, 700);
Polygon hexagon = new Polygon(1200, 720, 70, 6);

void settings() {
  // Processing settings
  size(1500, 900, P2D);
  smooth(24);
}

void setup(){
  cp5Init();
  
  customFont = createFont("Consolas", 20);
  textFont(customFont);
  textSize(25);
  text("LOADING . . .", width/2.3, height/2);
}


void draw(){
  background(color(20,20,20));

  /* All CP5 elements*/
  cp5.draw();
  
  /* PianoKeyboard*/
  pianoKeyboard.draw();
  
  /* Pentagon */
  hexagon.draw();
}
