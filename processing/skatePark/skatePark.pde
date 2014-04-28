import toxi.processing.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import peasy.*;
import processing.opengl.*;

PeasyCam cam;

void setup(){
   size(1344, 760, OPENGL);
   cam = new PeasyCam(this, 500);
}

void draw() {
  background(25);
  smooth();
  
  drawPark();
}

void drawPark(){
  stroke(220);
    fill(25);
  // small box
  pushMatrix();
    translate(-200/2,10/2,0);
    box(200,10,50);
  popMatrix();
  
  // big box
  pushMatrix();
    translate(-250/2+25,-25/2,-37.5);
    box(250,25, 25);
  popMatrix();
  
  
}

