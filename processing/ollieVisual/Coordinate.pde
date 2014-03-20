class Coordinate {
  
  PVector loc = new PVector();
 // PVector jumpingLoc = new PVector();
  
  PVector YPR = new PVector();
  Quaternion quat;
  boolean cJumping;
  boolean cLanding;
  
  Coordinate(){}
  

  
  void displayGround(){
    pushMatrix();
      translate(loc.x*50,loc.z*50,loc.y*50);
      float[] axis = quat.toAxisAngle();
      //rotateY(YPR.x);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      stroke(255);
      if(cJumping) {
        fill(250, 0, 0, 100); 
      }  else {
        fill(0, 250, 0, 100); 
      }
      box(20,1,6 );
    popMatrix();
  }
  

  
}
