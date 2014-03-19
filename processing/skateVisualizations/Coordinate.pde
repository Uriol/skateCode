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
        fill(150, 150, 0, 100); 
      } else if (cLanding) {
        fill(0); 
      } else {
        fill(255, 100);
      }
      box(20,1,6 );
    popMatrix();
  }
  
//  void displayJump(){
//    pushMatrix();
//       translate(loc.x*100,0,loc.y*100);
//      float[] axis = quat.toAxisAngle();
//      //rotateY(YPR.x);
//      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
//      stroke(255);
//      fill(100,0,0, 100);
//      box(20,2,6 );
//    popMatrix();
//  }
  
}
