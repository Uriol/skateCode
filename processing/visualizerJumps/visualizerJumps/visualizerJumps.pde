
import toxi.processing.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import peasy.*;
import controlP5.*;
//import processing.opengl.*;

PeasyCam cam;
ControlP5 controlP5;
PMatrix3D currCameraMatrix;
PGraphics3D g3; 


float totalSpeed = 2.15;
String csvFile = "4jumps_test2.csv";

ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();

//float time = 0.0004;
float time = 0.02;
float airtime = 0;

float previousTotalSpeed;
int boxCounter;
float pixelMultiplier = 2;
float angleOfJump = 80*PI/180;

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
float initialYawOnJumping, yawOnLanding;
float[] yaw;
float initialYaw;
float angleDifference = 0;
float totalAngleDifference;

// pitch and roll
float[] pitch;
float[] roll;


// booleans
boolean jumping, landing, stillJumping, plus180, minus180;

// jump booleans
boolean startJump;
boolean firstJump, secondJump, thirdJump, fourthJump;
boolean firstJumpLanding, secondJumpLanding, thirdJumpLanding, fourthJumpLanding;
float firstJumpSpeed = 1.25;
float secondJumpSpeed = -3; 
float thirdJumpSpeed = 1;
float fourthJumpSpeed = -1;



// loops
int k;

String[] rawData;

void setup() {
  size(1344, 760, OPENGL);
  
  //g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 100);
  
  //controlP5 = new ControlP5(this);
  //controlP5.addButton("button").setPosition(0,0).setImages(loadImage("background.jpg"),loadImage("background.jpg"),loadImage("background.jpg")).updateSize();

  //controlP5.setAutoDraw(false);

  rawData = loadStrings(csvFile);
  parseTextFile(csvFile);
  calculatePositions();
  
 

}

void draw() {
  
  background(60);

  //lights();
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
  gui();
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
    initialYaw = yaw[0];
  }
}



void calculatePositions(){
  // Loop through the data after the 2 first seconds
  for (k = 0; k < rawData.length; k++) {
    
    // Detect when not jumping, when jumping and when landing
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
   }
   
    if (jumping == true ) {
      calculateJump();
    }
    
    if ( landing == true ) {
      calculateLanding();
    }
    
    if (jumping == false && landing == false){
      onGround();
    }
    
  }
  
}

void onGround(){
  
  if ( plus180 == true ) { yaw[k] = yaw[k] + 180; }
  if ( minus180 == true ) { yaw[k] = yaw[k] - 180; }
  // Calculate yaw difference
    totalAngleDifference = yaw[k] - initialYaw;
    //println(totalAngleDifference);
    // totalAngleDifference to radians
    totalAngleDifference = totalAngleDifference*PI/180;
    
    // Calculate speed for x 
    xSpeed = totalSpeed*cos(totalAngleDifference);
    
    // Calculate xPosition in meters
    //xPosition = xInitialPosition + xSpeed*time;
    xPosition = xInitialPosition + xSpeed*time;
    xInitialPosition = xPosition;
//    println(xPosition);
   // xPositions[k-100] = xPosition;

    // Calculate speed for y
    ySpeed = totalSpeed*sin(totalAngleDifference);
    //println(ySpeed);
    yPosition = yInitialPosition + ySpeed*time;
    yInitialPosition = yPosition;
   // yPositions[k-100] = yPosition;
    //println(xPosition + ", " + yPosition);
   // println(xSpeed + ", " + ySpeed);
    // Calculate quaternions
    
    pitch[k] = pitch[k]*PI/180;
    
    
    roll[k] = roll[k]*PI/180;
    
    
    // Add to coordinates class
    Coordinate c = new Coordinate();
    c.loc.add(xPosition, yPosition, zPosition*-1);
    c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k] );
    //c.YPR.add(totalAngleDifference*-1,0,0);
    allCoordinates.add(c);
}

void calculateJump(){
  
  // calculate zSpeed
  if (firstJump == false){
    firstJump = true;
    zSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)*sin(angleOfJump)+firstJumpSpeed;
  }
  
  if ( firstJumpLanding == true && secondJump == false ) {
    secondJump = true;
    zSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)*sin(angleOfJump)+secondJumpSpeed;
  }
  
  if ( secondJumpLanding == true && thirdJump == false){
    thirdJump = true;
    zSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)*sin(angleOfJump)+thirdJumpSpeed;
  }
  if ( thirdJumpLanding == true && fourthJump == false ) {
    fourthJump = true;
    zSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)*sin(angleOfJump)+fourthJumpSpeed;
  }
  
  
 // println("zSpeed:" + zSpeed);
  airtime = airtime + 0.02;
  //println("airtime:" + airtime);
   zPosition = zInitialPosition + zSpeed*airtime - 0.5*9.8*airtime*airtime ;
//    zPosition = zSpeed*zInitialPosition - 0.5*9.8*airtime*airtime ;
//    zInitialPosition = zPosition;

//  if (startJump == false ) {
//    zPosition = zInitialPosition + zSpeed*airtime - 0.5*9.8*airtime*airtime ;
//    startJump = true;
//  }

//  zPosition = zInitialPosition + zSpeed*airtime - 0.5*9.8*airtime*airtime ;
//  zInitialPosition = zPosition;
  //println("zPosition: " + zPosition);
  
  //println("jumping");
//  println(xSpeed);
  totalAngleDifference = yaw[k] - initialYaw;
  totalAngleDifference = totalAngleDifference*PI/180;
    
  xPosition = xInitialPosition + xSpeed*time;
  xInitialPosition = xPosition;
  
  yPosition = yInitialPosition + ySpeed*time;
  yInitialPosition = yPosition;
  
  pitch[k] = pitch[k]*PI/180;
  roll[k] = roll[k]*PI/180;
  
  // Add to coordinate class
  Coordinate c = new Coordinate();
  c.loc.add(xPosition, yPosition, zPosition*-1);
  c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k]);
  c.cJumping = jumping;
  allCoordinates.add(c);
  
}

void calculateLanding(){
  airtime = 0;
  zInitialPosition = zPosition;
  println(zInitialPosition);
  println("calculateLanding");
//  plus180 = false;
//  minus180 = false;
    if (firstJump == true && firstJumpLanding == false) { firstJumpLanding = true;println("firstJump" + firstJump);};
    if (secondJump == true && secondJumpLanding == false) { secondJumpLanding = true; println("secondJump" + secondJump); };
    if (thirdJump == true && thirdJumpLanding == false ) { thirdJumpLanding = true; println("thirdJump" + thirdJump); };
    if (fourthJump == true && fourthJumpLanding == false ) { fourthJumpLanding = true; println("fourthJump" + fourthJump);};
//  if (firstJump == true) { secondJump = true; println("secondJump" + secondJump);};
//  if (secondJump == true && thirdJump == false) { thirdJump = true;println("thirdJump" + thirdJump);};
//  if (thirdJump == true && fourthJump == false) { fourthJump = true;println("fourthJump" + fourthJump);};
  landing = false;
  yawOnLanding = yaw[k];
//  println(initialYawOnJumping);
//  println(yawOnLanding);
  
  // Calculate 180s
  // first case initialYaw < 0 > 90
  if ( initialYawOnJumping > 0 && initialYawOnJumping < 90 ) {
    if ( -90 + initialYawOnJumping < yawOnLanding && 90 + initialYawOnJumping > yawOnLanding) { yawOnLanding = yawOnLanding; println("case 1: final yawOnLanding not 180");}
    else if ( 90 + initialYawOnJumping < yawOnLanding && yawOnLanding < 179 ) { yawOnLanding = yawOnLanding - 180; println("case 1: final yawOnLanding -180"); minus180 = true; plus180 = false;}
    else if ( -90 + initialYawOnJumping > yawOnLanding && yawOnLanding > -179 ) { yawOnLanding = yawOnLanding + 180; println("case 1: final yawOnLanding +180"); plus180 = true; minus180 = false;}
  }
  
  // second case initialYaw > 90 < 179
  if ( initialYawOnJumping > 90 && initialYawOnJumping < 179) {
    if ( yawOnLanding > 0 && 90 - ( 179 - initialYawOnJumping ) > yawOnLanding ) { yawOnLanding = yawOnLanding - 180 ; println("case 2: final yawOnLanding -180"); minus180 = true; plus180 = false;}
    else if ( -90 - (179 - initialYawOnJumping) < yawOnLanding && yawOnLanding < 0 ) { yawOnLanding = yawOnLanding + 180; println("case 2: final yawOnLanding + 180"); plus180 = true; minus180 = false;}
    else { yawOnLanding = yawOnLanding; println("case 2: final yawOnLanding not 180");}
  }
  
  // Third case initial yaw < 0 > -90
  if ( initialYawOnJumping < 0 && initialYawOnJumping > -90 ) {
    if ( yawOnLanding > -179 && yawOnLanding < -90 + initialYawOnJumping) { yawOnLanding = yawOnLanding + 180; println("case 3: final yawOnLanding + 180"); plus180 = true; minus180 = false; }
    else if ( 90 + initialYawOnJumping < yawOnLanding && yawOnLanding < 179 ) { yawOnLanding = yawOnLanding - 180; println("case 3: final yawOnLanding - 180"); minus180 = true; plus180 = false;}
    else { yawOnLanding = yawOnLanding; println("case 3: final yawOnLanding not 180");}
  }
  
  // Fourth case initial yaw > -90 < -179
  if ( initialYawOnJumping < -90 && initialYawOnJumping > -179 ) {
    if ( yawOnLanding > 0 && 90 + ( 179 + initialYawOnJumping ) > yawOnLanding ) { yawOnLanding = yawOnLanding - 180; println("case 4: final yawOnLanding - 180"); minus180 = true; plus180 = false;}
    else if ( -90 + (179 + initialYawOnJumping ) < yawOnLanding && yawOnLanding < 0 ) { yawOnLanding = yawOnLanding + 180; println("case 4: final yawOnLanding + 180"); plus180 = true; minus180 = false;}
    else { yawOnLanding = yawOnLanding; println("case 4: final yawOnLanding not 180");}
  }
  
  
  
//  if ( plus180 == true ) { yaw[k] = yaw[k] + 180;}
//  if ( minus180 == true ) { yaw[k] = yaw[k] - 180;}
//  
//  totalAngleDifference = yawOnLanding - initialYaw;
//  
//  xPosition = xInitialPosition + xSpeed*time;
//  xInitialPosition = xPosition;
//  
//  yPosition = yInitialPosition + ySpeed*time;
//  yInitialPosition = yPosition;
//  
//  pitch[k] = pitch[k]*PI/180;
//  roll[k] = roll[k]*PI/180;
  
   // Add to coordinate class
//  Coordinate c = new Coordinate();
//  c.loc.add(xPosition, yPosition, 0);
//  c.quat = new Quaternion().createFromEuler(pitch[k],totalAngleDifference,roll[k] );
//  c.cLanding = landing;
//  allCoordinates.add(c);
  
}

void checkPreviousAccels(){
//  println(zAccel[k-1]);
//  println(zAccel[k-2]);
//  println(zAccel[k-3]);
//  println(zAccel[k-4]);
  if ( zAccel[k-1] == 0 && zAccel[k-2] == 0 && zAccel[k-3] == 0 && zAccel[k-4] == 0) {
    landing = true;
    jumping = false;
   // println("landing");
  } else {
    jumping = true;
    landing = false;
    //println("still jumping");
  }
  
} 


void drawBoxes() {
//  boxCounter++;
//  
//  if ( boxCounter >= allCoordinates.size()) {
//    boxCounter = 0;
//  }
//  
//  for ( int i = 1; i < boxCounter; i++) {
//    Coordinate c = allCoordinates.get(i);
//  
//      c.displayGround(); 
//  } 
// delay(15); 
//
  for(Coordinate c : allCoordinates) {
    
    c.displayGround();
     
  }
}




void gui() {
//   currCameraMatrix = new PMatrix3D(g3.camera);
//   camera();
//   controlP5.draw();
//   g3.camera = currCameraMatrix;
}
