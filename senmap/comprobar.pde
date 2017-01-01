void mouseReleased() {
  bUp1 = false;
  bUp2 = false;
  bUp3 = false;
  bUp4 = false;
  bDo1 = false;
  bDo2 = false;
  bDo3 = false;
  bDo4 = false;
  
  if (sobre(posX1, posY1, tamX, tamY) == true) {
    n1mas();
  }
  if (sobre(posX2, posY1, tamX, tamY) == true) {
    n2mas();
  }
  if (sobre(posX3, posY1, tamX, tamY) == true) {
    n3mas();
  }
  if (sobre(posX4, posY1, tamX, tamY) == true) {
    n4mas();
  }
  
  if (sobre(posX1, posY2, tamX, tamY) == true) {
    n1menos();
  }
  if (sobre(posX2, posY2, tamX, tamY) == true) {
    n2menos();
  }
  if (sobre(posX3, posY2, tamX, tamY) == true) {
    n3menos();
  }
  if (sobre(posX4, posY2, tamX, tamY) == true) {
    n4menos();
  }
}

void mousePressed(){
  if (sobre(posX1, posY1, tamX, tamY) == true) {
    bUp1 = true;
  }
  if (sobre(posX2, posY1, tamX, tamY) == true) {
    bUp2 = true;
  }
  if (sobre(posX3, posY1, tamX, tamY) == true) {
    bUp3 = true;
  }
  if (sobre(posX4, posY1, tamX, tamY) == true) {
    bUp4 = true;
  }
  
  if (sobre(posX1, posY2, tamX, tamY) == true) {
    bDo1 = true;
  }
  if (sobre(posX2, posY2, tamX, tamY) == true) {
    bDo2 = true;
  }
  if (sobre(posX3, posY2, tamX, tamY) == true) {
    bDo3 = true;
  }
  if (sobre(posX4, posY2, tamX, tamY) == true) {
    bDo4 = true;
  }
}