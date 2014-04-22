// john@frame.io
// 518.588.1590

//skateboard@mail.com
// niko


import toxi.processing.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import peasy.*;
import controlP5.*;
//import processing.opengl.*;

PeasyCam cam;
PImage img;


float totalSpeed = 2.4;
String csvFile = "8_noseGrind_FINAL.csv";

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
float prev_zPosition = 0;
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
boolean jumping, landing, stillJumping, plus180, minus180, grinding, ground;

// jump booleans
boolean startJump;
boolean firstJump, secondJump, thirdJump, fourthJump;
boolean firstJumpLanding, secondJumpLanding, thirdJumpLanding, fourthJumpLanding;
float firstJumpSpeed = 0.5; // for ollie180
//float firstJumpSpeed = 1;
float secondJumpSpeed = -2.6; 
float thirdJumpSpeed = 1;
float fourthJumpSpeed = -3.5;

boolean manual;



// skateboard shape lines
// right side
// back right
float[] backRightX;
float[] backRightZ;
float[] backRightY;

float[] backRightBezierX;
float[] backRightBezierZ;
float[] backRightBezierY;

// tail right
float[] tailRightX;
float[] tailRightZ;
float[] tailRightY;

// tail right center
float[] tailRightCenterX;
float[] tailRightCenterZ;
float[] tailRightCenterY;

float[] tailRightBezierCenterX;
float[] tailRightBezierCenterZ;
float[] tailRightBezierCenterY;

float[] tailRightBezierX;
float[] tailRightBezierZ;
float[] tailRightBezierY;

// nose right center
float[] noseRightCenterX;
float[] noseRightCenterZ;
float[] noseRightCenterY;

float[] noseRightBezierCenterX;
float[] noseRightBezierCenterZ;
float[] noseRightBezierCenterY;

// nose Right
float[] noseRightX;
float[] noseRightZ;
float[] noseRightY;

float[] noseRightBezierX;
float[] noseRightBezierZ;
float[] noseRightBezierY;

// front right
float[] frontRightX;
float[] frontRightZ;
float[] frontRightY;

float[] frontRightBezierX;
float[] frontRightBezierZ;
float[] frontRightBezierY;

// -----------------------------------------------------------------------------------


// left side
// back left
float[] backLeftX;
float[] backLeftZ;
float[] backLeftY;

float[] backLeftBezierX;
float[] backLeftBezierZ;
float[] backLeftBezierY;

// tail right
float[] tailLeftX;
float[] tailLeftZ;
float[] tailLeftY;

float[] tailLeftBezierX;
float[] tailLeftBezierZ;
float[] tailLeftBezierY;


// nose Right
float[] noseLeftX;
float[] noseLeftZ;
float[] noseLeftY;

float[] noseLeftBezierX;
float[] noseLeftBezierZ;
float[] noseLeftBezierY;

// front right
float[] frontLeftX;
float[] frontLeftZ;
float[] frontLeftY;

float[] frontLeftBezierX;
float[] frontLeftBezierZ;
float[] frontLeftBezierY;



// shapes --------------------------------
PShape topTail;

float acceleratingColor = 0;
// loops
int k;

String[] rawData;

void setup() {
  size(1344, 760, OPENGL);
  frameRate(200);
  //g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 500);
  img = loadImage("background.jpg");
  
  

  

  rawData = loadStrings(csvFile);
  parseTextFile(csvFile);
  calculatePositions();
 calculateSkateBoards();
 

}

void draw() {
  
  background(25);
  smooth();
 
   noLights();
  //gui();
 
  




//directionalLight(150, 150, 150, 0,0,90); // from top
//directionalLight(150, 150, 150, 0,0,-90); // from top
//directionalLight(150, 150, 150, 0,90,0); // from top
//directionalLight(150, 150, 150, 0,-90,0); // from bottom




  // center axis
  fill(100);
  //box(5);
  stroke(255, 255, 255,20);
  line(0, 0, 0, 100, 0, 0);
  stroke(80, 255, 255,20);
  line(0, 0, 0, 0, 100, 0);
  stroke(180, 255, 255,20);
  line(0, 0, 0, 0, 0, 100);

  //stroke(255);
  noFill();
  blendMode(BLEND);

  //blendMode(MULTIPLY);
//  drawSkateboards();
  drawBoxes();
   //drawSkateboards();
 // noFill();
 
  //blendMode(BLEND);
//  topTail.setFill(#95CFB7);
//  shape(topTail);
  
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
  for (k = 1; k < rawData.length; k++) {
    
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
      grinding = false;
   }
   
    if (jumping == true ) {
      calculateJump();
    }
    
    if ( landing == true ) {
      calculateLanding();
    }
    
    if (jumping == false && landing == false && grinding == false){
      onGround();
    }
    
    if (grinding == true){ onGrind();}
    
  }
  
}



void onGround(){
  println("ground");
  ground = true;
  
  if ( plus180 == true ) { yaw[k] = yaw[k] + 180; roll[k] = roll[k] *-1; pitch[k] = pitch[k] *-1;}
  if ( minus180 == true ) { yaw[k] = yaw[k] - 180;roll[k] = roll[k] *-1; pitch[k] = pitch[k] *-1; }
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
    
    //calculate when accelerating
    if(xAccel[k] > xAccel[k-1]) {
      c.cAccelerating = true;
     // acceleratingColor = acceleratingColor - 5;
    } else if (xAccel[k] <= xAccel[k-1]){
      c.cStopping = false;
     // acceleratingColor = acceleratingColor + 5;
    }
    
    // if manual == true paint board yellow
    if (manual == true){ c.cManual = true;};
    
   // c.cAcceleratingColor = acceleratingColor;
    c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k]*-1 );
    if (plus180 == true || minus180 == true) { c.c180 = true;}
    //c.YPR.add(totalAngleDifference*-1,0,0);
    allCoordinates.add(c);
}

void calculateJump(){
  ground = true;
  // calculate zSpeed
  if (firstJump == false){
    firstJump = true;
    zSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)*sin(angleOfJump)+firstJumpSpeed;
    
//    cManual = true;
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
  
  if (prev_zPosition <= zPosition) {
    //c.cGoingUp = true;
    acceleratingColor = acceleratingColor + 7;
  } else if ( prev_zPosition > zPosition) {
    acceleratingColor = acceleratingColor -7;
    
  }
  c.cAcceleratingColor = acceleratingColor;
  prev_zPosition = zPosition;
  c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k]*-1);
  c.cJumping = jumping;
  allCoordinates.add(c);
  
}

// calculate grind
void onGrind(){
  ground = false;
  grinding = true;
  println("grinding");
  
  // calculate speeds
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
  c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k]*-1 );
  c.cGrinding = true;
  allCoordinates.add(c);
}

void calculateLanding(){
  // restart
  airtime = 0;
  zInitialPosition = zPosition;
  println(zInitialPosition);
  println("calculateLanding");

    if (firstJump == true && firstJumpLanding == false) { firstJumpLanding = true;println("firstJump" + firstJump); manual = true; println("manual: " + manual);grinding = true;};
    if (secondJump == true && secondJumpLanding == false) { secondJumpLanding = true; println("secondJump" + secondJump); manual = false; println("manual: " + manual); grinding = false;};
    if (thirdJump == true && thirdJumpLanding == false ) { thirdJumpLanding = true; println("thirdJump" + thirdJump); };
    if (fourthJump == true && fourthJumpLanding == false ) { fourthJumpLanding = true; println("fourthJump" + fourthJump);};

  landing = false;
  yawOnLanding = yaw[k];

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
  
  
  
}

void checkPreviousAccels(){

  if ( zAccel[k-1] == 0 && zAccel[k-2] == 0 && zAccel[k-3] == 0 && zAccel[k-4] == 0) {
    landing = true;
    jumping = false;
   // println("landing");
  } else {
    jumping = true;
    landing = false;
  }
  
} 



void calculateSkateBoards(){
  
  backRightX = new float[rawData.length];
  backRightZ = new float[rawData.length];
  backRightY = new float[rawData.length];
  
  
  
  backRightBezierX = new float[rawData.length];
  backRightBezierZ = new float[rawData.length];
  backRightBezierY = new float[rawData.length];
  
  tailRightX = new float[rawData.length];
  tailRightZ = new float[rawData.length];
  tailRightY = new float[rawData.length];
  
  tailRightCenterX = new float[rawData.length];
  tailRightCenterZ = new float[rawData.length];
  tailRightCenterY = new float[rawData.length];
  
  tailRightBezierCenterX = new float[rawData.length];
  tailRightBezierCenterZ = new float[rawData.length];
  tailRightBezierCenterY = new float[rawData.length];
  
  tailRightBezierX = new float[rawData.length];
  tailRightBezierZ = new float[rawData.length];
  tailRightBezierY = new float[rawData.length];
  
  // nose -----------------------------------------------------------
  
  noseRightCenterX = new float[rawData.length];
  noseRightCenterZ = new float[rawData.length];
  noseRightCenterY = new float[rawData.length];
  
  noseRightBezierCenterX = new float[rawData.length];
  noseRightBezierCenterZ = new float[rawData.length];
  noseRightBezierCenterY = new float[rawData.length];
  
   noseRightX = new float[rawData.length];
  noseRightZ = new float[rawData.length];
  noseRightY = new float[rawData.length];
  
  noseRightBezierX = new float[rawData.length];
   noseRightBezierZ = new float[rawData.length];
    noseRightBezierY = new float[rawData.length];
  
  
  frontRightX = new float[rawData.length];
  frontRightZ = new float[rawData.length];
  frontRightY = new float[rawData.length];
  
  frontRightBezierX = new float[rawData.length];
  frontRightBezierZ = new float[rawData.length];
  frontRightBezierY = new float[rawData.length];
  
  
  // left side ----------------------------------------------------------------------------------------------------
  
  backLeftX = new float[rawData.length];
  backLeftZ = new float[rawData.length];
  backLeftY = new float[rawData.length];
  
  backLeftBezierX = new float[rawData.length];
  backLeftBezierZ = new float[rawData.length];
  backLeftBezierY = new float[rawData.length];
  
  tailLeftX = new float[rawData.length];
  tailLeftZ = new float[rawData.length];
  tailLeftY = new float[rawData.length];
  
  tailLeftBezierX = new float[rawData.length];
  tailLeftBezierZ = new float[rawData.length];
  tailLeftBezierY = new float[rawData.length];
  
   noseLeftX = new float[rawData.length];
  noseLeftZ = new float[rawData.length];
  noseLeftY = new float[rawData.length];
  
  noseLeftBezierX = new float[rawData.length];
   noseLeftBezierZ = new float[rawData.length];
    noseLeftBezierY = new float[rawData.length];
  
  
  frontLeftX = new float[rawData.length];
  frontLeftZ = new float[rawData.length];
  frontLeftY = new float[rawData.length];
  
  frontLeftBezierX = new float[rawData.length];
  frontLeftBezierZ = new float[rawData.length];
  frontLeftBezierY = new float[rawData.length];
  
  
  
   for (int i = 0; i < allCoordinates.size(); i++) {
    Coordinate thisC = allCoordinates.get(i);
    
    //back right
    pushMatrix();
      float[] axis = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      
      if (thisC.c180 == false ) {
        translate(-20,-1.5,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(20,-1.5,0);
      }
//
//      fill(0,222,0);
//      box(1,1,1);      
      

      float x = modelX(0, 0, 0);
      float y = modelY(0, 0, 0);
      float z = modelZ(0, 0, 0);
      
      backRightX[i] = x;
      backRightZ[i] = y;
      backRightY[i] = z;
 
    popMatrix();
    
    
    // back right bezier
    pushMatrix();
      float[] axis5 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis5[0], -axis5[1], -axis5[3], -axis5[2]);
      
      if (thisC.c180 == false ) {
        translate(-20,-1.5,4);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(20,-1.5,-4);
      }
      
//      fill(0,222,0);
//      box(1,1,1);
      
      float x5 = modelX(0, 0, 0);
      float y5 = modelY(0, 0, 0);
      float z5 = modelZ(0, 0, 0);
      
      backRightBezierX[i] = x5;
      backRightBezierZ[i] = y5;
      backRightBezierY[i] = z5;
      
      
      
    popMatrix();
    
    // Tail right
    pushMatrix();
      float[] axis2 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis2[0], -axis2[1], -axis2[3], -axis2[2]);
      
      if (thisC.c180 == false ) {
        translate(-12.5,0,5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(12.5,0,-5);
      } 

//      fill(0,222,0);
//      box(1,1,1);      
      
      
      float x2 = modelX(0, 0, 0);
      float y2 = modelY(0, 0, 0);
      float z2 = modelZ(0, 0, 0);
      
      tailRightX[i] = x2;
      tailRightZ[i] = y2;
      tailRightY[i] = z2;
      
    popMatrix();
    
    
    // Tail right CENTER
    pushMatrix();
      float[] axis17 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis17[0], -axis17[1], -axis17[3], -axis17[2]);
      
      if (thisC.c180 == false ) {
        translate(-12.5,0,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(12.5,0,0);
      } 

//      fill(0,222,0);
//      box(1,1,1);      
      
      
      float x17 = modelX(0, 0, 0);
      float y17 = modelY(0, 0, 0);
      float z17 = modelZ(0, 0, 0);
      
      tailRightCenterX[i] = x17;
      tailRightCenterZ[i] = y17;
      tailRightCenterY[i] = z17;
      
    popMatrix();
    
    
        // Tail right CENTER BEZIER
    pushMatrix();
      float[] axis18 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis18[0], -axis18[1], -axis18[3], -axis18[2]);
      
      if (thisC.c180 == false ) {
        translate(-16.25,0,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(16.25,0,0);
      } 

//      fill(0,222,0);
//      box(1,1,1);      
      
      
      float x18 = modelX(0, 0, 0);
      float y18 = modelY(0, 0, 0);
      float z18 = modelZ(0, 0, 0);
      
      tailRightBezierCenterX[i] = x18;
      tailRightBezierCenterZ[i] = y18;
      tailRightBezierCenterY[i] = z18;
      
    popMatrix();
    
    
    
    // tail Bezier
    pushMatrix();
      float[] axis6 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis6[0], -axis6[1], -axis6[3], -axis6[2]);
      
      if (thisC.c180 == false ) {
        translate(-16.25,0,5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(16.25,0,-5);
      }
      
//      fill(0,222,0);
//      box(1,1,1);

      float x6 = modelX(0, 0, 0);
      float y6 = modelY(0, 0, 0);
      float z6 = modelZ(0, 0, 0);
      
      tailRightBezierX[i] = x6;
      tailRightBezierZ[i] = y6;
      tailRightBezierY[i] = z6;
      
     popMatrix();
    
    // nose right
   pushMatrix();
      float[] axis3 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis3[0], -axis3[1], -axis3[3], -axis3[2]);
      
      if (thisC.c180 == false ) {
        translate(12.5,0,5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-12.5,0,-5);
      } 
      
      
      
      float x3 = modelX(0, 0, 0);
      float y3 = modelY(0, 0, 0);
      float z3 = modelZ(0, 0, 0);
      
      noseRightX[i] = x3;
      noseRightZ[i] = y3;
      noseRightY[i] = z3;
      
      
      
   popMatrix();
   
   
   // nose right CENTER
   pushMatrix();
      float[] axis19 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis19[0], -axis19[1], -axis19[3], -axis19[2]);
      
      if (thisC.c180 == false ) {
        translate(12.5,0,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-12.5,0,0);
      } 
      
//      fill(0,222,0);
//      box(1,1,1);   
      
      float x19 = modelX(0, 0, 0);
      float y19 = modelY(0, 0, 0);
      float z19 = modelZ(0, 0, 0);
      
      noseRightCenterX[i] = x19;
      noseRightCenterZ[i] = y19;
      noseRightCenterY[i] = z19;
       
   popMatrix();
   
     // nose right Center bezier
   pushMatrix();
      float[] axis20 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis20[0], -axis20[1], -axis20[3], -axis20[2]);
      
      if (thisC.c180 == false ) {
        translate(16.25,0,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-16.25,0,0);
      }
      
//      fill(0,222,0);
//      box(1,1,1);
      
      float x20 = modelX(0, 0, 0);
      float y20 = modelY(0, 0, 0);
      float z20 = modelZ(0, 0, 0);
      
      noseRightBezierCenterX[i] = x20;
      noseRightBezierCenterZ[i] = y20;
      noseRightBezierCenterY[i] = z20;
      
   popMatrix();
   
   
   
   
   // nose right bezier
   pushMatrix();
      float[] axis7 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis7[0], -axis7[1], -axis7[3], -axis7[2]);
      
      if (thisC.c180 == false ) {
        translate(16.25,0,5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-16.25,0,-5);
      }
      
//      fill(0,222,0);
//      box(1,1,1);
      
      float x7 = modelX(0, 0, 0);
      float y7 = modelY(0, 0, 0);
      float z7 = modelZ(0, 0, 0);
      
      noseRightBezierX[i] = x7;
      noseRightBezierZ[i] = y7;
      noseRightBezierY[i] = z7;
      
   popMatrix();
   
   
   // frontRight
   pushMatrix();
      float[] axis4 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis4[0], -axis4[1], -axis4[3], -axis4[2]);
      
      if (thisC.c180 == false ) {
        translate(20,-1.5,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-20,-1.5,0);
      }
      
     

      float x4 = modelX(0, 0, 0);
      float y4 = modelY(0, 0, 0);
      float z4 = modelZ(0, 0, 0);
      
      frontRightX[i] = x4;
      frontRightZ[i] = y4;
      frontRightY[i] = z4;
 
    popMatrix();
    
    // front Right bezier
    pushMatrix();
      float[] axis8 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis8[0], -axis8[1], -axis8[3], -axis8[2]);
      
      if (thisC.c180 == false ) {
        translate(20,-1.5,4);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-20,-1.5,-4);
      }
      
//      fill(0,222,0);
//      box(1,1,1);

      float x8 = modelX(0, 0, 0);
      float y8 = modelY(0, 0, 0);
      float z8 = modelZ(0, 0, 0);

     frontRightBezierX[i] = x8;
    frontRightBezierZ[i] = y8;
   frontRightBezierY[i] = z8; 
      
    popMatrix();
    
    
    
    // left side --------------------------------------------------------------------------------------------------------------------------------------
    
    //back Left
    pushMatrix();
      float[] axis9 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis9[0], -axis9[1], -axis9[3], -axis9[2]);
      
      if (thisC.c180 == false ) {
        translate(-20,-1.5,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(20,-1.5,0);
      }
      
//      fill(222,222,0);
//      box(1,1,1);      
      

      float x9 = modelX(0, 0, 0);
      float y9 = modelY(0, 0, 0);
      float z9 = modelZ(0, 0, 0);
      
      backLeftX[i] = x9;
      backLeftZ[i] = y9;
      backLeftY[i] = z9;
 
    popMatrix();
    
//    
//    // back right bezier
    pushMatrix();
      float[] axis10 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis10[0], -axis10[1], -axis10[3], -axis10[2]);
      
      if (thisC.c180 == false ) {
        translate(-20,-1.5,-4);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(20,-1.5,4);
      }
      
//      fill(0,222,0);
//      box(1,1,1);
      
      float x10 = modelX(0, 0, 0);
      float y10 = modelY(0, 0, 0);
      float z10 = modelZ(0, 0, 0);
//      
      backLeftBezierX[i] = x10;
      backLeftBezierZ[i] = y10;
      backLeftBezierY[i] = z10;
      
      
      
    popMatrix();
//    
//    // Tail Left
    pushMatrix();
      float[] axis11 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis11[0], -axis11[1], -axis11[3], -axis11[2]);
      
      if (thisC.c180 == false ) {
        translate(-12.5,0,-5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(12.5,0,5);
      } 
      
//      fill(0,222,0);
//      box(1,1,1);      
      
      float x11 = modelX(0, 0, 0);
      float y11 = modelY(0, 0, 0);
      float z11 = modelZ(0, 0, 0);
//      
      tailLeftX[i] = x11;
      tailLeftZ[i] = y11;
      tailLeftY[i] = z11;
      
    popMatrix();
//    
//    
//    // tail Bezier
    pushMatrix();
      float[] axis12 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis12[0], -axis12[1], -axis12[3], -axis12[2]);
      
      if (thisC.c180 == false ) {
        translate(-16.25,0,-5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(16.25,0,5);
      }
      
//      fill(0,222,0);
//      box(1,1,1);

      float x12 = modelX(0, 0, 0);
      float y12 = modelY(0, 0, 0);
      float z12 = modelZ(0, 0, 0);
//      
      tailLeftBezierX[i] = x12;
      tailLeftBezierZ[i] = y12;
      tailLeftBezierY[i] = z12;
      
     popMatrix();
//    
//    // nose right
   pushMatrix();
      float[] axis13 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis13[0], -axis13[1], -axis13[3], -axis13[2]);
      
      if (thisC.c180 == false ) {
        translate(12.5,0,-5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-12.5,0,5);
      } 
      
      
      
      float x13 = modelX(0, 0, 0);
      float y13 = modelY(0, 0, 0);
      float z13 = modelZ(0, 0, 0);
      
      noseLeftX[i] = x13;
      noseLeftZ[i] = y13;
      noseLeftY[i] = z13;
      
      
      
   popMatrix();
//   
   // nose left bezier
   pushMatrix();
      float[] axis14 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis14[0], -axis14[1], -axis14[3], -axis14[2]);
      
      if (thisC.c180 == false ) {
        translate(16.25,0,-5);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-16.25,0,5);
      }
      
//      fill(0,222,0);
//      box(1,1,1);
      
      float x14 = modelX(0, 0, 0);
      float y14 = modelY(0, 0, 0);
      float z14 = modelZ(0, 0, 0);
      
      noseLeftBezierX[i] = x14;
      noseLeftBezierZ[i] = y14;
      noseLeftBezierY[i] = z14;
      
   popMatrix();
//   
//   
   // front Left
   pushMatrix();
      float[] axis15 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis15[0], -axis15[1], -axis15[3], -axis15[2]);
      
      if (thisC.c180 == false ) {
        translate(20,-1.5,0);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-20,-1.5,0);
      }
      
//      fill(0,222,0);
//      box(1,1,1);

      float x15 = modelX(0, 0, 0);
      float y15 = modelY(0, 0, 0);
      float z15 = modelZ(0, 0, 0);
      
      frontLeftX[i] = x15;
      frontLeftZ[i] = y15;
      frontLeftY[i] = z15;
 
    popMatrix();
//    
    // front left bezier
    pushMatrix();
      float[] axis16 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*70, thisC.loc.z*70, thisC.loc.y*70);
      rotate(axis16[0], -axis16[1], -axis16[3], -axis16[2]);
      
      if (thisC.c180 == false ) {
        translate(20,-1.5,-4);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(-20,-1.5,4);
      }
      
//      fill(0,222,0);
//      box(1,1,1);

      float x16 = modelX(0, 0, 0);
      float y16 = modelY(0, 0, 0);
      float z16 = modelZ(0, 0, 0);

     frontLeftBezierX[i] = x16;
    frontLeftBezierZ[i] = y16;
   frontLeftBezierY[i] = z16; 
      
    popMatrix();
   
   } 
}

void drawSkateboards(){
  
    boxCounter++;
  
  if ( boxCounter >= allCoordinates.size()) {
    boxCounter = 0;
  }
  
 // for (int i = 0; i < allCoordinates.size()-allCoordinates.size()+1; i++) {
    for (int i = 0; i < allCoordinates.size(); i++) {
    //for (int i = 0; i < boxCounter; i++) {
      Coordinate thisC = allCoordinates.get(i);
    
    // on ground
    if ( thisC.cJumping == true){
      
      strokeWeight(1);
      
      //Right side  -----
      //fill(255,50,50,200);
       fill(200,200,0); // yellow
       //fill(162,197,62);//green
       fill(40); // black
     // fill(226,183,118); // brown
      noStroke();
     
      // fill tail
      beginShape();
        vertex(backRightX[i],backRightZ[i],backRightY[i] );  
        bezierVertex(backRightX[i],backRightZ[i],backRightY[i], tailRightBezierCenterX[i],tailRightBezierCenterZ[i],tailRightBezierCenterY[i],tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i] ); 
        vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);
        bezierVertex(tailRightBezierX[i],tailRightBezierZ[i],tailRightBezierY[i], backRightBezierX[i], backRightBezierZ[i],backRightBezierY[i],backRightX[i],backRightZ[i],backRightY[i]); 
      endShape(CLOSE);
      //fill center
      beginShape();
       vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);  
       vertex(tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i]); 
       vertex(noseRightCenterX[i], noseRightCenterZ[i],noseRightCenterY[i]);
       vertex(noseRightX[i], noseRightZ[i],noseRightY[i]);
      endShape(CLOSE);
      // fill nose
      beginShape();
        vertex(frontRightX[i], frontRightZ[i], frontRightY[i]);
        bezierVertex(frontRightX[i], frontRightZ[i], frontRightY[i],noseRightBezierCenterX[i],noseRightBezierCenterZ[i],noseRightBezierCenterY[i], noseRightCenterX[i], noseRightCenterZ[i] ,noseRightCenterY[i]  );
        vertex(noseRightX[i],noseRightZ[i],noseRightY[i]);
        bezierVertex(noseRightBezierX[i],noseRightBezierZ[i],noseRightBezierY[i],frontRightBezierX[i], frontRightBezierZ[i],frontRightBezierY[i], frontRightX[i],frontRightZ[i],frontRightY[i] );
      endShape(CLOSE);
      
//      pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//          vertex(backRightX[i],backRightZ[i],backRightY[i] );  
//          bezierVertex(backRightX[i],backRightZ[i],backRightY[i], tailRightBezierCenterX[i],tailRightBezierCenterZ[i],tailRightBezierCenterY[i],tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i] ); 
//          vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);
//          bezierVertex(tailRightBezierX[i],tailRightBezierZ[i],tailRightBezierY[i], backRightBezierX[i], backRightBezierZ[i],backRightBezierY[i],backRightX[i],backRightZ[i],backRightY[i]); 
//        endShape(CLOSE);
//      popMatrix();
//      
//      pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//          vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);  
//       vertex(tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i]); 
//       vertex(noseRightCenterX[i], noseRightCenterZ[i],noseRightCenterY[i]);
//       vertex(noseRightX[i], noseRightZ[i],noseRightY[i]); 
//        endShape(CLOSE);
//      popMatrix();
//      
//      pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//        vertex(frontRightX[i], frontRightZ[i], frontRightY[i]);
//        bezierVertex(frontRightX[i], frontRightZ[i], frontRightY[i],noseRightBezierCenterX[i],noseRightBezierCenterZ[i],noseRightBezierCenterY[i], noseRightCenterX[i], noseRightCenterZ[i] ,noseRightCenterY[i]  );
//        vertex(noseRightX[i],noseRightZ[i],noseRightY[i]);
//        bezierVertex(noseRightBezierX[i],noseRightBezierZ[i],noseRightBezierY[i],frontRightBezierX[i], frontRightBezierZ[i],frontRightBezierY[i], frontRightX[i],frontRightZ[i],frontRightY[i] );
//        endShape(CLOSE);
//      popMatrix();
      
      
      
      
      
      
//      stroke(0);
//    beginShape();
//        vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);
//        bezierVertex(tailRightBezierX[i],tailRightBezierZ[i],tailRightBezierY[i], backRightBezierX[i], backRightBezierZ[i],backRightBezierY[i],backRightX[i],backRightZ[i],backRightY[i]);
//        bezierVertex(backRightX[i],backRightZ[i],backRightY[i], tailRightBezierCenterX[i],tailRightBezierCenterZ[i],tailRightBezierCenterY[i],tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i] );
//        vertex(noseRightCenterX[i], noseRightCenterZ[i],noseRightCenterY[i]);
//        bezierVertex(noseRightBezierCenterX[i],noseRightBezierCenterZ[i],noseRightBezierCenterY[i],frontRightX[i], frontRightZ[i], frontRightY[i],frontRightX[i], frontRightZ[i], frontRightY[i] );
//        bezierVertex( frontRightBezierX[i], frontRightBezierZ[i],frontRightBezierY[i], noseRightBezierX[i],noseRightBezierZ[i],noseRightBezierY[i], noseRightX[i], noseRightZ[i],noseRightY[i]);
//        vertex(tailRightX[i],tailRightZ[i],tailRightY[i]);
//    endShape();
      
      // draw stroke
      stroke(150,0,0);
     // stroke(255,255,0); // yellow
      //stroke(153,247,6);//green
      //noStroke();
      //stroke(255,255,0);
      noFill();
       bezier(backRightX[i],backRightZ[i],backRightY[i], backRightBezierX[i], backRightBezierZ[i],backRightBezierY[i],tailRightBezierX[i],tailRightBezierZ[i],tailRightBezierY[i],tailRightX[i],tailRightZ[i],tailRightY[i]);
       line(tailRightX[i],tailRightZ[i],tailRightY[i],noseRightX[i],noseRightZ[i],noseRightY[i] );
       bezier(noseRightX[i],noseRightZ[i],noseRightY[i], noseRightBezierX[i],noseRightBezierZ[i],noseRightBezierY[i], frontRightBezierX[i],frontRightBezierZ[i],frontRightBezierY[i],frontRightX[i],frontRightZ[i],frontRightY[i]);
       
      
      
      
      
      
      noStroke();
      //left Side -----------------------------------------------------------------------
      //fill(0,155,205,200);
     // fill(200,200,0); // yellow
       //fill(162,197,62);//green
      fill(40); // black
      //fill(226,183,118); // brown
      beginShape();
        vertex(backLeftX[i],backLeftZ[i],backLeftY[i] );  
        bezierVertex(backLeftX[i],backLeftZ[i],backLeftY[i], tailRightBezierCenterX[i],tailRightBezierCenterZ[i],tailRightBezierCenterY[i],tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i] ); 
        vertex(tailLeftX[i],tailLeftZ[i],tailLeftY[i]);
        bezierVertex(tailLeftBezierX[i],tailLeftBezierZ[i],tailLeftBezierY[i], backLeftBezierX[i], backLeftBezierZ[i],backLeftBezierY[i],backLeftX[i],backLeftZ[i],backLeftY[i]); 
      endShape(CLOSE);
      
      beginShape();
       vertex(tailLeftX[i],tailLeftZ[i],tailLeftY[i]);  
       vertex(tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i]); 
       vertex(noseRightCenterX[i], noseRightCenterZ[i],noseRightCenterY[i]);
       vertex(noseLeftX[i], noseLeftZ[i],noseLeftY[i]);
      endShape(CLOSE);
      
      beginShape();
        vertex(frontLeftX[i], frontLeftZ[i], frontLeftY[i]);
        bezierVertex(frontLeftX[i], frontLeftZ[i], frontLeftY[i],noseRightBezierCenterX[i],noseRightBezierCenterZ[i],noseRightBezierCenterY[i], noseRightCenterX[i], noseRightCenterZ[i] ,noseRightCenterY[i]  );
        vertex(noseLeftX[i],noseLeftZ[i],noseLeftY[i]);
        bezierVertex(noseLeftBezierX[i],noseLeftBezierZ[i],noseLeftBezierY[i],frontLeftBezierX[i], frontLeftBezierZ[i],frontLeftBezierY[i], frontLeftX[i],frontLeftZ[i],frontLeftY[i] );
      endShape(CLOSE);
      
      
      
      
      
      
//      pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//         vertex(backLeftX[i],backLeftZ[i],backLeftY[i] );  
//        bezierVertex(backLeftX[i],backLeftZ[i],backLeftY[i], tailRightBezierCenterX[i],tailRightBezierCenterZ[i],tailRightBezierCenterY[i],tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i] ); 
//        vertex(tailLeftX[i],tailLeftZ[i],tailLeftY[i]);
//        bezierVertex(tailLeftBezierX[i],tailLeftBezierZ[i],tailLeftBezierY[i], backLeftBezierX[i], backLeftBezierZ[i],backLeftBezierY[i],backLeftX[i],backLeftZ[i],backLeftY[i]); 
//        endShape(CLOSE);
//      popMatrix();
//      
//     pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//       vertex(tailLeftX[i],tailLeftZ[i],tailLeftY[i]);  
//       vertex(tailRightCenterX[i], tailRightCenterZ[i] ,tailRightCenterY[i]); 
//       vertex(noseRightCenterX[i], noseRightCenterZ[i],noseRightCenterY[i]);
//       vertex(noseLeftX[i], noseLeftZ[i],noseLeftY[i]);
//        endShape(CLOSE);
//      popMatrix();
//      
//       pushMatrix();
//        translate(0,0.1,0);
//         fill(226,183,118); // brown
//        // fill tail
//        beginShape();
//       vertex(frontLeftX[i], frontLeftZ[i], frontLeftY[i]);
//        bezierVertex(frontLeftX[i], frontLeftZ[i], frontLeftY[i],noseRightBezierCenterX[i],noseRightBezierCenterZ[i],noseRightBezierCenterY[i], noseRightCenterX[i], noseRightCenterZ[i] ,noseRightCenterY[i]  );
//        vertex(noseLeftX[i],noseLeftZ[i],noseLeftY[i]);
//        bezierVertex(noseLeftBezierX[i],noseLeftBezierZ[i],noseLeftBezierY[i],frontLeftBezierX[i], frontLeftBezierZ[i],frontLeftBezierY[i], frontLeftX[i],frontLeftZ[i],frontLeftY[i] );
//        endShape(CLOSE);
//      popMatrix();
      
      
      
      noFill();
      //stroke(1,61,102, 200);
     // stroke(255,255,0); // yellow
      //stroke(70,145,70); // green
     // stroke(247,132,6); // orange 
      stroke(27,185, 234); // blue
      bezier(backLeftX[i],backLeftZ[i],backLeftY[i], backLeftBezierX[i], backLeftBezierZ[i],backLeftBezierY[i],tailLeftBezierX[i],tailLeftBezierZ[i],tailLeftBezierY[i],tailLeftX[i],tailLeftZ[i],tailLeftY[i]);
      line(tailLeftX[i],tailLeftZ[i],tailLeftY[i],noseLeftX[i],noseLeftZ[i],noseLeftY[i] );
      bezier(noseLeftX[i],noseLeftZ[i],noseLeftY[i], noseLeftBezierX[i],noseLeftBezierZ[i],noseLeftBezierY[i], frontLeftBezierX[i],frontLeftBezierZ[i],frontLeftBezierY[i],frontLeftX[i],frontLeftZ[i],frontLeftY[i]);
      
     
    } // end if jumping
  }
  
}








void drawBoxes() {
  boxCounter++;
  
  if ( boxCounter >= allCoordinates.size()) {
    boxCounter = 0;
  }
  
//  for ( int i = 1; i < boxCounter; i++) {
//  //for (int i = 0; i < allCoordinates.size()-allCoordinates.size()+1; i++) {
//    Coordinate c = allCoordinates.get(i);
//    
//    //drawSkateboards();
//      c.displayGround(); 
//  } 
// delay(15); 

  for(Coordinate c : allCoordinates) {
    
    c.displayGround();
     
  }
}




void gui() {
  cam.beginHUD();
  image(img, 0, 0);
  cam.endHUD();
}
