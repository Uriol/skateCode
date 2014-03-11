
float rx, ry, rz;
float S = 0.00390625;
float q[4];
float  gx, gy, gz;
float _yaw,_pitch, _roll;

void output_angles()
{ 
 
  _yaw = TO_DEG(yaw);
  _pitch = TO_DEG(pitch);
  _roll = TO_DEG(roll);

  Serial1.print(_yaw); Serial1.print(",");
  Serial1.print(_pitch); Serial1.print(",");
  Serial1.print(_roll); Serial1.println("");
  //Serial1.println();
   
 
 

  rx = accel[0] * S;
  ry = accel[1] * S;
  rz = accel[2] * S;
  
  // If moving very slow ---> set to 0
  if ( rx <= 0.05 && rx >= -0.05 ) { rx = 0;}
 
  
  
  
 // Serial1.print(rx); Serial1.print(",");
//  Serial1.print(ry); Serial1.print(",");
//  Serial1.print(rz);
//  Serial1.println();
  
  
  // Get quaternions data
  float c1 = cos(yaw/2);
  float c2 = cos(pitch/2);
  float c3 = cos(roll/2);
  float s1 = sin(yaw/2);
  float s2 = sin(pitch/2);
  float s3 = sin(roll/2);
  q[0] = c1*c2*c3 - s1*s2*s3; // w
  q[1] = c1*s2*c3 - s1*c2*s3; // z
  q[2] = s1*s2*c3 + c1*c2*s3; // x
  q[3] = s1*c2*c3 + c1*s2*s3; // y
  // Get Gravity 
  gy = 2 * (q[1] * q[3] - q[0] * q[2]);
  gx = 2 * (q[0] * q[1] + q[2] * q[3]);
  gz = q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3];
//  Serial1.print("#GRAVITY-");  
//  Serial1.print('=');
//  Serial1.print(gx); 
//  Serial1.print(",");
//  Serial1.print(gy); 
//  Serial1.print(",");
//  Serial1.print(gz); 
//  Serial1.println();
  
  


  
  

  
}





























