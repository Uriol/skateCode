// to do:
// draw when jumping and add quaternions
import toxi.processing.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import peasy.*;
PeasyCam cam;

String csvFile = "jumpTest3.csv";

ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();

float time = 0.02;
float totalSpeed, previousTotalSpeed;
int boxCounter;
float pixelMultiplier = 2;


// X edge
float[] xAccel;
float xInitialSpeed = 0;
float xSpeed = 0;
float xInitialPosition = 0;
float xPosition = 0;
float[] xPositions;

// Y edge
float yInitialSpeed = 0;
float ySpeed = 0;
float yInitialPosition = 0; 
float yPosition = 0;
float[] yPositions;

// Z edge
float[] zAccel;
float zInitialSpeed = 0;
float zSpeed = 0;
float zInitialPosition = 0; 
float zPosition = 0;
float[] zPositions;

// Yaw
float initialYawOnJumping;
float[] yaw;
float initialYaw;
float angleDifference = 0;
float totalAngleDifference;

// pitch and roll
float[] pitch;
float[] roll;


// booleans
boolean jumping, landing, stillJumping;


// loops
int k;

String[] rawData;

void setup() {
  size(1400, 800, OPENGL);
  cam = new PeasyCam(this, 100);
  colorMode(HSB);

  rawData = loadStrings(csvFile);
  parseTextFile(csvFile);
  calculateInitialSpeed();
  calculatePositions();
  
}

void draw() {
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

void parseTextFile(String _name){
  
  xAccel = new float[rawData.length];
  zAccel = new float[rawData.length];
  yaw = new float[rawData.length];
  pitch = new float[rawData.length];
  roll = new float[rawData.length]; 
  
  for (int i=0; i<rawData.length; i++) {
    String[] thisRow = split(rawData[i], ","); 
    xAccel[i] = float(thisRow[0]);
    zAccel[i] = float(thisRow[1]);
    yaw[i] = float(thisRow[2]);
    pitch[i] = float(thisRow[3]);
    roll[i] = float(thisRow[4]);
    //println(roll[i]);
  }
}

void calculateInitialSpeed(){
  // The first 2 seconds are not represented. 
  // Used to calculate the speed and the initial yaw. 
  for ( int j = 0; j < 200; j++) {
    // println(xAccel[j]);
    totalSpeed = previousTotalSpeed + (xAccel[j]*9.8)*time;
    previousTotalSpeed = totalSpeed;
    initialYaw = yaw[j];
  }
   println(totalSpeed); println(initialYaw);
}

void calculatePositions(){
  // Loop through the data after the 2 first seconds
  for (k = 200; k < rawData.length; k++) {
    
    
    if (zAccel[k] == 0 ) {
       if ( jumping == true ) {
        jumping = false;
        
         checkPreviousAccels(); 
      // landing = true; println("landing");  
     }
       
       
    } else {
      if ( jumping == false ) {
        
        initialYawOnJumping = yaw[k];
        println(initialYawOnJumping);
        
      }
      
      jumping = true;
      landing = false;
      calculateJump();
   }
    
    if (jumping == false && landing == false){
      onGround();
    }
    
  }
  
}

void onGround(){
  
  // Calculate yaw difference
    totalAngleDifference = yaw[k] - initialYaw;
    //println(totalAngleDifference);
    // totalAngleDifference to radians
    totalAngleDifference = totalAngleDifference*PI/180;
    
    // Calculate speed for x 
    xSpeed = totalSpeed*cos(totalAngleDifference);
    //println(xSpeed);
    // Calculate xPosition in meters
    xPosition = xInitialPosition + xSpeed*time;
    xInitialPosition = xPosition;
   // xPositions[k-100] = xPosition;

    // Calculate speed for y
    ySpeed = totalSpeed*sin(totalAngleDifference);
    //println(ySpeed);
    yPosition = yInitialPosition + ySpeed*time;
    yInitialPosition = yPosition;
   // yPositions[k-100] = yPosition;
    //println(xPosition + ", " + yPosition);
    
    // Calculate quaternions
    
    pitch[k] = pitch[k]*PI/180;
    
    
    roll[k] = roll[k]*PI/180;
    
    
    // Add to coordinates class
    Coordinate c = new Coordinate();
    c.loc.add(xPosition, yPosition, 0);
    c.quat = new Quaternion().createFromEuler(pitch[k],totalAngleDifference,roll[k] );
    //c.YPR.add(totalAngleDifference*-1,0,0);
    allCoordinates.add(c);
}

void calculateJump(){
  println("jumping");
  
}

void checkPreviousAccels(){
  println(zAccel[k-1]);
  println(zAccel[k-2]);
  println(zAccel[k-3]);
  println(zAccel[k-4]);
  if ( zAccel[k-1] == 0 && zAccel[k-2] == 0 && zAccel[k-3] == 0 && zAccel[k-4] == 0) {
    landing = true;
    jumping = false;
    println("landing");
  } else {
    jumping = true;
    landing = false;
    println("still jumping");
  }
  
} 


void drawBoxes() {
  boxCounter++;
  
  if ( boxCounter >= allCoordinates.size()) {
    boxCounter = 0;
  }
  
  for ( int i = 1; i < boxCounter; i++) {
    Coordinate c = allCoordinates.get(i);
    if ( jumping == false ) {
      c.displayGround();
    }
  }  
}
