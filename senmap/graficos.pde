void botonA(int x, int y, int an, int al, boolean s) {
  pushStyle();
  pushMatrix();
  translate(x, y);
  strokeCap(ROUND);
  strokeWeight(int(map(height, 480, 1280, 1, 3)));
  stroke(0);
  if (s) {
    fill(0);
  } else {
    noFill();
  }
  triangle(map(width, 320, 720, an/3, an/4), al-10, an-map(width, 320, 720, an/3, an/4), al-10, an/2, map(width, 320, 720, 5, 20) );
  popMatrix();
  popStyle();
}

void botonB(int x, int y, int an, int al, boolean s) {
  pushStyle();
  pushMatrix();
  translate(x, y);
  strokeCap(ROUND);
  strokeWeight(int(map(height, 480, 1280, 1, 3)));
  stroke(0);
  if (s) {
    fill(0);
  } else {
    noFill();
  }
  triangle(map(width, 320, 720, an/3, an/4), 10, an-map(width, 320, 720, an/3, an/4), 10, an/2, al-map(width, 320, 720, 5, 20));
  popMatrix();
  popStyle();
}

void lineaQ(int y) {
  pushMatrix();
  translate(5, y);
  stroke(0);
  strokeWeight(int(map(height, 480, 1280, 1, 3)));
  strokeCap(SQUARE);
  for (int i = 0; i < width; i+=int(map(height, 480, 1280, 8, 10))) {
    line(i-map(height, 480, 1280, 2.5, 5), 0, i, 0);
  }
  popMatrix();
}