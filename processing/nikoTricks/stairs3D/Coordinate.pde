class Coordinate {
  
  PVector loc = new PVector();
 // PVector jumpingLoc = new PVector();
  
  PVector YPR = new PVector();
  Quaternion quat;
  boolean cJumping;
  boolean cLanding;
  boolean cGrinding;
  boolean c180;
  boolean cAccelerating;
  boolean cStopping;
  boolean cManual;
  boolean noseDown;
  
  // Create shapes
  // TOP 
  PShape topTail;
  PShape topCenter;
  PShape topNose;
  
  //  STROKES
  PShape topRightStroke;
  PShape topLeftStroke;
  PShape bottomRightStroke;
  PShape bottomLeftStroke;
  
  // RIGHT EDGE
  PShape rightEdgeCenter;
  PShape rightEdgeNose;
  PShape rightEdgeTail;
  
  // LEFT EDGE
  PShape leftEdgeCenter;
  PShape leftEdgeNose;
  PShape leftEdgeTail;
  
  // BOTTOM
  PShape bottomTail;
  PShape bottomCenter;
  PShape bottomNose;
 
 
 float cAcceleratingColor; 
 
  
  PShape test;
  PShape rectangle;
  Coordinate(){
// createShapes
  noStroke();
 
  
  
  topTail = createShape();
  topTail.beginShape();
     topTail.vertex(-75,0,30);
     topTail.bezierVertex(-97.5,0,30, -120,-9,24, -120,-9,0);
     topTail.bezierVertex(-120,-9,-24, -97.5,0,-30, -75,0,-30  );
     topTail.vertex(-75,0,30);
  topTail.endShape();
  
  topCenter = createShape();
  topCenter.beginShape();
      topCenter.vertex(-75,0,30);
       topCenter.vertex(75,0,30);
       topCenter.vertex(75,0,-30);
       topCenter.vertex(-75,0,-30);
  topCenter.endShape();
  
  topNose = createShape();
  topNose.beginShape();
        topNose.vertex(75,0,30);
        topNose.bezierVertex(97.5,0,30, 120,-9,24, 120,-9,0);
        topNose.bezierVertex(120,-9,-24, 97.5,0,-30, 75,0,-30);
  topNose.endShape();
  
  // TOP RIGHT STROKE
  topRightStroke = createShape();
  topRightStroke.beginShape();
    topRightStroke.vertex(-120,-9,0);
    topRightStroke.bezierVertex(-120,-9,24, -97.5,0,30, -75,0,30);
    topRightStroke.vertex(75,0,30);
    topRightStroke.bezierVertex(97.5,0,30, 120,-9,24, 120,-9,0);  
  topRightStroke.endShape();
  
  // TOP LEFT STROKE
  topLeftStroke = createShape();
  topLeftStroke.beginShape();
    topLeftStroke.vertex(-120,-9,0);
    topLeftStroke.bezierVertex(-120,-9,-24, -97.5,0,-30, -75,0,-30);
    topLeftStroke.vertex(75,0,-30);
    topLeftStroke.bezierVertex(97.5,0,-30, 120,-9,-24, 120,-9,0); 
  topLeftStroke.endShape();
  
  // BOTTOM RIGHT EDGE STROKE
  bottomRightStroke = createShape();
  bottomRightStroke.beginShape();
    bottomRightStroke.vertex(-120,-6,0);
    bottomRightStroke.bezierVertex(-120,-6,24, -97.5,3,30, -75,3,30);
    bottomRightStroke.vertex(75,3,30);
    bottomRightStroke.bezierVertex(97.5,3,30, 120,-6,24, 120,-6,0);
  bottomRightStroke.endShape();
  
  // BOTTOM LEFT STROKE
  bottomLeftStroke = createShape();
  bottomLeftStroke.beginShape();
    bottomLeftStroke.vertex(-120,-6,0);
    bottomLeftStroke.bezierVertex(-120,-6,-24, -97.5,3,-30, -75,3,-30);
    bottomLeftStroke.vertex(75,3,-30);
    bottomLeftStroke.bezierVertex(97.5,3,-30, 120,-6,-24, 120,-6,0);
  bottomLeftStroke.endShape();
  
  // right edge
  rightEdgeCenter = createShape();
  rightEdgeCenter.beginShape();
    rightEdgeCenter.vertex(-75,0,30);
    rightEdgeCenter.vertex(75,0,30);
     rightEdgeCenter.vertex(75,3,30);
     rightEdgeCenter.vertex(-75,3,30);
  rightEdgeCenter.endShape();
  
  
  rightEdgeNose = createShape();
  rightEdgeNose.beginShape();
     rightEdgeNose.vertex(75,0,30);
      rightEdgeNose.vertex(75,3,30);
      rightEdgeNose.bezierVertex(97.5,3,30, 120,-6,24,120,-6,0 );
          rightEdgeNose.vertex(120, -9,0);
          rightEdgeNose.bezierVertex(120,-9,24, 97.5,0,30, 75,0,30);
  rightEdgeNose.endShape();
  
  rightEdgeTail = createShape();
  rightEdgeTail.beginShape();
        rightEdgeTail.vertex(-75,0,30);
          rightEdgeTail.vertex(-75,3,30);
          rightEdgeTail.bezierVertex(-97.5,3,30, -120,-6,24, -120,-6,0);
          rightEdgeTail.vertex(-120,-9,0);
          rightEdgeTail.bezierVertex(-120,-9,24, -97.5,0,30, -75,0,30);
  rightEdgeTail.endShape();
  
  // LEFT EDGE
  leftEdgeCenter = createShape();
  leftEdgeCenter.beginShape();
     leftEdgeCenter.vertex(-75,0,-30);
     leftEdgeCenter.vertex(75,0,-30);
     leftEdgeCenter.vertex(75,3,-30);
     leftEdgeCenter.vertex(-75,3,-30);
  leftEdgeCenter.endShape();
  
  
  leftEdgeNose = createShape();
  leftEdgeNose.beginShape();
      leftEdgeNose.vertex(75,0,-30);
      leftEdgeNose.vertex(75,3,-30);
      leftEdgeNose.bezierVertex(97.5,3,-30, 120,-6,-24,120,-6,0);
      leftEdgeNose.vertex(120, -9,0);
      leftEdgeNose.bezierVertex(120,-9,-24, 97.5,0,-30, 75,0,-30);
  leftEdgeNose.endShape();
  
  
  leftEdgeTail = createShape();
  leftEdgeTail.beginShape();
        leftEdgeTail.vertex(-75,0,-30);
      leftEdgeTail.vertex(-75,3,-30);
      leftEdgeTail.bezierVertex(-97.5,3,-30, -120,-6,-24,-120,-6,0);
      leftEdgeTail.vertex(-120, -9,0);
      leftEdgeTail.bezierVertex(-120,-9,-24,  -97.5,0,-30, -75,0,-30);
  leftEdgeTail.endShape();
  
  // bottom
  bottomTail = createShape();
  bottomTail.beginShape();
          bottomTail.vertex(-75,3,30);
        bottomTail.bezierVertex(-97.5,3,30, -120,-6,24, -120,-6,0);
       bottomTail.bezierVertex(-120,-6,-24, -97.5,3,-30, -75,3,-30);
        bottomTail.vertex(-75,3,30); 
  bottomTail.endShape();
  
  bottomCenter = createShape();
  bottomCenter.beginShape();
       bottomCenter.vertex(-75,3,30);
       bottomCenter.vertex(75,3,30);
       bottomCenter.vertex(75,3,-30);
       bottomCenter.vertex(-75,3,-30);
  bottomCenter.endShape();
  
  bottomNose = createShape();
  bottomNose.beginShape();
          bottomNose.vertex(75,3,30);
        bottomNose.bezierVertex(97.5,3,30, 120,-6,24, 120,-6,0);
        bottomNose.bezierVertex(120,-6,-24, 97.5,3,-30, 75,3,-30);
        bottomNose.vertex(75,3,30);
  bottomNose.endShape();
  
  }
  

  
  void displayGround(){
    pushMatrix();
      translate(loc.x*300,loc.z*300, loc.y*300);
      float[] axis = quat.toAxisAngle();
     
//       if ( noseDown == false ) {
////          translate(-75,0,0);
//          println("nose up");
//          rotate(axis[0], -axis[1], -axis[3], -axis[2]);
//          translate(75,0,0);
//       } else if (noseDown == true) {
//         rotate(axis[0], -axis[1], -axis[3], -axis[2]);
//         translate(75,0,0);
//        println("nose down");  
////          rotate(axis[0], -axis[1], -axis[3], -axis[2]);
////         // translate(-75,0,0);
//       }
      strokeWeight(1);
      if ( noseDown == false ) {
        println("nose down false");
      }
      

rotate(axis[0], -axis[1], -axis[3], -axis[2]);

translate(75,0,0);

 if (cJumping == false ) { 
   
   
   

   
  topTail.setFill(color(25));
  topCenter.setFill(color(25));
  topNose.setFill(color(25));
  shape(topTail);
  shape(topCenter); 
  shape(topNose);
//  
//  // right edge
  if (c180 == false ) {
    rightEdgeCenter.setFill(color(50));
    rightEdgeNose.setFill(color(50));
    rightEdgeTail.setFill(color(50));
  } else {
    rightEdgeCenter.setFill(color(50));
    rightEdgeNose.setFill(color(50));
    rightEdgeTail.setFill(color(50));
  }
  shape(rightEdgeCenter);  
  shape(rightEdgeNose);
  shape(rightEdgeTail);
//  
//  // left edge
  if ( c180 == false) {
  leftEdgeCenter.setFill(color(50));
  leftEdgeNose.setFill(color(50));
  leftEdgeTail.setFill(color(50));
  } else {
    leftEdgeCenter.setFill(color(50));
    leftEdgeNose.setFill(color(50));
    leftEdgeTail.setFill(color(50));
  }
  shape(leftEdgeCenter);
  shape(leftEdgeNose);
  shape(leftEdgeTail);
//  
//  // bottom
  bottomTail.setFill(color(25 ));
  bottomCenter.setFill(color(25));
  bottomNose.setFill(color(25));
  shape(bottomTail);
  shape(bottomCenter);
  shape(bottomNose);
      
//      //translate(20,0,0);
//     rectMode(CENTER);
//    // box(40, 0.5,10);
//     
//     noStroke();
 
 }  if (cJumping == true || cManual == true || cGrinding == true) { // -----------------------------------------------------------------
   
     float x = modelX(0, 0, 0);
      float y = modelY(0, 0, 0);
      float z = modelZ(0, 0, 0);
     // println(x + " " + y + " " + z);
    //noFill();
   // start with stroke
   topRightStroke.setFill(false);
   topRightStroke.setStroke( true );
   topRightStroke.setStrokeWeight(1);
   
  
   if (c180 == false ) {
     topRightStroke.setStroke(color(184,228,20));
   } else if (c180 == true){
     topRightStroke.setStroke(color(0,200,255));
   }
    shape(topRightStroke);
   
// left top stroke
   topLeftStroke.setFill(false);
   topLeftStroke.setStroke( true );
   topLeftStroke.setStrokeWeight(1);
    if (c180 == false ) {
         topLeftStroke.setStroke(color(20,200,255));
   } else if (c180 == true){
        topLeftStroke.setStroke(color(200,0,0));
   }
   shape(topLeftStroke);
   
// bottom right edge
   bottomRightStroke.setFill(false);
   bottomRightStroke.setStroke( true );
   bottomRightStroke.setStrokeWeight(1);
    if (c180 == false ) {
         bottomRightStroke.setStroke(color(184,228,20));
   } else if (c180 == true){
        bottomRightStroke.setStroke(color(20,200,255));
   }
      shape(bottomRightStroke);
   
   // BOTTOM LEFT STROKE
    bottomLeftStroke.setFill(false);
   bottomLeftStroke.setStroke( true );
   bottomLeftStroke.setStrokeWeight(1);
    if (c180 == false ) {
      bottomLeftStroke.setStroke(color(20,200,255));
   } else if (c180 == true){
     bottomLeftStroke.setStroke(color(184,228,20));
   }
  shape(bottomLeftStroke);


  topTail.setFill(color(25));
  topCenter.setFill(color(25));
  topNose.setFill(color(25));
  shape(topTail);
  shape(topCenter); 
  shape(topNose);
  
  // right edge
  if (c180 == false ) {

rightEdgeCenter.setFill(color(184,228,20));
    rightEdgeNose.setFill(color(184,228,20));
    rightEdgeTail.setFill(color(184,228,20));
//    rightEdgeCenter.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
//    rightEdgeNose.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
//    rightEdgeTail.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));

  } else {
    rightEdgeCenter.setFill(color(20,200,255));
    rightEdgeNose.setFill(color(20,200,255));
    rightEdgeTail.setFill(color(20,200,255));
  }
  shape(rightEdgeCenter);  
  shape(rightEdgeNose);
  shape(rightEdgeTail);
  
  // left edge
  if ( c180 == false) {
  leftEdgeCenter.setFill(color(20,200,255));
  leftEdgeNose.setFill(color(20,200,255));
  leftEdgeTail.setFill(color(20,200,255));
  } else {
    leftEdgeCenter.setFill(color(184,228,20));
    leftEdgeNose.setFill(color(184,228,20));
    leftEdgeTail.setFill(color(184,228,20));
  }
  shape(leftEdgeCenter);
  shape(leftEdgeNose);
  shape(leftEdgeTail);
  
  // bottom
  bottomTail.setFill(color(25));
  bottomCenter.setFill(color(25));
  bottomNose.setFill(color(25));

  shape(bottomTail);
  shape(bottomCenter);
  shape(bottomNose);
   
 }
  popMatrix();
      
 
    
 }
 
}
