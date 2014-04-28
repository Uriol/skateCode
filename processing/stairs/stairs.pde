import peasy.*;
PeasyCam cam;

void setup(){
  size(1344, 760, OPENGL);
  cam = new PeasyCam(this, 500);
}

void draw(){
   background(25);
  smooth();
  fill(25);
  //noFill();
  stroke(50);
  
  pushMatrix();
  rotateY(45);
  translate(1972.4008, 0, 733.3477);
  drawPark();
  popMatrix();

   
   
}

void drawPark(){
    // base
  beginShape();
  vertex(0,0,0);
  vertex(0,0,0-91.2);
  vertex(0-91.2,0, 0-91.2); 
  vertex(0-91.2,0, -5000);
  vertex(1013+171,0, -5000);
  vertex(1013+171,0, 0-91.2);
  vertex(1013,0, 0-91.2);
  vertex(1013,0, 0);
  endShape(CLOSE);
  
  // base left wall
  beginShape();
   vertex(0-91.2,0, 0-91.2); 
    vertex(0-91.2,0, -5000); 
    vertex(0-91.2,49.5*5, -5000); 
    vertex(0-91.2,49.5*5, 0-91.2); 
  endShape(CLOSE);
  
  // base right wall
  beginShape();
   vertex(1013+171,0, 0-91.2); 
    vertex(1013+171,0, -5000); 
    vertex(1013+171,49.5*5, -5000); 
    vertex(1013+171,49.5*5, 0-91.2); 
  endShape(CLOSE);
  
  // base back wall
  beginShape();
    vertex(0-91.2,0, -5000);
    vertex(0-91.2,49.5*5, -5000);
    vertex(1013+171,49.5*5, -5000);
    vertex(1013+171,0, -5000);
  endShape(CLOSE);
  
  // base bottom wall
  beginShape();
    vertex(0-91.2,49.5*5, -5000);
    vertex(1013+171,49.5*5, -5000);
    vertex(1013+171,49.5*5, 133.2*4);
    vertex(0-91.2,49.5*5, 133.2*4);
  endShape(CLOSE);
  
  // first step -----------------------------------------------------------------
  beginShape();
    vertex(0, 0,0);
    vertex(1013,0,0);
    vertex(1013,49.5,0);
    vertex(0,49.5,0);
  endShape(CLOSE);
  
  // SECOND STEP
  beginShape();
  vertex(0,49.5,0);
  vertex(1013,49.5,0);
  vertex(1013, 49.5, 133.2);
  vertex(0,49.5,133.2);
  endShape(CLOSE);
  
  beginShape();
  vertex(0, 49.5,133.2);
    vertex(1013,49.5,133.2);
    vertex(1013,49.5*2,133.2);
    vertex(0,49.5*2,133.2);
  endShape(CLOSE);
  
  //THIRD STEP
   beginShape();
  vertex(0,49.5*2,133.2);
  vertex(1013,49.5*2,133.2);
  vertex(1013, 49.5*2, 133.2*2);
  vertex(0,49.5*2,133.2*2);
  endShape(CLOSE);
  
  beginShape();
  vertex(0, 49.5*2,133.2*2);
    vertex(1013,49.5*2,133.2*2);
    vertex(1013,49.5*3,133.2*2);
    vertex(0,49.5*3,133.2*2);
  endShape(CLOSE);
  
  // FOURTH STEP
   beginShape();
  vertex(0,49.5*3,133.2*2);
  vertex(1013,49.5*3,133.2*2);
  vertex(1013, 49.5*3, 133.2*3);
  vertex(0,49.5*3,133.2*3);
  endShape(CLOSE);
  
  beginShape();
  vertex(0, 49.5*3,133.2*3);
    vertex(1013,49.5*3,133.2*3);
    vertex(1013,49.5*4,133.2*3);
    vertex(0,49.5*4,133.2*3);
  endShape(CLOSE);
  
  // FIFTH STEP
   beginShape();
  vertex(0,49.5*4,133.2*3);
  vertex(1013,49.5*4,133.2*3);
  vertex(1013, 49.5*4, 133.2*4);
  vertex(0,49.5*4,133.2*4);
  endShape(CLOSE);
  
  beginShape();
  vertex(0, 49.5*4,133.2*4);
    vertex(1013,49.5*4,133.2*4);
    vertex(1013,49.5*5,133.2*4);
    vertex(0,49.5*5,133.2*4);
  endShape(CLOSE);
  
  
  // LEFT EDGE -----------------------------------------------------------------
  
  // From down to up // left right
  beginShape();
    vertex(0-91.2, 49.5*5, 0-91.2);
    //vertex(0-91.2, 0-205.5, 0-91.2);
    vertex(0-91.2,0-205.5, 0-91.2);
   vertex(0-91.2,49.5*5-205.5,133.2*4+53.34); 
   vertex(0-91.2,49.5*5,133.2*4+53.34);  
  endShape(CLOSE);
  
   beginShape();
    vertex(0, 49.5*5, 0-91.2);
    vertex(0,0-205.5, 0-91.2);
   vertex(0,49.5*5-205.5,133.2*4+53.34); 
   vertex(0,49.5*5,133.2*4+53.34);  
  endShape(CLOSE);
  
  // Back wall
  beginShape();
  vertex(0-91.2, 49.5*5, 0-91.2);
  vertex(0-91.2, 0-205.5, 0-91.2);
  vertex(0, 0-205.5, 0-91.2);
  vertex(0, 49.5*5, 0-91.2);
  vertex(0-91.2, 49.5*5, 0-91.2);
  endShape();

  // front wall
  beginShape();
    vertex(0-91.2, 49.5*5, 133.2*4+53.34);
    vertex(0-91.2, 49.5*5-205.5, 133.2*4+53.34);
    vertex(0, 49.5*5-205.5, 133.2*4+53.34);
    vertex(0, 49.5*5, 133.2*4+53.34);
    vertex(0-91.2, 49.5*5, 133.2*4+53.34);
  endShape();
  

  // top Wall
  beginShape();
    vertex(0-91.2, 0-205.5, 0-91.2);
    vertex(0, 0-205.5, 0-91.2);
    vertex(0, 49.5*5-205.5, 133.2*4+53.34);
    vertex(0-91.2, 49.5*5-205.5, 133.2*4+53.34);
  endShape();
  
   // RIGHT EDGE -----------------------------------------------------------------
   // left wall
   beginShape();
     vertex(1013,49.5*5, 0-91.2); 
     vertex(1013,0-205.5, 0-91.2);
     vertex(1013, 49.5*5-205.5,133.2*4+53.34);
     vertex(1013,49.5*5,133.2*4+53.34); 
     vertex(1013,49.5*5, 0-91.2); 
   endShape();
   
   // right wall
   beginShape();
     vertex(1013+171,49.5*5, 0-91.2); 
     vertex(1013+171,0-205.5, 0-91.2);
     vertex(1013+171, 49.5*5-205.5,133.2*4+53.34);
     vertex(1013+171,49.5*5,133.2*4+53.34); 
     vertex(1013+171,49.5*5, 0-91.2); 
   endShape();
   
   // back wall
   beginShape();
     vertex(1013,49.5*5, 0-91.2); 
     vertex(1013,0-205.5, 0-91.2);
     vertex(1013+171,0-205.5, 0-91.2);
     vertex(1013+171,49.5*5, 0-91.2);
   endShape(CLOSE);
   
   // FRONT WALL
   beginShape();
   vertex(1013,49.5*5,133.2*4+53.34); 
   vertex(1013, 49.5*5-205.5,133.2*4+53.34);
   vertex(1013+171, 49.5*5-205.5,133.2*4+53.34);
   vertex(1013+171,49.5*5,133.2*4+53.34); 
   endShape(CLOSE);
   
   // top wall
    beginShape();
      vertex(1013,0-205.5, 0-91.2);
      vertex(1013+171,0-205.5, 0-91.2);
      vertex(1013+171, 49.5*5-205.5,133.2*4+53.34);
      vertex(1013, 49.5*5-205.5,133.2*4+53.34);
      
    endShape(CLOSE);
}
