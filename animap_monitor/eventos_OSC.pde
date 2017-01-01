void oscEvent(OscMessage men) {
  if (men.addrPattern().equals("/accelerometer")) {
    accelerometerX = men.get(0).floatValue();
    accelerometerY = men.get(1).floatValue();
    accelerometerZ = men.get(2).floatValue();
  }
  
  if (men.addrPattern().equals("/giroscope")) {
    giroscopeX = men.get(0).floatValue();
    giroscopeY = men.get(1).floatValue();
    giroscopeZ = men.get(2).floatValue();
  }
}