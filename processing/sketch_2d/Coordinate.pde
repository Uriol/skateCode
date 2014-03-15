class Coordinate {
  
  PVector loc = new PVector();
  PVector YPR = new PVector();
   
   
  Coordinate(){
  }
  
  void display() {
    pushMatrix();
    translate(loc.x*100,0,loc.y*100);
    rotateY(YPR.x);
    stroke(255);
      fill(255, 100);
      box(10,1,3 );
    popMatrix();
  }

}
