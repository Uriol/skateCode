import peasy.*;
PeasyCam cam;

ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();


float time = 0.02;
float totalSpeed, previousTotalSpeed;
int boxCounter;

// Yaw
float[] yaw;
float initialYaw;

float angleDifference = 0;
float totalAngleDifference;

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


String[] rawData;



void setup() {
  size(1400, 800, OPENGL);
  cam = new PeasyCam(this, 100);
  colorMode(HSB);

  rawData = loadStrings("secondTry.csv");

  parseTextFile("secondTry.csv");
  calculateInitialSpeed();
  calculatePositions();
  //println(xPositions);
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


void drawBoxes() {
  // println(boxCounter);

  boxCounter++;

  if ( boxCounter >= rawData.length-100) {
    boxCounter = 0;
  }
  
  for (int i = 1; i < boxCounter; i++) {
    Coordinate c = allCoordinates.get(i);
    c.display();
  } 
  
  // println(xPositions[boxCounter]);
  
//  pushMatrix();
//  translate(xPositions[boxCounter]*20, 0, yPositions[boxCounter]*20);
//  fill(255, 100);
//  box(25, 2, 10);
//  popMatrix();
}

void parseTextFile(String _name) {
  yaw = new float[rawData.length];
  xAccel = new float[rawData.length];

  for (int i = 0; i < rawData.length; i++) {
    String[] thisRow = split(rawData[i], ",");
    yaw[i] = float(thisRow[0]);
    xAccel[i] = float(thisRow[1]);
    // println(thisRow.length);
  }
}

void calculateInitialSpeed() {
  // The first 2 seconds are not represented. 
  // Used to calculate the speed and the initial yaw. 
  for ( int j = 0; j < 100; j++) {
    // println(xAccel[j]);
    totalSpeed = previousTotalSpeed + (xAccel[j]*9.8)*time*-1;
    previousTotalSpeed = totalSpeed;
    initialYaw = yaw[j];
  }
  // println(totalSpeed);
}

void  calculatePositions() {
  // Loop through the data after the 5 first seconds.
  xPositions = new float[rawData.length-100];
  yPositions = new float[rawData.length-100];

  for ( int k = 100; k < rawData.length; k++) {
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
    //xPosition = xPosition+0.5;
    xInitialPosition = xPosition;
    xPositions[k-100] = xPosition;
    //println(xPositions[k-100]);

    // Calculate speed for y
    ySpeed = totalSpeed*sin(totalAngleDifference);
    //println(ySpeed);
    yPosition = yInitialPosition + ySpeed*time;
    //yPosition = yPosition+0.5;
    yInitialPosition = yPosition;
    yPositions[k-100] = yPosition;
    //println(xPosition + ", " + yPosition);
    
    
    
    // Add to coordinates class
    Coordinate c = new Coordinate();
    c.loc.add(xPosition, yPosition, 0);
    c.YPR.add(totalAngleDifference*-1,0,0);
    allCoordinates.add(c);
  }
}

