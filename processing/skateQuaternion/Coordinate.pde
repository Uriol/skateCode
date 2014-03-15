class Coordinate {
  
  PVector ypr = new PVector();
  // test
  PVector loc = new PVector();
  
  Quaternion quat;
  
  Coordinate(){}
  
  void display(){
    pushMatrix();
      translate(50, 0, 0);
      float[] axis = quat.toAxisAngle();
      //rotateY(PI/2);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      stroke(255);
      fill(255, 100);
      box(100,10,30);
    popMatrix();
  }
  
}
