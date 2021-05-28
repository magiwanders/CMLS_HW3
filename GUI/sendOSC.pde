import oscP5.*;
import netP5.*;
  
// OSC
OscP5 oscP5;
NetAddress netAddress;


void sendArrayOSC(String path, float[] a) {
  OscMessage msg = new OscMessage(path);
  
  for (int i = 0; i < a.length; ++i) {
    msg.add(a[i]);
  }
  msg.print();
  oscP5.send(msg, netAddress);
}

void sendMsgOSC(String path, float f) {
  OscMessage msg = new OscMessage(path);
  msg.add(f);
  msg.print();
  oscP5.send(msg, netAddress);
}
