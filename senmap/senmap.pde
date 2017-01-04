import netP5.*;
import oscP5.*;
import ketai.sensors.*;
import ketai.net.KetaiNet;

OscP5 oscP5;
NetAddress loc;

KetaiSensor sensor;
PVector accelerometer, giroscope;
PFont font;
String ip, ipNet, ip2;
String[] ipfinal, ipXt, ipNum;
int puerto;
int num1, num2, num3, num4;
int tamX, tamY, posY1, posY2;
int posX1, posX2, posX3, posX4;
boolean bUp1, bUp2, bUp3, bUp4;
boolean bDo1, bDo2, bDo3, bDo4;

public void setup() {
  fullScreen();
  orientation(PORTRAIT);
  //size(720, 1280);
  //size(320, 480);
  smooth(1);

  sensor = new KetaiSensor(this);
  sensor.start();

  accelerometer = new PVector();
  giroscope = new PVector();

  font = createFont("mono.ttf", 100, false);
  tamX = width/4;
  tamY = int( map(height, 480, 1280, 30, 100) );

  posY1 = int( map(height, 480, 1280, height/4-tamY-30, height/4-tamY-80) );
  posY2 = int( map(height, 480, 1280, height/4+5, height/4+20) );
  posX1 = 0;
  posX2 = width/4;
  posX3 = width/4*2;
  posX4 = width/4*3;

  //////////////////////////////////////////////
  
  String myIPAddress = KetaiNet.getIP();
  ipNum = myIPAddress.split("\\.");
  
  num1 = int(ipNum[0]);
  num2 = int(ipNum[1]);
  num3 = int(ipNum[2]);
  num4 = int(ipNum[3]);
  ip = ipNum[0]+"."+ipNum[1]+"."+ipNum[2]+"."+ipNum[3];

  loc = new NetAddress(ip, 10000);
}

public void draw() {
  background(196, 196, 252);
  pushStyle();

  lineaQ(int(map(height, 480, 1280, 50, 100)));
  lineaQ(int(height/2.7));
  lineaQ(int( map(height, 480, 1280, height-40, height-80) ));

  pushStyle();
  textFont(font);
  textSize(int( map(height, 480, 1280, 32, 80) ));
  text(nf(num1, 3), 10, height/4);
  text(nf(num2, 3), width/4+10, height/4);
  text(nf(num3, 3), width/4*2+10, height/4);
  text(nf(num4, 3), width/4*3+10, height/4);
  popStyle();

  pushStyle();
  botonA(posX1, posY1, tamX, tamY, bUp1);
  botonA(posX2, posY1, tamX, tamY, bUp2);
  botonA(posX3, posY1, tamX, tamY, bUp3);
  botonA(posX4, posY1, tamX, tamY, bUp4);

  botonB(posX1, posY2, tamX, tamY, bDo1);
  botonB(posX2, posY2, tamX, tamY, bDo2);
  botonB(posX3, posY2, tamX, tamY, bDo3);
  botonB(posX4, posY2, tamX, tamY, bDo4);
  popStyle();

  stroke(0);
  strokeCap(SQUARE);
  strokeWeight(1);
  line(width/2, height/2.4, width/2, height-map(height, 480, 1280, 50, 90));
  line(width/2+1, height/2.4, width/2+1, height-map(height, 480, 1280, 50, 90));
  line(width/2-1, height/2.4, width/2-1, height-map(height, 480, 1280, 50, 90));

  fill(0);
  textSize(int( map(height, 480, 1280, 18, 44) ));
  text(ip+":10000", 20, int(map(height, 480, 1280, 32, 65)));
  text(ip+":10000", 20, int(map(height, 480, 1280, 31, 65)));
  text(ip+":10000", 20, int(map(height, 480, 1280, 33, 65)));

  textSize(int( map(height, 480, 1280, 12, 18) ));
  text("Senmap beta", width-map(width, 320, 720, 90, 130), height-15);

  textSize(int( map(height, 480, 1280, 16, 32) ));
  text("Acelerómetro", 20, height/2.4 + map(height, 480, 1280, 20, 40));
  text("Giroscopio", width/2 + 20, height/2.4 + map(height, 480, 1280, 20, 40));

  textSize(int( map(height, 480, 1280, 26, 50) ));
  text(
    "X:" + nfc(accelerometer.x, 2) + "\n" +
    "Y:" + nfc(accelerometer.y, 2) + "\n" +
    "Z:" + nfc(accelerometer.z, 2), 
    20, int(height/1.7));
  text(
    "X:" + nfc(giroscope.x, 2) + "\n" +
    "Y:" + nfc(giroscope.y, 2) + "\n" +
    "Z:" + nfc(giroscope.z, 2), 
    width/2 + 20, int(height/1.7));

  //////OSC////////
  OscMessage acc = new OscMessage("/accelerometer");
  acc.add(accelerometer.x);
  acc.add(accelerometer.y);
  acc.add(accelerometer.z);
  OscMessage gir = new OscMessage("/giroscope");
  gir.add(giroscope.x);
  gir.add(giroscope.y);
  gir.add(giroscope.z);

  OscP5.flush(acc, loc);
  OscP5.flush(gir, loc);
}

public void onAccelerometerEvent(float x, float y, float z, long time, int accuracy)
{
  accelerometer.set(x, y, z);
}

public void onGyroscopeEvent(float x, float y, float z)
{
  giroscope.set(x, y, z);
}