void oscEvent(OscMessage men) {
  if (men.addrPattern().equals("/acc")) {
    accelerometerX = men.get(0).floatValue();
    accelerometerY = men.get(1).floatValue();
    accelerometerZ = men.get(2).floatValue();
  }
  
  if (men.addrPattern().equals("/ori")) {
    alpha = men.get(0).floatValue();
    beta = men.get(1).floatValue();
    gamma = men.get(2).floatValue();
  }
}