
float rx, ry, rz;
float S = 0.00390625;
float _yaw,_pitch, _roll;
float q[4];
float  gx, gy, gz;
float fx,fz;

void output_angles()
{ 
 
  _yaw = TO_DEG(yaw);
  _pitch = TO_DEG(pitch);
  _roll = TO_DEG(roll);

  rx = accel[0] * S;
  ry = accel[1] * S;
  rz = accel[2] * S;
// Serial1.print(rz); Serial1.print(","); 
  // Serial.print(rz); Serial.print(","); 
   
  // Calculate Quaternion to remove gravity from z axis
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
  
  // Substract gravity from X axis
  fx = rx + gx;
  // If moving very slow ---> set to 0
  if ( fx <= 0.05 && fx >= -0.05 ) { fx = 0;}
  // Substract gravity from Z axis
  fz = rz - gz;
  // if fz is very small set it to 0
  if (fz <= 0.99 && fz >= -0.99){
    fz = 0;
  }
  
//  Serial.print("gravity: ");
//  Serial.println(gx);
//  Serial.print("acceleration: ");
//  Serial.println(rx);
//  Serial.print("final accel: ");
//  Serial.print(fx);
  
  
   Serial.print(fx); Serial.print(",");
  Serial.print(fz); Serial.print(",");
  Serial.print(_yaw); Serial.print(",");
  Serial.print(_pitch); Serial.print(",");
  Serial.print(_roll); Serial.println("");

  
  
  Serial1.print(fx); Serial1.print(",");
  Serial1.print(fz); Serial1.print(",");
  Serial1.print(_yaw); Serial1.print(",");
  Serial1.print(_pitch); Serial1.print(",");
  Serial1.print(_roll); Serial1.println("");
 
   
}





























