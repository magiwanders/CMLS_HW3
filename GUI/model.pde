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
