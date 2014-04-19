class Coordinate {

  PVector loc = new PVector();
  // PVector jumpingLoc = new PVector();

  PVector YPR = new PVector();
  Quaternion quat;
  boolean cJumping;
  boolean cLanding;
  
  PShape rectangle;
  

  Coordinate() {
    rectangle = createShape(RECT,-10,-3.5,20,7);
    for (int i = 0; i < rectangle.getVertexCount(); i++) {
      PVector v = rectangle.getVertex(i);
     // println(v);
    }
  }



  void displayGround() {
    pushMatrix();
    rectMode(CENTER);
    translate(loc.x*50, loc.z*50, loc.y*50  );
    float[] axis = quat.toAxisAngle();
    
    rotate(axis[0], -axis[1], -axis[3], -axis[2]);
    strokeWeight(1);
    stroke(255);
    if (cJumping) {
      noFill();
      fill(250, 100, 0, 50);
      stroke(250, 200, 0, 50);
    }  
    else {
       fill(255, 0,0, 20);
      noFill();
      stroke(250, 50);
    }
   // rotateX(PI/2);
    box(20, 1, 7 );
    //shape(rectangle);
    popMatrix();
    
    noStroke();
    noFill();
  }
  

}

