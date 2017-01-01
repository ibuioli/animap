import netP5.*;
import oscP5.*;
import processing.video.*;
import blobDetection.*;

OscP5 oscP5;
OscP5 tel;
NetAddress loc;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
PGraphics pg2D;
float accelerometerX, accelerometerY, accelerometerZ, 
giroscopeX, giroscopeY, giroscopeZ;
Blob b;

float t;

boolean newFrame=false;

public void setup() {
  size(640, 480, P3D);
  String[] cameras = Capture.list();

  cam = new Capture(this, cameras[0]);
  cam.start();
  noSmooth();
  noStroke();
  rectMode(CENTER);

  oscP5 = new OscP5(this, 12001);
  tel = new OscP5(this, 10000);
  loc = new NetAddress("127.0.0.1", 12001);

  img = new PImage(640, 480); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  t = 0.6;
  
  pg2D = createGraphics(width, height, JAVA2D);
}

public void captureEvent(Capture cam) {
  cam.read();
  newFrame = true;
}

public void draw() {
  t = constrain(t, 0, 0.95);
  theBlobDetection.setThreshold(t);
  pg2D.beginDraw();
  pg2D.background(0);
  pg2D.textSize(20);
  pg2D.text(t, 20, height-20);
  pg2D.endDraw();
  image(pg2D, 0, 0);

  //if (newFrame)
  //{
    //newFrame=false;
    //background(0);
    img.copy(cam, 0, 0, cam.width, cam.height, 
      0, 0, img.width, img.height);
    fastblur(img, 2);
    theBlobDetection.computeBlobs(img.pixels);

    if (theBlobDetection.getBlob(0) != null) {
      b=theBlobDetection.getBlob(0);

      OscMessage mx = new OscMessage("/x");
      OscMessage my = new OscMessage("/y");
      OscMessage acc = new OscMessage("/accelerometer");
      OscMessage gir = new OscMessage("/giroscope");
      
      //DATOS CAMARA//
      mx.add(b.x);
      my.add(b.y);
      //DATOS TELEFONO//
      acc.add(accelerometerX);
      acc.add(accelerometerY);
      acc.add(accelerometerZ);
      gir.add(giroscopeX);
      gir.add(giroscopeY);
      gir.add(giroscopeZ);
      
      pushMatrix();
      translate(b.x*width+60, b.y*height+60);
      rotateZ(radians(accelerometerX * 10));
      rotateX(radians(accelerometerZ * 10));
      rect(0, 0, 100, 100);
      popMatrix();
      
      ellipse(b.x*width, b.y*height, 12, 12);
      textSize(11);
      text(b.x, b.x*width - 17, b.y*height - 18);
      text(b.y, b.x*width - 17, b.y*height - 8);

      oscP5.send(mx, loc);
      oscP5.send(my, loc);
      oscP5.send(acc, loc);
      oscP5.send(gir, loc);
    //}
  }
}