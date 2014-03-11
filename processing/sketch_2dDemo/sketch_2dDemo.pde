float time = 0.02;
float totalSpeed, previousTotalSpeed;


// Yaw
float[] yaw;
float initialYaw;

float angleDifference = 0;
float totalAngleDifference;

// X edge
float[] xAccel;
float xInitialSpeed = 0;
float xSpeed = 0;
float xInitialPosition = 0;
float xPosition = 0;

// Y edge
float yInitialSpeed = 0;
float ySpeed = 0;
float yInitialPosition = 0; 
float yPosition = 0;


// first 250 = 5 seconds

void setup() {
   size(1200, 800);
 background(230);
  noStroke();
 rectMode(CENTER);
 //rectMODE(CENTER);

 
 
  String[] rawData = loadStrings("2dDemo.csv");
  
  yaw = new float[rawData.length];
  xAccel = new float[rawData.length];
  
  for(int i = 0; i < rawData.length; i++) {
    String[] thisRow = split(rawData[i], ",");
    
    xAccel[i] = float(thisRow[0]);
    yaw[i] = float(thisRow[1]);
    //println(thisRow.length);
  }
  
  // The first 5 seconds are not represented. 
  // Used to calculate the speed and the initial yaw. 
  for( int j = 0; j < 250; j++) {
    //println(xAccel[j]);
    totalSpeed = previousTotalSpeed + (xAccel[j]*9.8)*time;
    previousTotalSpeed = totalSpeed;
    initialYaw = yaw[j];
    
  }
 

  //println(totalSpeed);
  
  
  
  // Loop through the data after the 5 first seconds.
  for( int k = 250; k < rawData.length; k++){
    
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
    //println(xPosition);
    
    // Calculate speed for y
    ySpeed = totalSpeed*sin(totalAngleDifference);
    //println(ySpeed);
    yPosition = yInitialPosition + ySpeed*time;
    yInitialPosition = yPosition;
    println(xPosition + ", " + yPosition);
    
    
    // Draw rect in position
      
     stroke(100);
     fill(100);
      translate(width/2, height/2);
      rectMode(CENTER);
      //rotate(totalAngleDifference);
      rect( yPosition+10, xPosition+10, 10, 30);
//     rect( width/2+yPosition*200, xPosition*200, 10, 30);
//     if (totalAngleDifference != 0) {
//       rectMode(CENTER);
//     //translate(width/2, height/2);
//     rotate(totalAngleDifference); }
     
     //popMatrix();
    
  }
  
  
  
}



void draw(){
//  fill(100);
//  translate(width/2, height/2);
//  rectMode(CENTER);
//   rotate(3);
//  rect( 0, 0, 10, 30);
 
  
}
