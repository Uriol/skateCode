
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
String csvFile = "5_ollie180.csv";

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
float firstJumpSpeed = 0.5;
float secondJumpSpeed = -3; 
float thirdJumpSpeed = 1;
float fourthJumpSpeed = -3.5;


//// lines
//// tail right
//float[] tailRightPositionsX;
//float[] tailRightPositionsZ;
//float[] tailRightPositionsY;
//
//// nose Right
//float[] noseRightPositionsX;
//float[] noseRightPositionsZ;
//float[] noseRightPositionsY;
//
//// tail left
//float[] tailLeftPositionsX;
//float[] tailLeftPositionsZ;
//float[] tailLeftPositionsY;
//
//// nose left
//float[] noseLeftPositionsX;
//float[] noseLeftPositionsZ;
//float[] noseLeftPositionsY;



// skateboard shape lines
// right side




// loops
int k;

String[] rawData;

void setup() {
  size(1344, 760, OPENGL);
  
  //g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 100);
  
  

  rawData = loadStrings(csvFile);
  parseTextFile(csvFile);
  calculatePositions();
  calculateLines();
 

}

void draw() {
  
  background(20);

  lights();
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
 // blendMode(BLEND);
  drawLines();
 // blendMode(MULTIPLY);
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
    c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k] );
    if (plus180 == true || minus180 == true) { c.c180 = true;}
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
  // restart
  airtime = 0;
  zInitialPosition = zPosition;
  println(zInitialPosition);
  println("calculateLanding");

    if (firstJump == true && firstJumpLanding == false) { firstJumpLanding = true;println("firstJump" + firstJump);};
    if (secondJump == true && secondJumpLanding == false) { secondJumpLanding = true; println("secondJump" + secondJump); };
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



void calculateLines(){
  
  tailRightPositionsX = new float[rawData.length];
  tailRightPositionsZ = new float[rawData.length];
  tailRightPositionsY = new float[rawData.length];
  
  noseRightPositionsX = new float[rawData.length];
  noseRightPositionsZ = new float[rawData.length];
  noseRightPositionsY = new float[rawData.length];
  
  tailLeftPositionsX = new float[rawData.length];
  tailLeftPositionsZ = new float[rawData.length];
  tailLeftPositionsY = new float[rawData.length];
  
  noseLeftPositionsX = new float[rawData.length];
  noseLeftPositionsZ = new float[rawData.length];
  noseLeftPositionsY = new float[rawData.length];
  
  
  for (int i = 0; i < allCoordinates.size(); i++) {
    Coordinate thisC = allCoordinates.get(i);
    
    // tail right
    pushMatrix();
      float[] axis = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*50, thisC.loc.z*50, thisC.loc.y*50);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      
      if (thisC.c180 == false ) {
        translate(-10,0,3);
      } else if (thisC.c180 == true ) {
        // nose left
        translate(10,0,-3);
      }
      
      float x = modelX(0, 0, 0);
      float y = modelY(0, 0, 0);
      float z = modelZ(0, 0, 0);
      //println(x + ", " + y + ", " + z);
      tailRightPositionsX[i] = x;
      tailRightPositionsZ[i] = y;
      tailRightPositionsY[i] = z;
      
        
    popMatrix();
    
    // nose right
    pushMatrix();
      float[] axis2 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*50, thisC.loc.z*50, thisC.loc.y*50);
      rotate(axis2[0], -axis2[1], -axis2[3], -axis2[2]);
      
      
      if (thisC.c180 == false ) {
        translate(10,0,3);
      } else if (thisC.c180 == true ) {
        // tail left
        translate(-10,0,-3);
      }
      
      float x2 = modelX(0, 0, 0);
      float y2 = modelY(0, 0, 0);
      float z2 = modelZ(0, 0, 0);
      //println(x + ", " + y + ", " + z);
      noseRightPositionsX[i] = x2;
      noseRightPositionsZ[i] = y2;
      noseRightPositionsY[i] = z2;
      
        
    popMatrix();
    
    // tail left
    pushMatrix();
      float[] axis3 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*50, thisC.loc.z*50, thisC.loc.y*50);
      rotate(axis3[0], -axis3[1], -axis3[3], -axis3[2]);
      
      if (thisC.c180 == false ) {
        translate(-10,0, -3);
      } else if (thisC.c180 == true ) {
        // tail left
        translate(10,0,3);
      }
      
      float x3 = modelX(0, 0, 0);
      float y3 = modelY(0, 0, 0);
      float z3 = modelZ(0, 0, 0);
      //println(x + ", " + y + ", " + z);
      tailLeftPositionsX[i] = x3;
      tailLeftPositionsZ[i] = y3;
      tailLeftPositionsY[i] = z3;
      
        
    popMatrix();
    
    // nose left
    pushMatrix();
      float[] axis4 = thisC.quat.toAxisAngle();
      translate(thisC.loc.x*50, thisC.loc.z*50, thisC.loc.y*50);
      rotate(axis4[0], -axis4[1], -axis4[3], -axis4[2]);
      
      if (thisC.c180 == false ) {
        translate(10,0, -3);
      } else if (thisC.c180 == true ) {
        // tail left
        translate(-10,0,3);
      }
      
      float x4 = modelX(0, 0, 0);
      float y4 = modelY(0, 0, 0);
      float z4 = modelZ(0, 0, 0);
      //println(x + ", " + y + ", " + z);
      noseLeftPositionsX[i] = x4;
      noseLeftPositionsZ[i] = y4;
      noseLeftPositionsY[i] = z4;
      
        
    popMatrix();
  }
}

void drawLines(){
  
  for( int i = 1; i < tailRightPositionsX.length; i++){
    
    // tail right
    float thisTRx = tailRightPositionsX[i];
    float prevTRx = tailRightPositionsX[i-1];
    
    float thisTRz = tailRightPositionsZ[i];
    float prevTRz = tailRightPositionsZ[i-1];
    
    float thisTRy = tailRightPositionsY[i];
    float prevTRy = tailRightPositionsY[i-1];
    
    stroke(255,59,10);
    line(prevTRx, prevTRz, prevTRy, thisTRx, thisTRz, thisTRy);
    
    // nose right
    float thisNRx = noseRightPositionsX[i];
    float prevNRx = noseRightPositionsX[i-1];
    
    float thisNRz = noseRightPositionsZ[i];
    float prevNRz = noseRightPositionsZ[i-1];
    
    float thisNRy = noseRightPositionsY[i];
    float prevNRy = noseRightPositionsY[i-1];
    
    line(prevNRx, prevNRz, prevNRy, thisNRx, thisNRz, thisNRy);
    
    // tail left
    stroke(54,197, 241);
    float thisTLx = tailLeftPositionsX[i];
    float prevTLx = tailLeftPositionsX[i-1];
    
    float thisTLz = tailLeftPositionsZ[i];
    float prevTLz = tailLeftPositionsZ[i-1];
    
    float thisTLy = tailLeftPositionsY[i];
    float prevTLy = tailLeftPositionsY[i-1];
    line(prevTLx, prevTLz, prevTLy, thisTLx, thisTLz, thisTLy);
    
    
    // nose left
    float thisNLx = noseLeftPositionsX[i];
    float prevNLx = noseLeftPositionsX[i-1];
    
    float thisNLz = noseLeftPositionsZ[i];
    float prevNLz = noseLeftPositionsZ[i-1];
    
    float thisNLy = noseLeftPositionsY[i];
    float prevNLy = noseLeftPositionsY[i-1];
    line(prevNLx, prevNLz, prevNLy, thisNLx, thisNLz, thisNLy);
    
    // ading more lines to the left
    float stroke = random(0.25,1);
//strokeWeight(stroke);
//    line(prevTLx, prevTLz, prevTLy+0.5, thisTLx, thisTLz, thisTLy+0.5);
//    line(prevTLx, prevTLz, prevTLy+1, thisTLx, thisTLz, thisTLy+1);
//    line(prevTLx, prevTLz, prevTLy+1.5, thisTLx, thisTLz, thisTLy+1.5);
//    line(prevTLx, prevTLz, prevTLy+2, thisTLx, thisTLz, thisTLy+2);
//    line(prevTLx, prevTLz, prevTLy+2.5, thisTLx, thisTLz, thisTLy+2.5);
//    
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

  for(Coordinate c : allCoordinates) {
    
    c.displayGround();
     
  }
}




void gui() {

}
