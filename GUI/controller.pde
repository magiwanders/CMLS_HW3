// lettura MIDI
// SimpleMidi.pde

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 
import oscP5.*;
import netP5.*;
import java.util.Arrays;
import java.lang.String;


MidiBus myBus; 

int currentColor = 0;
int midiDevice  = 0;
int fundamental = 60;
int numHarmonics = 3;
int numEffects = 6;
int[] harmonics = new int[numHarmonics];
String[] harmonicsString = new String[numHarmonics];
int[] indexes = new int[] {-1,-1,-1};
float[] effectsValues = new float[numEffects];

void controllerInit() {
  resetHarmonics();
  resetEffects();
  MidiBus.list(); 
  
  myBus = new MidiBus(this, midiDevice, 1); 
  oscP5 = new OscP5(this,12000);
  netAddress = new NetAddress("127.0.0.1", 57120);
  sendMsgOSC("/MIDIonOff", 0);
}

void resetHarmonics() {
  for ( int i = 0; i < numHarmonics; i++ ){
    harmonics[i] = 0;
  }
}

void resetEffects(){
  for ( int i = 0; i < numEffects; i++ ){
    effectsValues[i] = 0.0;
  }
}

void setEffect(float value, int pos){
  effectsValues[pos] = value / 100;
  sendArrayOSC("/effects", effectsValues);
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/playedNote") == true && msg.get(0) != null ) {
      fundamental = (int)msg.get(0).floatValue();
      println(" values: " + fundamental);
      return;
    }
    else if ( msg.checkAddrPattern("/superOn") == true){
      isOn = false;
      isMidi = false;
    }
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
  int note = (int)(message.getMessage()[1] & 0xFF) ;
  int vel = (int)(message.getMessage()[2] & 0xFF);
  

  println("Bus " + bus_name + ": Note "+ note + ", vel " + vel);

  if (vel > 0) {
   if ( harmonics[numHarmonics-1] != 0 ) {
      resetHarmonics();
   }
   
   boolean breakCycle = false;
   
   for ( int i = 0; i < numHarmonics && !breakCycle; i++ ) {
      if (harmonics[i] == 0 ){
        harmonics[i] = note;
        
        breakCycle = true;
      }
    }
   
   if ( harmonics[numHarmonics-1] != 0 ) {
     Arrays.sort(harmonics);
     println(harmonics);
     float[] harmonicsFloat = new float[harmonics.length];
     
     for ( int i = 0; i < numHarmonics; i++ ) {  
       harmonicsFloat[i] = (float) harmonics[i];   
       String playedNoteString = convertToNote(harmonics[i]);
       harmonicsString[i] = playedNoteString;
       indexes[i] = harmonics[i] % 12;
       println("Indexes of the keys: " + indexes[i]); 

     }
     sendArrayOSC("/MIDInotes", harmonicsFloat);
     bubbleNotes.setNotes(harmonicsString);     
     bubbleNotes.reset();
     Arrays.sort(indexes);
   }
   
  pianoKeyboard.setPlayedNote(indexes);


  }
  else {
    indexes = new int[]{-1,-1,-1};
    pianoKeyboard.setPlayedNote(indexes);
  }
}


int convertToMIDI(String note) {
  note = note.toUpperCase() + "4";
  String sym = "";
  int oct = 0;
  String[][] notes = { {"C"}, {"Db", "C#"}, {"D"}, {"Eb", "D#"}, {"E"},
    {"F"}, {"Gb", "F#"}, {"G"}, {"Ab", "G#"}, {"A"}, {"Bb", "A#"}, {"B"} };

  char[] splitNote = note.toCharArray();

  // If the length is two, then grab the symbol and number.
  // Otherwise, it must be a two-char note.
  if (splitNote.length == 2) {
    sym += splitNote[0];
    oct = splitNote[1];
  } else if (splitNote.length == 3) {
    sym += Character.toString(splitNote[0]);
    sym += Character.toString(splitNote[1]);
    oct = splitNote[2];
  }

  // Find the corresponding note in the array.
  for (int i = 0; i < notes.length; i++)
  for (int j = 0; j < notes[i].length; j++) {
    if (notes[i][j].equals(sym)) {
        return Character.getNumericValue(oct) * 12 + i + 12;
    }
  }

  // If nothing was found, we return -1.
  return -1;
}

String convertToNote(int note){
  String[] notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B "};
  String noteString = notes[note%12];
 return  noteString;
}
