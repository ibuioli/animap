import netP5.*;
import oscP5.*;
import processing.video.*;
import blobDetection.*;

OscP5 oscP5;
NetAddress loc;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
Blob b;

float t;

boolean newFrame=false;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  
  cam = new Capture(this, cameras[0]);
  cam.start();
  noSmooth();

  oscP5 = new OscP5(this, 12001);
  loc = new NetAddress("127.0.0.1", 12001);

  img = new PImage(640, 480); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  t = 0.6;
}

void captureEvent(Capture cam) {
  cam.read();
  newFrame = true;
}

void draw() {
  t = constrain(t, 0, 0.95);
  theBlobDetection.setThreshold(t);

  if (newFrame)
  {
    newFrame=false;
    background(0);
    img.copy(cam, 0, 0, cam.width, cam.height, 
      0, 0, img.width, img.height);
    fastblur(img, 2);
    theBlobDetection.computeBlobs(img.pixels);

    if (theBlobDetection.getBlob(0) != null) {
      b=theBlobDetection.getBlob(0);

      OscMessage mx = new OscMessage("/x");
      OscMessage my = new OscMessage("/y");
      mx.add(b.x);
      my.add(b.y);

      ellipse(b.x*width, b.y*height, 12, 12);
      textSize(11);
      text(b.x, b.x*width + 8, b.y*height - 4);
      text(b.y, b.x*width + 8, b.y*height + 8);

      oscP5.send(mx, loc);
      oscP5.send(my, loc);
    }
  }

  textSize(20);
  text(t, 20, height-20);
}