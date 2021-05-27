/* Set CP5 library */
import controlP5.*;
ControlP5 cp5;

String[] musicalDropdownNotes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
String[] effectsList = {"phaser", "flanger", "chorus", "delay", "reverb", "satur"};

/* Toggle button for Harmonics */
DropdownNote[] firstDropdownNote = new DropdownNote[musicalDropdownNotes.length];
DropdownNote[] secondDropdownNote = new DropdownNote[musicalDropdownNotes.length];
DropdownNote[] thirdDropdownNote = new DropdownNote[musicalDropdownNotes.length];

Textlabel note;

Button midiButton;
Button onOffButton;
RadioButton harmonicRadioButton;

Slider[] effect = new Slider[effectsList.length];
Slider gain;

boolean isOn = false;
boolean isMidi = false;
boolean isFirstHarmonic = false;
boolean isSecondHarmonic = false;
boolean isThirdHarmonic = false;

void cp5Init() {
  cp5 = new ControlP5(this);
  
  int h = height / 18;
  int w = width / 10;
  
  
  /* TOP BUTTONS */
  onOffButton = cp5.addButton("OnOff")
  .setWidth(w)
  .setHeight(h)
  .setLabel("On/Off")
  .setPosition(width * 0.2, height * 0.03)
  .setFont(createFont("Consolas",12));
  
  midiButton = cp5.addButton("Midi")
    .setWidth(w)
    .setHeight(h)
    .setPosition(width * 0.4, height * 0.03)
    .setColorBackground(color(100, 100, 100))
    .setColorActive(color(50, 150, 150))
    .setLabel("MIDI")
    .setFont(createFont("Consolas",12));
   
  /* MUSICAL NOTES WITH HARMONICS */
  for (int i = 0; i < musicalDropdownNotes.length; i++){
    
    int first = i + 4;
    int second = i + 7;
    int third = i + 11;
    
    if (first >= musicalDropdownNotes.length){
      first = first - musicalDropdownNotes.length; 
    } 
    
    if (second >= musicalDropdownNotes.length){
      second = second - musicalDropdownNotes.length; 
    } 
    
    if (third >= musicalDropdownNotes.length){
      third = third - musicalDropdownNotes.length; 
    }
    
    note = cp5.addTextlabel("MusicalDropdownNote" + i)
       .setText(musicalDropdownNotes[i])
       .setFont(createFont("Georgia",20))
       .setColorValue(255)
       .setPosition(60+(i*80),175)
       .setSize(40,40);
    
    firstDropdownNote[i] = new DropdownNote (first, "first"+i, cp5, 50+(i*80),225);
    secondDropdownNote[i] = new DropdownNote (second, "second"+i, cp5, 50+(i*80),300);
    thirdDropdownNote[i] = new DropdownNote (third, "third"+i, cp5, 50+(i*80),375);
    
    firstDropdownNote[i].init();
    secondDropdownNote[i].init();
    thirdDropdownNote[i].init();
    
  }  

  /* EFFECTS SLIDERS */
  for (int i = 0; i < effectsList.length; i++){
    effect[i] = cp5.addSlider("effect" + i)
     .setLabel(effectsList[i])
     .setPosition(width * 0.75, 175 + (i*73.5))
     .setSize(200,30)  
     .setRange(0,100)
     .setValue(50)
     .setFont(createFont("Consolas",15));
     

  }
  
  /* GAIN SLIDER*/
  gain = cp5.addSlider("gain")
     .setLabel("Gain")
     .setPosition(width * 0.2,height * 0.6)
     .setSize(450,30)  
     .setRange(0,100)
     .setValue(50  )
     .setFont(createFont("Consolas",12));
     
  for (int i = 0; i < effectsList.length; i++){
    println(cp5.getController("effect" + i).getValueLabel() + " è " + effect[i].getValue());
  }
}

public void OnOff() {
  isOn = !isOn;
  int msg = isOn ? 1 : 0;
  sendMsgOSC("/onOff", (float)msg);
  println("IsOn è: " + isOn);
}

public void Midi(){
  isMidi = !isMidi;
  println("Midi è: " + isMidi);
}

public void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    println("event from controller : "+theEvent.getGroup().getCaptionLabel().getText()+" from "+theEvent.getController());
  } 
  else if (theEvent.isController()) {
    float n = theEvent.getController().getValue();
    String name = theEvent.getController().getCaptionLabel().getText();
    for (int i = 0; i < musicalDropdownNotes.length; i++){
      if(firstDropdownNote[i].getName().equals(name)){
       String note = firstDropdownNote[i].getItem((int) n);
       println(note);
       int noteMIDI = convertToMIDI(note);
       println(noteMIDI);
       sendArrayOSC("/noteModify", new int[]{1, i, noteMIDI});
       println("This is row: " + name);

      }
      if(secondDropdownNote[i].getName().equals(name)){
       String note = secondDropdownNote[i].getItem((int) n);
       println(note);
       int noteMIDI = convertToMIDI(note);
       println(noteMIDI);
       sendArrayOSC("/noteModify", new int[]{2, i, noteMIDI});
       println("This is row: " + name);
      }
      if(thirdDropdownNote[i].getName().equals(name)){
       String note = thirdDropdownNote[i].getItem((int) n);
       println(note);
       int noteMIDI = convertToMIDI(note);
       println(noteMIDI);
       sendArrayOSC("/noteModify", new int[]{3, i, noteMIDI});
       println("This is row: " + name);
      }
    }
  }
}

/*public void mousePressed(){
  for (int i = 0; i < musicalDropdownNotes.length; i++){
      if(firstDropdownNote[i].toggleHarmonic.isMousePressed()){
        firstDropdownNote[i].active();
      }
      if(secondDropdownNote[i].toggleHarmonic.isMousePressed()){
        secondDropdownNote[i].active();
      }
      if(thirdDropdownNote[i].toggleHarmonic.isMousePressed()){
        thirdDropdownNote[i].active();
      }
  }
}*/
