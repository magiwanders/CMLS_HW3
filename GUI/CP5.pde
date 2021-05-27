/* Set CP5 library */
import controlP5.*;
ControlP5 cp5;

String[] musicalDropdownNotes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
String[] effectsList = { "chorus", "flanger","phaser","satur",  "reverb", "delay"};

/* Toggle button for Intervals */
DropdownNote[] firstDropdownNote = new DropdownNote[musicalDropdownNotes.length];
DropdownNote[] secondDropdownNote = new DropdownNote[musicalDropdownNotes.length];
DropdownNote[] thirdDropdownNote = new DropdownNote[musicalDropdownNotes.length];

Textlabel[] note = new Textlabel[musicalDropdownNotes.length];

Button midiButton;
Button onOffButton;

Slider[] effect = new Slider[effectsList.length];
Slider gain;

boolean isOn = false;
public boolean isMidi = false;
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
  .setPosition(width * 0.3, height * 0.03)
  .setFont(createFont("Consolas",12));
  
  midiButton = cp5.addButton("Midi")
    .setWidth(w)
    .setHeight(h)
    .setPosition(width * 0.6, height * 0.03)
    .setColorBackground(color(100, 100, 100))
    .setColorActive(color(50, 150, 150))
    .setLabel("MIDI")
    .setFont(createFont("Consolas",12));
   
  /* MUSICAL NOTES */
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
    
    note[i] = cp5.addTextlabel("MusicalDropdownNote" + i)
       .setText(musicalDropdownNotes[i])
       .setFont(createFont("Georgia",20))
       .setColorValue(255)
       .setPosition(width*0.108+(i*width*0.05),height * 0.2)
       .setSize(40,40);
    
    firstDropdownNote[i] = new DropdownNote (first, "first"+i, cp5, width*0.1+(i*width*0.05), height * 0.3 );
    secondDropdownNote[i] = new DropdownNote (second, "second"+i, cp5, width*0.1+(i*width*0.05), height * 0.45);
    thirdDropdownNote[i] = new DropdownNote (third, "third"+i, cp5, width*0.1+(i*width*0.05), height * 0.6);
    
    firstDropdownNote[i].init();
    secondDropdownNote[i].init();
    thirdDropdownNote[i].init();
    
  } 
  
  /* Size of Gain Slider because setSize wants int*/
  float wEffect = width * 0.12;
  float hEffect = height * 0.03;

  /* EFFECTS SLIDERS */
  for (int i = 0; i < effectsList.length; i++){
    effect[i] = cp5.addSlider("effect" + i)
     .setLabel(effectsList[i])
     .setPosition(width * 0.75, height * 0.2 + (i * height * 0.1))
     .setSize((int)wEffect,(int)hEffect)  
     .setRange(0,100)
     .setValue(50)
     .setFont(createFont("Consolas",15));
     
  }
  
  /* Size of Gain Slider because setSize wants int*/
  float wGain = width * 0.4;
  float hGain = height * 0.03;
  /* GAIN SLIDER*/
  gain = cp5.addSlider("gain")
     .setLabel("Gain")
     .setPosition(width * 0.2,height * 0.8)
     .setSize((int) wGain, (int) hGain)  
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
  int msg = isMidi ? 1 : 0;
  sendMsgOSC("/MIDIonOff", (float)msg);
  println("Midi è: " + isMidi);
}

/*Methods to hide elements*/

public void textHide(){
  for (int i = 0; i < musicalDropdownNotes.length; i++){
    note[i].hide();
  }
}

public void dropdownHide(){
    for (int i = 0; i < musicalDropdownNotes.length; i++){
      firstDropdownNote[i].hide();
      secondDropdownNote[i].hide();
      thirdDropdownNote[i].hide();
    }
}

/* Methods to show elements*/

public void textShow(){
  for (int i = 0; i < musicalDropdownNotes.length; i++){
    note[i].show();
  }
}

public void dropdownShow(){
    for (int i = 0; i < musicalDropdownNotes.length; i++){
      firstDropdownNote[i].show();
      secondDropdownNote[i].show();
      thirdDropdownNote[i].show();
    }
}

/* Method to take sliders' and dropdowns' value */

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
      int row = 0;
      String note = "c";
      if(firstDropdownNote[i].getName().equals(name)){
       row = 1;
       note = firstDropdownNote[i].getItem((int) n);
      }
      if(secondDropdownNote[i].getName().equals(name)){
       row = 2;
       note = secondDropdownNote[i].getItem((int) n);
      }
      if(thirdDropdownNote[i].getName().equals(name)){
       row = 3;
       note = thirdDropdownNote[i].getItem((int) n);
      }
      if (row != 0 ) {
        println(note);
        int noteMIDI = convertToMIDI(note);
        println(noteMIDI);
        sendArrayOSC("/noteModify", new float[]{row, i, noteMIDI});
        println("This is row: " + name);
      }
      else{
          println(name);
          if ( Arrays.asList(effectsList).contains(name) ) {
            int pos = Arrays.asList(effectsList).indexOf(name);
            float value = effect[pos].getValue();
            println(value);
            setEffect(value, pos);
          }
          else {    //gain
            sendMsgOSC("/gain", gain.getValue()/100);
          }
 
      }
      
    }
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}
