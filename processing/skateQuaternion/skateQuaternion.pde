import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import toxi.processing.*;
PeasyCam cam;


ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();

String[] rawData;

float[] yaw, pitch, roll;

int boxCounter;

void setup(){
  size(1024, 800, OPENGL);
  cam = new PeasyCam(this, 1000);
  colorMode(HSB);

  rawData = loadStrings("flip180_fast3.csv");

  parseTextFile("flip180_fast3.csv");
}


void draw(){
  background(40);
  lights();
  // center axis
  fill(100);
  box(5);
  stroke(255, 255, 255);
  line(0, 0, 0, 100, 0, 0);
  stroke(80, 255, 255);
  line(0, 0, 0, 0, 100, 0);
  stroke(180, 255, 255);
  line(0, 0, 0, 0, 0, 100);

  stroke(255);
  noFill();
  
  drawBoxes();
  
}

void drawBoxes(){
  
  boxCounter++;
  if ( boxCounter >= rawData.length-100) {
    boxCounter = 0;
  }
  
  for (int i = 1; i < boxCounter; i++) {
    Coordinate c = allCoordinates.get(i);
    c.display();
  } 
   
  
}



void parseTextFile(String _name){
  println(rawData.length);
  yaw = new float[rawData.length];
  pitch = new float[rawData.length];
  roll = new float[rawData.length];
  
  for (int i = 0; i < rawData.length; i++) {
    String[] thisRow = split(rawData[i], ",");
    
    yaw[i] = float(thisRow[0]);
    yaw[i] = yaw[i]*PI/180;
//    String roundyaw = nf(yaw[i],0,3);
//    yaw[i] = Float.valueOf(roundyaw).floatValue();
    
    pitch[i] = float(thisRow[1]);
    pitch[i] = pitch[i]*PI/180;
//    String roundpitch = nf(pitch[i],0,3);
//    pitch[i] = Float.valueOf(roundpitch).floatValue();
    
    
    roll[i] = float(thisRow[2]);
    roll[i] = roll[i]*PI/180;
//    String round = nf(roll[i],0,3);
//    roll[i] = Float.valueOf(round).floatValue();
    Coordinate c = new Coordinate();
    println("yaw: " + yaw[i]);
    println("pitch: " + pitch[i]);
    println("roll: " + roll[i]);
    //println(round);
    
     c.quat = new Quaternion().createFromEuler(pitch[i],yaw[i],roll[i] );
     c.loc.add(i,0,0);
     
     
     allCoordinates.add(c);
    
  }
}
