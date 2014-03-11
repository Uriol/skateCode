import processing.opengl.*;

import peasy.*;
PeasyCam cam;

String filename = "flip.csv";
String[] rawData;
float yaw, pitch,roll;
float[] yaws, pitchs, rolls;
//float[] yaws, pitchs,rolls;
int counter = 0;



void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(1500);
  cam.setMaximumDistance(3000);
  smooth();
  noStroke();
  frameRate(50);
 
  rawData = loadStrings(filename); 
  println(rawData.length);
  
  yaws = new float[rawData.length];
  pitchs = new float[rawData.length];
  rolls = new float[rawData.length];
  
  for(int i = 0; i < rawData.length; i++) {
    String[] thisRow = split(rawData[i], ",");
    //println(thisRow);
    
    yaw = Float.parseFloat(thisRow[0]);
    pitch = Float.parseFloat(thisRow[1]);
    roll = Float.parseFloat(thisRow[2]);
    
    yaws[i] = yaw;
    pitchs[i] = pitch;
    rolls[i] = roll;
  }
  
 // println(yaws);
 
}


void drawBoard() {
 
    
    
    if (counter < yaws.length-1) {
      counter++;
    } else {
      counter = 0;
    }
   

    rotateY(-radians(yaws[counter]));
    rotateX(-radians(pitchs[counter]));
    rotateZ(radians(rolls[counter])); 
  
    println(pitchs[counter]);
    
    
    // Board body
    fill(255, 0, 0);
    box(250, 20, 400);
    
    
     
    
    
}

void draw(){
  // reset scene
  background(0);
  lights();
  
  // Draw board
  
  
  drawBoard();
 
  
  delay(20);
}
