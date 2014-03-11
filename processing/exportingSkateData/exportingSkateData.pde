float[] yaw;
float[] pitch;
float[] roll;
float[] xAccel;
float[] yAccel;
float[] zAccel;

void setup() {
 String[] rawData = loadStrings("datastrings.csv");
 
 yaw = new float[rawData.length];
 pitch =new float[rawData.length];
 roll = new float[rawData.length];
 xAccel = new float[rawData.length];
 yAccel = new float[rawData.length];
 zAccel =new float[rawData.length];
 
 for(int i=0; i < rawData.length; i++) {
 String[] thisRow = split(rawData[i], ",");
 yaw[i]   = float(thisRow[0]);
 pitch[i] = float(thisRow[1]);
 roll[i]  = float(thisRow[2]);
 xAccel[i] = float(thisRow[3]);
 yAccel[i] = float(thisRow[4]);
 zAccel[i] = float(thisRow[4]);
 }
 
 
}

void draw() {
  
}
