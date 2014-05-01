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

  // Create shapes from tail
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
  
  
  // Create shapes from nose ---------------------------
  // TOP 
   PShape nose_topTail;
  PShape nose_topCenter;
  PShape nose_topNose;

  //  STROKES
  PShape nose_topRightStroke;
  PShape nose_topLeftStroke;
  PShape nose_bottomRightStroke;
  PShape nose_bottomLeftStroke;

  // RIGHT EDGE
  PShape nose_rightEdgeCenter;
  PShape nose_rightEdgeNose;
  PShape nose_rightEdgeTail;

  // LEFT EDGE
  PShape nose_leftEdgeCenter;
  PShape nose_leftEdgeNose;
  PShape nose_leftEdgeTail;

  // BOTTOM
  PShape nose_bottomTail;
  PShape nose_bottomCenter;
  PShape nose_bottomNose;
 

  float cAcceleratingColor; 


  PShape test;
  PShape rectangle;
  Coordinate() {
    // createShapes
    noStroke();

    // draw from tail -------------------------------------------------------------------------------------------------- 

    topTail = createShape();
    topTail.beginShape();
    topTail.vertex(-75+75, 0, 30);
    topTail.bezierVertex(-97.5+75, 0, 30, -120+75, -9, 24, -120+75, -9, 0);
    topTail.bezierVertex(-120+75, -9, -24, -97.5+75, 0, -30, -75+75, 0, -30  );
    topTail.vertex(-75+75, 0, 30);
    topTail.endShape();

    topCenter = createShape();
    topCenter.beginShape();
    topCenter.vertex(-75+75, 0, 30);
    topCenter.vertex(75+75, 0, 30);
    topCenter.vertex(75+75, 0, -30);
    topCenter.vertex(-75+75, 0, -30);
    topCenter.endShape();

    topNose = createShape();
    topNose.beginShape();
    topNose.vertex(75+75, 0, 30);
    topNose.bezierVertex(97.5+75, 0, 30, 120+75, -9, 24, 120+75, -9, 0);
    topNose.bezierVertex(120+75, -9, -24, 97.5+75, 0, -30, 75+75, 0, -30);
    topNose.endShape();

    // TOP RIGHT STROKE
    topRightStroke = createShape();
    topRightStroke.beginShape();
    topRightStroke.vertex(-120+75, -9, 0);
    topRightStroke.bezierVertex(-120+75, -9, 24, -97.5+75, 0, 30, -75+75, 0, 30);
    topRightStroke.vertex(75+75, 0, 30);
    topRightStroke.bezierVertex(97.5+75, 0, 30, 120+75, -9, 24, 120+75, -9, 0);  
    topRightStroke.endShape();

    // TOP LEFT STROKE
    topLeftStroke = createShape();
    topLeftStroke.beginShape();
    topLeftStroke.vertex(-120+75, -9, 0);
    topLeftStroke.bezierVertex(-120+75, -9, -24, -97.5+75, 0, -30, -75+75, 0, -30);
    topLeftStroke.vertex(75+75, 0, -30);
    topLeftStroke.bezierVertex(97.5+75, 0, -30, 120+75, -9, -24, 120+75, -9, 0); 
    topLeftStroke.endShape();

    // BOTTOM RIGHT EDGE STROKE
    bottomRightStroke = createShape();
    bottomRightStroke.beginShape();
    bottomRightStroke.vertex(-120+75, -6, 0);
    bottomRightStroke.bezierVertex(-120+75, -6, 24, -97.5+75, 3, 30, -75+75, 3, 30);
    bottomRightStroke.vertex(75+75, 3, 30);
    bottomRightStroke.bezierVertex(97.5+75, 3, 30, 120+75, -6, 24, 120+75, -6, 0);
    bottomRightStroke.endShape();

    // BOTTOM LEFT STROKE
    bottomLeftStroke = createShape();
    bottomLeftStroke.beginShape();
    bottomLeftStroke.vertex(-120+75, -6, 0);
    bottomLeftStroke.bezierVertex(-120+75, -6, -24, -97.5+75, 3, -30, -75+75, 3, -30);
    bottomLeftStroke.vertex(75+75, 3, -30);
    bottomLeftStroke.bezierVertex(97.5+75, 3, -30, 120+75, -6, -24, 120+75, -6, 0);
    bottomLeftStroke.endShape();

    // right edge
    rightEdgeCenter = createShape();
    rightEdgeCenter.beginShape();
    rightEdgeCenter.vertex(-75+75, 0, 30);
    rightEdgeCenter.vertex(75+75, 0, 30);
    rightEdgeCenter.vertex(75+75, 3, 30);
    rightEdgeCenter.vertex(-75+75, 3, 30);
    rightEdgeCenter.endShape();


    rightEdgeNose = createShape();
    rightEdgeNose.beginShape();
    rightEdgeNose.vertex(75+75, 0, 30);
    rightEdgeNose.vertex(75+75, 3, 30);
    rightEdgeNose.bezierVertex(97.5+75, 3, 30, 120+75, -6, 24, 120+75, -6, 0 );
    rightEdgeNose.vertex(120+75, -9, 0);
    rightEdgeNose.bezierVertex(120+75, -9, 24, 97.5+75, 0, 30, 75+75, 0, 30);
    rightEdgeNose.endShape();

    rightEdgeTail = createShape();
    rightEdgeTail.beginShape();
    rightEdgeTail.vertex(-75+75, 0, 30);
    rightEdgeTail.vertex(-75+75, 3, 30);
    rightEdgeTail.bezierVertex(-97.5+75, 3, 30, -120+75, -6, 24, -120+75, -6, 0);
    rightEdgeTail.vertex(-120+75, -9, 0);
    rightEdgeTail.bezierVertex(-120+75, -9, 24, -97.5+75, 0, 30, -75+75, 0, 30);
    rightEdgeTail.endShape();

    // LEFT EDGE
    leftEdgeCenter = createShape();
    leftEdgeCenter.beginShape();
    leftEdgeCenter.vertex(-75+75, 0, -30);
    leftEdgeCenter.vertex(75+75, 0, -30);
    leftEdgeCenter.vertex(75+75, 3, -30);
    leftEdgeCenter.vertex(-75+75, 3, -30);
    leftEdgeCenter.endShape();


    leftEdgeNose = createShape();
    leftEdgeNose.beginShape();
    leftEdgeNose.vertex(75+75, 0, -30);
    leftEdgeNose.vertex(75+75, 3, -30);
    leftEdgeNose.bezierVertex(97.5+75, 3, -30, 120+75, -6, -24, 120+75, -6, 0);
    leftEdgeNose.vertex(120+75, -9, 0);
    leftEdgeNose.bezierVertex(120+75, -9, -24, 97.5+75, 0, -30, 75+75, 0, -30);
    leftEdgeNose.endShape();


    leftEdgeTail = createShape();
    leftEdgeTail.beginShape();
    leftEdgeTail.vertex(-75+75, 0, -30);
    leftEdgeTail.vertex(-75+75, 3, -30);
    leftEdgeTail.bezierVertex(-97.5+75, 3, -30, -120+75, -6, -24, -120+75, -6, 0);
    leftEdgeTail.vertex(-120+75, -9, 0);
    leftEdgeTail.bezierVertex(-120+75, -9, -24, -97.5+75, 0, -30, -75+75, 0, -30);
    leftEdgeTail.endShape();

    // bottom
    bottomTail = createShape();
    bottomTail.beginShape();
    bottomTail.vertex(-75+75, 3, 30);
    bottomTail.bezierVertex(-97.5+75, 3, 30, -120+75, -6, 24, -120+75, -6, 0);
    bottomTail.bezierVertex(-120+75, -6, -24, -97.5+75, 3, -30, -75+75, 3, -30);
    bottomTail.vertex(-75+75, 3, 30); 
    bottomTail.endShape();

    bottomCenter = createShape();
    bottomCenter.beginShape();
    bottomCenter.vertex(-75+75, 3, 30);
    bottomCenter.vertex(75+75, 3, 30);
    bottomCenter.vertex(75+75, 3, -30);
    bottomCenter.vertex(-75+75, 3, -30);
    bottomCenter.endShape();

    bottomNose = createShape();
    bottomNose.beginShape();
    bottomNose.vertex(75+75, 3, 30);
    bottomNose.bezierVertex(97.5+75, 3, 30, 120+75, -6, 24, 120+75, -6, 0);
    bottomNose.bezierVertex(120+75, -6, -24, 97.5+75, 3, -30, 75+75, 3, -30);
    bottomNose.vertex(75+75, 3, 30);
    bottomNose.endShape();


    // draw from nose ------------------------------------------------------------------------------------
    nose_topTail = createShape();
    nose_topTail.beginShape();
    nose_topTail.vertex(-75-75, 0, 30);
    nose_topTail.bezierVertex(-97.5-75, 0, 30, -120-75, -9, 24, -120-75, -9, 0);
    nose_topTail.bezierVertex(-120-75, -9, -24, -97.5-75, 0, -30, -75-75, 0, -30  );
    nose_topTail.vertex(-75-75, 0, 30);
    nose_topTail.endShape();

    nose_topCenter = createShape();
    nose_topCenter.beginShape();
    nose_topCenter.vertex(-75-75, 0, 30);
    nose_topCenter.vertex(75-75, 0, 30);
    nose_topCenter.vertex(75-75, 0, -30);
    nose_topCenter.vertex(-75-75, 0, -30);
    nose_topCenter.endShape();

    nose_topNose = createShape();
    nose_topNose.beginShape();
    nose_topNose.vertex(75-75, 0, 30);
    nose_topNose.bezierVertex(97.5-75, 0, 30, 120-75, -9, 24, 120-75, -9, 0);
    nose_topNose.bezierVertex(120-75, -9, -24, 97.5-75, 0, -30, 75-75, 0, -30);
    nose_topNose.endShape();

    // TOP RIGHT STROKE
    nose_topRightStroke = createShape();
    nose_topRightStroke.beginShape();
    nose_topRightStroke.vertex(-120-75, -9, 0);
    nose_topRightStroke.bezierVertex(-120-75, -9, 24, -97.5-75, 0, 30, -75-75, 0, 30);
    nose_topRightStroke.vertex(75-75, 0, 30);
    nose_topRightStroke.bezierVertex(97.5-75, 0, 30, 120-75, -9, 24, 120-75, -9, 0);  
    nose_topRightStroke.endShape();

    // TOP LEFT STROKE
    nose_topLeftStroke = createShape();
    nose_topLeftStroke.beginShape();
    nose_topLeftStroke.vertex(-120-75, -9, 0);
    nose_topLeftStroke.bezierVertex(-120-75, -9, -24, -97.5-75, 0, -30, -75-75, 0, -30);
    nose_topLeftStroke.vertex(75-75, 0, -30);
    nose_topLeftStroke.bezierVertex(97.5-75, 0, -30, 120-75, -9, -24, 120-75, -9, 0); 
    nose_topLeftStroke.endShape();

    // BOTTOM RIGHT EDGE STROKE
    nose_bottomRightStroke = createShape();
    nose_bottomRightStroke.beginShape();
    nose_bottomRightStroke.vertex(-120-75, -6, 0);
    nose_bottomRightStroke.bezierVertex(-120-75, -6, 24, -97.5-75, 3, 30, -75-75, 3, 30);
    nose_bottomRightStroke.vertex(75-75, 3, 30);
    nose_bottomRightStroke.bezierVertex(97.5-75, 3, 30, 120-75, -6, 24, 120-75, -6, 0);
    nose_bottomRightStroke.endShape();

    // BOTTOM LEFT STROKE
    nose_bottomLeftStroke = createShape();
    nose_bottomLeftStroke.beginShape();
    nose_bottomLeftStroke.vertex(-120-75, -6, 0);
    nose_bottomLeftStroke.bezierVertex(-120-75, -6, -24, -97.5-75, 3, -30, -75-75, 3, -30);
    nose_bottomLeftStroke.vertex(75-75, 3, -30);
    nose_bottomLeftStroke.bezierVertex(97.5-75, 3, -30, 120-75, -6, -24, 120-75, -6, 0);
    nose_bottomLeftStroke.endShape();

    // right edge
    nose_rightEdgeCenter = createShape();
    nose_rightEdgeCenter.beginShape();
    nose_rightEdgeCenter.vertex(-75-75, 0, 30);
    nose_rightEdgeCenter.vertex(75-75, 0, 30);
    nose_rightEdgeCenter.vertex(75-75, 3, 30);
    nose_rightEdgeCenter.vertex(-75-75, 3, 30);
    nose_rightEdgeCenter.endShape();


    nose_rightEdgeNose = createShape();
    nose_rightEdgeNose.beginShape();
    nose_rightEdgeNose.vertex(75-75, 0, 30);
    nose_rightEdgeNose.vertex(75-75, 3, 30);
    nose_rightEdgeNose.bezierVertex(97.5-75, 3, 30, 120-75, -6, 24, 120-75, -6, 0 );
    nose_rightEdgeNose.vertex(120-75, -9, 0);
    nose_rightEdgeNose.bezierVertex(120-75, -9, 24, 97.5-75, 0, 30, 75-75, 0, 30);
    nose_rightEdgeNose.endShape();

    nose_rightEdgeTail = createShape();
    nose_rightEdgeTail.beginShape();
    nose_rightEdgeTail.vertex(-75-75, 0, 30);
    nose_rightEdgeTail.vertex(-75-75, 3, 30);
    nose_rightEdgeTail.bezierVertex(-97.5-75, 3, 30, -120-75, -6, 24, -120-75, -6, 0);
    nose_rightEdgeTail.vertex(-120-75, -9, 0);
    nose_rightEdgeTail.bezierVertex(-120-75, -9, 24, -97.5-75, 0, 30, -75-75, 0, 30);
    nose_rightEdgeTail.endShape();

    // LEFT EDGE
    nose_leftEdgeCenter = createShape();
    nose_leftEdgeCenter.beginShape();
    nose_leftEdgeCenter.vertex(-75-75, 0, -30);
    nose_leftEdgeCenter.vertex(75-75, 0, -30);
    nose_leftEdgeCenter.vertex(75-75, 3, -30);
    nose_leftEdgeCenter.vertex(-75-75, 3, -30);
    nose_leftEdgeCenter.endShape();


    nose_leftEdgeNose = createShape();
    nose_leftEdgeNose.beginShape();
    nose_leftEdgeNose.vertex(75-75, 0, -30);
    nose_leftEdgeNose.vertex(75-75, 3, -30);
    nose_leftEdgeNose.bezierVertex(97.5-75, 3, -30, 120-75, -6, -24, 120-75, -6, 0);
    nose_leftEdgeNose.vertex(120-75, -9, 0);
    nose_leftEdgeNose.bezierVertex(120-75, -9, -24, 97.5-75, 0, -30, 75-75, 0, -30);
    nose_leftEdgeNose.endShape();


    nose_leftEdgeTail = createShape();
    nose_leftEdgeTail.beginShape();
    nose_leftEdgeTail.vertex(-75-75, 0, -30);
    nose_leftEdgeTail.vertex(-75-75, 3, -30);
    nose_leftEdgeTail.bezierVertex(-97.5-75, 3, -30, -120-75, -6, -24, -120-75, -6, 0);
    nose_leftEdgeTail.vertex(-120-75, -9, 0);
    nose_leftEdgeTail.bezierVertex(-120-75, -9, -24, -97.5-75, 0, -30, -75-75, 0, -30);
    nose_leftEdgeTail.endShape();

    // bottom
    nose_bottomTail = createShape();
    nose_bottomTail.beginShape();
    nose_bottomTail.vertex(-75-75, 3, 30);
    nose_bottomTail.bezierVertex(-97.5-75, 3, 30, -120-75, -6, 24, -120-75, -6, 0);
    nose_bottomTail.bezierVertex(-120-75, -6, -24, -97.5-75, 3, -30, -75-75, 3, -30);
    nose_bottomTail.vertex(-75-75, 3, 30); 
    nose_bottomTail.endShape();

    nose_bottomCenter = createShape();
    nose_bottomCenter.beginShape();
    nose_bottomCenter.vertex(-75-75, 3, 30);
    nose_bottomCenter.vertex(75-75, 3, 30);
    nose_bottomCenter.vertex(75-75, 3, -30);
    nose_bottomCenter.vertex(-75-75, 3, -30);
    nose_bottomCenter.endShape();

    nose_bottomNose = createShape();
    nose_bottomNose.beginShape();
    nose_bottomNose.vertex(75-75, 3, 30);
    nose_bottomNose.bezierVertex(97.5-75, 3, 30, 120-75, -6, 24, 120-75, -6, 0);
    nose_bottomNose.bezierVertex(120-75, -6, -24, 97.5-75, 3, -30, 75-75, 3, -30);
    nose_bottomNose.vertex(75-75, 3, 30);
    nose_bottomNose.endShape();
  }


  // calculate how to translate if nose up or down here
  // loc.x*300 - 75 
  void displayGround() {
    pushMatrix();
//    if (noseDown == false){
//      translate(loc.x*300-75, loc.z*300, loc.y*300);
//    } else if(noseDown == true){
//      translate(loc.x*300+75, loc.z*300, loc.y*300);
//    } else if(cJumping == false){
//      translate(loc.x*300, loc.z*300, loc.y*300);
//    }
     translate(loc.x*300, loc.z*300, loc.y*300);
    float[] axis = quat.toAxisAngle();
    rotate(axis[0], -axis[1], -axis[3], -axis[2]);

          if ( noseDown == false ) {
              translate(-75,0,0);
   
           } else if (noseDown == true) {

             translate(75,0,0);
           }
    strokeWeight(1);



    

    //translate(75,0,0);

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
      } 
      else {
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
      } 
      else {
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
    }  
    if (cJumping == true || cManual == true || cGrinding == true) { // -----------------------------------------------------------------

      float x = modelX(0, 0, 0);
      float y = modelY(0, 0, 0);
      float z = modelZ(0, 0, 0);
      // println(x + " " + y + " " + z);
      //noFill();
      // start with stroke

      if (noseDown == false) {

      topRightStroke.setFill(false);
      topRightStroke.setStroke( true );
      topRightStroke.setStrokeWeight(1);


      if (c180 == false ) {
        topRightStroke.setStroke(color(184, 228, 20));
      } 
      else if (c180 == true) {
        topRightStroke.setStroke(color(0, 200, 255));
      }
      shape(topRightStroke);

      // left top stroke
      topLeftStroke.setFill(false);
      topLeftStroke.setStroke( true );
      topLeftStroke.setStrokeWeight(1);
      if (c180 == false ) {
        topLeftStroke.setStroke(color(20, 200, 255));
      } 
      else if (c180 == true) {
        topLeftStroke.setStroke(color(200, 0, 0));
      }
      shape(topLeftStroke);

      // bottom right edge
      bottomRightStroke.setFill(false);
      bottomRightStroke.setStroke( true );
      bottomRightStroke.setStrokeWeight(1);
      if (c180 == false ) {
        bottomRightStroke.setStroke(color(184, 228, 20));
      } 
      else if (c180 == true) {
        bottomRightStroke.setStroke(color(20, 200, 255));
      }
      shape(bottomRightStroke);

      // BOTTOM LEFT STROKE
      bottomLeftStroke.setFill(false);
      bottomLeftStroke.setStroke( true );
      bottomLeftStroke.setStrokeWeight(1);
      if (c180 == false ) {
        bottomLeftStroke.setStroke(color(20, 200, 255));
      } 
      else if (c180 == true) {
        bottomLeftStroke.setStroke(color(184, 228, 20));
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

        rightEdgeCenter.setFill(color(184, 228, 20));
        rightEdgeNose.setFill(color(184, 228, 20));
        rightEdgeTail.setFill(color(184, 228, 20));
        //    rightEdgeCenter.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
        //    rightEdgeNose.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
        //    rightEdgeTail.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
      } 
      else {
        rightEdgeCenter.setFill(color(20, 200, 255));
        rightEdgeNose.setFill(color(20, 200, 255));
        rightEdgeTail.setFill(color(20, 200, 255));
      }
      shape(rightEdgeCenter);  
      shape(rightEdgeNose);
      shape(rightEdgeTail);

      // left edge
      if ( c180 == false) {
        leftEdgeCenter.setFill(color(20, 200, 255));
        leftEdgeNose.setFill(color(20, 200, 255));
        leftEdgeTail.setFill(color(20, 200, 255));
      } 
      else {
        leftEdgeCenter.setFill(color(184, 228, 20));
        leftEdgeNose.setFill(color(184, 228, 20));
        leftEdgeTail.setFill(color(184, 228, 20));
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
      
      
      } if (noseDown == true) { // draw from nose ----------------------------------------
         nose_topRightStroke.setFill(false);
      nose_topRightStroke.setStroke( true );
      nose_topRightStroke.setStrokeWeight(1);


      if (c180 == false ) {
        nose_topRightStroke.setStroke(color(184, 228, 20));
      } 
      else if (c180 == true) {
        nose_topRightStroke.setStroke(color(0, 200, 255));
      }
      shape(nose_topRightStroke);

      // left top stroke
      nose_topLeftStroke.setFill(false);
      nose_topLeftStroke.setStroke( true );
      nose_topLeftStroke.setStrokeWeight(1);
      if (c180 == false ) {
        nose_topLeftStroke.setStroke(color(20, 200, 255));
      } 
      else if (c180 == true) {
        nose_topLeftStroke.setStroke(color(200, 0, 0));
      }
      shape(nose_topLeftStroke);

      // bottom right edge
      nose_bottomRightStroke.setFill(false);
      nose_bottomRightStroke.setStroke( true );
      nose_bottomRightStroke.setStrokeWeight(1);
      if (c180 == false ) {
        nose_bottomRightStroke.setStroke(color(184, 228, 20));
      } 
      else if (c180 == true) {
        nose_bottomRightStroke.setStroke(color(20, 200, 255));
      }
      shape(nose_bottomRightStroke);

      // BOTTOM LEFT STROKE
      nose_bottomLeftStroke.setFill(false);
      nose_bottomLeftStroke.setStroke( true );
      nose_bottomLeftStroke.setStrokeWeight(1);
      if (c180 == false ) {
        nose_bottomLeftStroke.setStroke(color(20, 200, 255));
      } 
      else if (c180 == true) { 
        nose_bottomLeftStroke.setStroke(color(184, 228, 20));
      }
      shape(nose_bottomLeftStroke);


      nose_topTail.setFill(color(25));
      nose_topCenter.setFill(color(25));
      nose_topNose.setFill(color(25));
      shape(nose_topTail);
      shape(nose_topCenter); 
      shape(nose_topNose);

      // right edge
      if (c180 == false ) {

        nose_rightEdgeCenter.setFill(color(184, 228, 20));
        nose_rightEdgeNose.setFill(color(184, 228, 20));
        nose_rightEdgeTail.setFill(color(184, 228, 20));
        //    rightEdgeCenter.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
        //    rightEdgeNose.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
        //    rightEdgeTail.setFill(color(120+cAcceleratingColor*-1,120+cAcceleratingColor*-1, 45));
      } 
      else {
        nose_rightEdgeCenter.setFill(color(20, 200, 255));
        nose_rightEdgeNose.setFill(color(20, 200, 255));
        nose_rightEdgeTail.setFill(color(20, 200, 255));
      }
      shape(nose_rightEdgeCenter);  
      shape(nose_rightEdgeNose);
      shape(nose_rightEdgeTail);

      // left edge
      if ( c180 == false) {
        nose_leftEdgeCenter.setFill(color(20, 200, 255));
        nose_leftEdgeNose.setFill(color(20, 200, 255));
        nose_leftEdgeTail.setFill(color(20, 200, 255));
      } 
      else {
        nose_leftEdgeCenter.setFill(color(184, 228, 20));
        nose_leftEdgeNose.setFill(color(184, 228, 20));
        nose_leftEdgeTail.setFill(color(184, 228, 20));
      }
      shape(nose_leftEdgeCenter);
      shape(nose_leftEdgeNose);
      shape(nose_leftEdgeTail);

      // bottom
      nose_bottomTail.setFill(color(25));
      nose_bottomCenter.setFill(color(25));
      nose_bottomNose.setFill(color(25));

      shape(nose_bottomTail);
      shape(nose_bottomCenter);
      shape(nose_bottomNose);
     }
      
    }
    

   
  popMatrix();
}

}
