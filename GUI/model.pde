// lettura MIDI
// SimpleMidi.pde

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 
import oscP5.*;
import netP5.*;

MidiBus myBus; 

int currentColor = 0;
int midiDevice  = 0;
int fundamental = 60;
int numHarmonics = 3;
int[] harmonics = new int[numHarmonics];

void controllerInit() {
  setHarmonics();
  MidiBus.list(); 
  myBus = new MidiBus(this, midiDevice, 1); 
  oscP5 = new OscP5(this,12000);
  netAddress = new NetAddress("127.0.0.1", 57120);
}

void setHarmonics() {
  for ( int i = 0; i < numHarmonics; i++ ){
    harmonics[i] = 0;
  }
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/playedNote") == true && msg.get(0) != null ) {
      fundamental = (int)msg.get(0).floatValue();
      println(" values: " + fundamental);
      return;
    }
    else if ( msg.checkAddrPattern("/superOn") == true){
      isOn = false;
    }
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
  int note = (int)(message.getMessage()[1] & 0xFF) ;
  int vel = (int)(message.getMessage()[2] & 0xFF);

  println("Bus " + bus_name + ": Note "+ note + ", vel " + vel);
  if (vel > 0 ) {
   if ( harmonics[numHarmonics-1] != 0 ) {
      setHarmonics();
   }
   
   boolean breakCycle = false;
   
   for ( int i = 0; i < numHarmonics && !breakCycle; i++ ) {
      if (harmonics[i] == 0 ){
        harmonics[i] = note;
        breakCycle = true;
      }
    }
   
   if ( harmonics[numHarmonics-1] != 0 ) {
     println(harmonics);
     sendArrayOSC("/harmonics", harmonics);
   }
  }
}


int convertToMIDI(String note) {
  note = note.toUpperCase() + "3";
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
