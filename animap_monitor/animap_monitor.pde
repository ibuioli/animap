import netP5.*;
import oscP5.*;
import processing.video.*;
import blobDetection.*;
import java.net.InetAddress;

OscP5 oscP5;
OscP5 tel;
NetAddress loc;

Capture cam;
BlobDetection theBlobDetection;
Blob b;
PImage img;
PGraphics pg2D;
String ip;
float accelerometerX, accelerometerY, accelerometerZ, 
  giroscopeX, giroscopeY, giroscopeZ;
float t;

public void setup() {
  size(640, 480, P3D);
  String[] cameras = Capture.list();

  cam = new Capture(this, cameras[0]);
  cam.start();

  //GRAFICOS//
  noSmooth();
  ortho();
  noStroke();
  rectMode(CENTER);
  pg2D = createGraphics(width, height, JAVA2D);
  ///////////

  //COMUNICACION//
  oscP5 = new OscP5(this, 12001);
  tel = new OscP5(this, 10000);
  loc = new NetAddress("127.0.0.1", 12001);
  ///////////////

  //IP//
  InetAddress inet;
  try {
    inet = InetAddress.getLocalHost();
    ip = inet.getHostAddress();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  ////

  //BLOB DETECTION//
  img = new PImage(640, 480); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  t = 0.6;
  //////////////////
}

public void captureEvent(Capture cam) {
  cam.read();
}

public void draw() {
  t = constrain(t, 0, 0.95);
  theBlobDetection.setThreshold(t);

  pg2D.beginDraw();
  pg2D.background(0);
  pg2D.textSize(14);
  pg2D.text("TH: "+nf(t, 1, 2), 20, height-20);
  pg2D.text("IP: "+ip, 130, height-20);
  pg2D.pushStyle();
  pg2D.textSize(12);
  pg2D.fill(255);
  pg2D.textAlign(RIGHT);
  pg2D.text("cámara:", width-35, height-60);
  pg2D.text("acelerómetro:", width-35, height-40);
  pg2D.text("giroscopio:", width-35, height-20);
  if (cam.available() == true) {
    pg2D.fill(0, 255, 0);
    pg2D.text("OK", width-11, height-60);
  } else {
    pg2D.fill(255, 10, 10);
    pg2D.text("NO", width-10, height-60);
  }
  if (accelerometerX == 0.0 && accelerometerY == 0.0 && accelerometerZ == 0.0) {
    pg2D.fill(255, 10, 10);
    pg2D.text("NO", width-10, height-40);
  } else {
    pg2D.fill(0, 255, 0);
    pg2D.text("OK", width-11, height-40);
  }
  if (giroscopeX == 0.0 && giroscopeY == 0.0 && giroscopeZ == 0.0) {
    pg2D.fill(255, 10, 10);
    pg2D.text("NO", width-10, height-20);
  } else {
    pg2D.fill(0, 255, 0);
    pg2D.text("OK", width-11, height-20);
  }
  pg2D.popStyle();
  pg2D.endDraw();

  image(pg2D, 0, 0);

  img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
  fastblur(img, 2);
  theBlobDetection.computeBlobs(img.pixels);

  if (theBlobDetection.getBlob(0) != null) {
    b = theBlobDetection.getBlob(0);

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

    //DATOS CAMARA//
    OscMessage mx = new OscMessage("/x");
    OscMessage my = new OscMessage("/y");
    mx.add(b.x);
    my.add(b.y);
    oscP5.send(mx, loc);
    oscP5.send(my, loc);
  }

  //DATOS TELEFONO//  
  OscMessage acc = new OscMessage("/accelerometer");
  OscMessage gir = new OscMessage("/giroscope");

  acc.add(accelerometerX);
  acc.add(accelerometerY);
  acc.add(accelerometerZ);
  gir.add(giroscopeX);
  gir.add(giroscopeY);
  gir.add(giroscopeZ);

  oscP5.send(acc, loc);
  oscP5.send(gir, loc);
}