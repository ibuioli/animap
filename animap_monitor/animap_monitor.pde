import netP5.*;
import oscP5.*;
import processing.video.*;
import blobDetection.*;
import java.net.InetAddress;

OscP5 oscP5, tel;
NetAddress loc;

Capture cam;
BlobDetection theBlobDetection;
Blob b;
PImage img;
PFont font;
PGraphics pg2D;
String ip;
float accelerometerX, accelerometerY, accelerometerZ, 
  alpha, beta, gamma;
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
  font = loadFont("mono.vlw");
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

  img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
  fastblur(img, 2);
  theBlobDetection.computeBlobs(img.pixels);

  if (theBlobDetection.getBlob(0) != null) {
    b = theBlobDetection.getBlob(0);

    pg2D.beginDraw();
    pg2D.background(196, 196, 252);
    pg2D.fill(0);
    pg2D.textFont(font);
    pg2D.textSize(14);
    pg2D.textAlign(LEFT);
    pg2D.text("TH: "+nf(t, 1, 2), 20, height-20);
    pg2D.text("IP: "+ip, 130, height-20);
    pg2D.textSize(12);
    pg2D.textAlign(RIGHT);
    pg2D.text("camera:", width-35, height-60);
    pg2D.text("accelerometer:", width-35, height-40);
    pg2D.text("orientation:", width-35, height-20);
    if (cam.available() == true) {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-60);
    } else {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-60);
    }
    if (accelerometerX == 0.0 && accelerometerY == 0.0 && accelerometerZ == 0.0) {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-40);
    } else {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-40);
    }
    if (alpha == 0.0 && beta == 0.0 && gamma == 0.0) {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-20);
    } else {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-20);
    }
    
    pg2D.fill(0);
    pg2D.textSize(11);
    pg2D.text(b.x, b.x*width, b.y*height - 18);
    pg2D.text(b.y, b.x*width, b.y*height - 8);
    pg2D.endDraw();
    image(pg2D, 0, 0);

    fill(0);
    ellipse(b.x*width, b.y*height, 12, 12);

    pushStyle();
    noFill();
    stroke(0);
    pushMatrix();
    translate(b.x*width+55, b.y*height+55, 100);
    rotateZ(radians(accelerometerX * 10));
    rotateX(radians(accelerometerZ * 10));
    rect(0, 0, 100, 100);
    pushMatrix();
    translate(-50, -50);
    line(25, 0, 25, 100);
    line(50, 0, 50, 100);
    line(75, 0, 75, 100);
    line(0, 25, 100, 25);
    line(0, 50, 100, 50);
    line(0, 75, 100, 75);
    popMatrix();
    popMatrix();
    popStyle();

    //DATA CAMERA//
    OscMessage mx = new OscMessage("/x");
    OscMessage my = new OscMessage("/y");
    mx.add(b.x);
    my.add(b.y);
    oscP5.send(mx, loc);
    oscP5.send(my, loc);
  } else {
    pg2D.beginDraw();
    pg2D.background(196, 196, 252);
    pg2D.textFont(font);
    pg2D.textSize(14);
    pg2D.fill(0);
    pg2D.textAlign(CENTER);
    pg2D.text("-No Objects-", width/2, height/2);
    pg2D.textAlign(LEFT);
    pg2D.text("TH: "+nf(t, 1, 2), 20, height-20);
    pg2D.text("IP: "+ip, 130, height-20);
    pg2D.textSize(12);
    pg2D.textAlign(RIGHT);
    pg2D.text("camera:", width-35, height-60);
    pg2D.text("accelerometer:", width-35, height-40);
    pg2D.text("orientation:", width-35, height-20);
    if (cam.available() == true) {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-60);
    } else {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-60);
    }
    if (accelerometerX == 0.0 && accelerometerY == 0.0 && accelerometerZ == 0.0) {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-40);
    } else {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-40);
    }
    if (alpha == 0.0 && beta == 0.0 && gamma == 0.0) {
      pg2D.fill(200, 0, 0);
      pg2D.text("NO", width-10, height-20);
    } else {
      pg2D.fill(0, 130, 0);
      pg2D.text("OK", width-11, height-20);
    }
    pg2D.endDraw();
    image(pg2D, 0, 0);
  }

  //DATA PHONE//  
  OscMessage acc = new OscMessage("/acc");
  OscMessage gir = new OscMessage("/ori");

  acc.add(accelerometerX);
  acc.add(accelerometerY);
  acc.add(accelerometerZ);
  gir.add(alpha);
  gir.add(beta);
  gir.add(gamma);

  oscP5.send(acc, loc);
  oscP5.send(gir, loc);
}