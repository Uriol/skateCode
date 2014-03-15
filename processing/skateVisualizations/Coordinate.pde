class Coordinate {
  
  PVector loc = new PVector();
  PVector YPR = new PVector();
  Quaternion quat;
  
  Coordinate(){}
  
  void displayGround(){
    pushMatrix();
      translate(loc.x*100,0,loc.y*100);
      float[] axis = quat.toAxisAngle();
      //rotateY(YPR.x);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      stroke(255);
      fill(255, 100);
      box(10,1,3 );
    popMatrix();
  }
  
}
