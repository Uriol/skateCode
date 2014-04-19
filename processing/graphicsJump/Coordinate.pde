class Coordinate {
  
  PVector loc = new PVector();
 // PVector jumpingLoc = new PVector();
  
  PVector YPR = new PVector();
  Quaternion quat;
  boolean cJumping;
  boolean cLanding;
  boolean c180;
  
  Coordinate(){}
  

  
  void displayGround(){
    pushMatrix();
      translate(loc.x*70,loc.z*70, loc.y*70);
      float[] axis = quat.toAxisAngle();
     
     // translate(-20,5,0);
      
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      
       rotateX(-PI/2);
     //  translate(33.5, 0,0);
      strokeWeight(1);
       stroke(255);
      if(cJumping) {
       // noFill();
        stroke(255,255,0);
        fill(20);
        //fill(150, 150, 0, 100); 
      } else if (cLanding) {
        fill(0); 
      } else {
        fill(255, 50);
      }
      
      //translate(20,0,0);
     rectMode(CENTER);
     //box(40, 0,10);
     rect(0,0, 40,10);


    popMatrix();
  }
  
  
}
