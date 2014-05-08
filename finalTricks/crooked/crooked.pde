import toxi.processing.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import peasy.*;
import controlP5.*;
import processing.video.*;
//import processing.opengl.*;

PeasyCam cam;
PImage gui;

PImage img;
PImage name;

PImage altitudeNumber;
PImage grindTime;
PImage grindSpeed;
PImage grindDistance;

Movie video;



float totalSpeed = 3.88;
String csvFile = "crooked.csv";

ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();

//float time = 0.0004;
float time = 0.02;
float airtime = 0;
float previousPitch;

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
float firstJumpSpeed = -0.55; // for ollie180
//float firstJumpSpeed = 1;
float secondJumpSpeed = -3.06; 
float thirdJumpSpeed = 1;
float fourthJumpSpeed = -3.5;





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

PFont myFont;

void setup() {
  size(1440, 850, OPENGL);
  //frameRate(200);
  //g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 500);
  
  gui = loadImage("guiTest3.png");

  name = loadImage("crooked.png");
  
  altitudeNumber = loadImage("altitudeNumber.png");
  grindTime = loadImage("grindTime.png");
  grindSpeed = loadImage("grindSpeed.png");
  grindDistance = loadImage("grindDistance.png");

  
  video = new Movie(this, "crooked960.mov");
  video.loop();
  

  rawData = loadStrings(csvFile);
  parseTextFile(csvFile);
  calculatePositions();
// calculateSkateBoards();

myFont = loadFont("Futura-CondensedBold-48.vlw");
// String[] fontList = PFont.list();
// println(fontList);

}

void draw() {



  background(25);
  smooth();
 
   noLights();
  //gui();

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




pushMatrix();

   translate(4400 ,27,45);
 // translate(500,0,0);
  rotateY(3.14);
  //fill(25);
  noFill();
  stroke(255);
  drawPark();
  popMatrix();
  
  
   drawBoxes();
  
   // TRICK NAME
cam.beginHUD();
image(name, 40, height-75);
cam.endHUD();
gui();
cam.beginHUD();
fill(25);
noStroke();
rect(width-380, 20, 360,220); 
image(video, width-360,40,320,180);
cam.endHUD();
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

void movieEvent(Movie video) {
  video.read();
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

// calculate grind
void onGrind(){
  ground = false;
  grinding = true;
  jumping = false;
  //println("grinding");
  
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
  c.noseDown = true;
  allCoordinates.add(c);
}




void onGround(){
  
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
  
  
  
  
  //println("zSpeed:" + zSpeed);
  airtime = airtime + 0.02;
  //println("airtime:" + airtime);
   zPosition = zInitialPosition + zSpeed*airtime - 0.5*9.8*airtime*airtime ;
   
   // if goes down it goes faster
   if (prev_zPosition <= zPosition) {
    //println("going up");
    
  } else if ( prev_zPosition > zPosition) {
   // println("going down"); 
    zSpeed = zSpeed-0.05;
    zPosition = zInitialPosition + zSpeed*airtime - 0.5*9.8*airtime*airtime ;
  }

  //println(zPosition);
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
  
 
  
  if ( pitch[k] <= previousPitch ) { 
    println("nose up"); 
    c.noseDown = false;
  } else { 
    println("nose down");
    c.noseDown = true;
  };
  
  
  c.cAcceleratingColor = acceleratingColor;
  prev_zPosition = zPosition;
  c.quat = new Quaternion().createFromEuler(pitch[k]*-1,totalAngleDifference,roll[k]*-1);
  c.cJumping = jumping;
  allCoordinates.add(c);
  
  
  
  
  prev_zPosition = zPosition;
  previousPitch = pitch[k];
  
}

void calculateLanding(){
  // restart
  airtime = 0;
  zInitialPosition = zPosition;
  println(zInitialPosition);
  println("calculateLanding");

    if (firstJump == true && firstJumpLanding == false) { firstJumpLanding = true;println("firstJump" + firstJump);grinding = true;};
    if (secondJump == true && secondJumpLanding == false) { secondJumpLanding = true; println("secondJump" + secondJump); grinding = false;};
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


void drawBoxes() {
  boxCounter++;
  
  if ( boxCounter >= allCoordinates.size()) {
    boxCounter = 0;
  }
  
  for ( int i = 1; i < boxCounter; i++) {
  //for (int i = 0; i < allCoordinates.size()-allCoordinates.size()+1; i++) {
    Coordinate c = allCoordinates.get(i);
    
    //drawSkateboards();
      c.displayGround(); 
  } 
// delay(15); 

//  for(Coordinate c : allCoordinates) {
//    
//    c.displayGround();
//     
//  }
}

void drawPark(){
  stroke(220);
  noFill();
  // small module start from bottom left
  //base
  beginShape();
    vertex(0,0,0);
    vertex(1462.8,0,0);
    vertex(1462.8,0,366);
    vertex(0,0,366);
    vertex(0,0,0);
  endShape();
  
  // top
  beginShape();
    vertex(0,-38,0);
    vertex(1462.8,-38,0);
    vertex(1462.8,-38,366);
    vertex(0,-38,366);
    vertex(0,-38,0);
  endShape();
  
  // left
  beginShape();
    vertex(0,0,0);
    vertex(0,-38, 0);
    vertex(0, -38, 366);
    vertex(0,0,366);
  endShape();
  
   // right
  beginShape();
    vertex(1462.8,0,0);
    vertex(1462.8,-38, 0);
    vertex(1462.8, -38, 366);
    vertex(1462.8,0,366);
  endShape();
  
  // big module
  // base
  beginShape();
    vertex(-445.8, 0, -183);
    vertex(1462.8+445.8, 0, -183);
    vertex(1462.8+445.8, 0, 0);
    vertex(-445.8, 0, 0);
    vertex(-445.8, 0, -183);
  endShape();
  
  // top
  beginShape();
    vertex(-445.8, -152.4, -183);
    vertex(1462.8+445.8, -152.4, -183);
    vertex(1462.8+445.8, -152.4, 0);
    vertex(-445.8, -152.4, 0);
    vertex(-445.8, -152.4, -183);
  endShape();
  
  // left
  beginShape();
  vertex(-445.8, 0, -183);
  vertex(-445.8, -152.4, -183);
  vertex(-445.8, -152.4, 0);
  vertex(-445.8, 0, 0);
  vertex(-445.8, 0, -183);
  endShape();
  
  // right
  beginShape();
  vertex(1462.8+445.8, 0, -183);
  vertex(1462.8+445.8, -152.4, -183);
  vertex(1462.8+445.8, -152.4, 0);
  vertex(1462.8+445.8, 0, 0);
  vertex(1462.8+445.8, 0, -183);
  endShape();
}

void gui() {
  cam.beginHUD();
  noStroke();
  fill(25);
  rect(width-400,0,420,height);
  

pushMatrix();
translate(0,340);
fill(255);
//text("Meters", width-260, 0);
 
//  // jump Altitude
  pushMatrix();

  image(altitudeNumber, width-360, 0, 147,35); // 89
  textFont(myFont,14);
  fill(255);
  //text("METERS", width-255, 35); // 271
   textFont(myFont,15);
   fill(184, 228, 0);
  text("JUMP ALTITUDE", width-360, 60); //+16
  stroke(50);
  
  line(width-360, 75, width-40, 75);
  popMatrix();
 
 pushMatrix();
  translate(0,90,0);
  image(grindTime, width-360, 0, 103,35); // 89
  textFont(myFont,14);
  fill(255);
  //text("METERS", width-255, 35); // 271
   textFont(myFont,15);
   fill(184, 228, 0);
  text("GRIND TIME", width-360, 60); //+16
  stroke(50);
  line(width-360, 75, width-40, 75);
  popMatrix();
  
  
  
pushMatrix();
  translate(0,90*2,0);
  image(grindSpeed, width-360, 0, 195,35); // 89
  textFont(myFont,14);
  fill(255);
  //text("METERS", width-255, 35); // 271
   textFont(myFont,15);
   fill(184, 228, 0);
  text("GRIND SPEED", width-360, 60); //+16
  stroke(50);
  line(width-360, 75, width-40, 75);
  popMatrix();
  
  
  pushMatrix();
  translate(0,90*3,0);
  image(grindDistance, width-360, 0, 132,35); // 89
  textFont(myFont,14);
  fill(255);
  //text("METERS", width-255, 35); // 271
   textFont(myFont,15);
   fill(184, 228, 0);
  text("GRIND DISTANCE", width-360, 60); //+16
  stroke(50);
  //line(width-360, 75, width-40, 75);
  popMatrix();

 
   
  
 popMatrix();
  cam.endHUD();
}
