public void keyPressed() {  //Control del Threshold
  if (keyCode == RIGHT) {
    t+=0.05;
  } else if (keyCode == LEFT) {
    t-=0.05;
  }
}