Watch watch;
Timer timer;
import processing.serial.*;

Serial myPort;
float vals[] = new float[3];

String[] face =
{
  "face_default.svg", "face_error.svg", "face_hi.svg", "face_lo.svg", "face_ok.svg", "face_on.svg"
};

float onVal = 1;
float checkVal = 1;
float errorVal = 1;
float sensorVal = 1;

int x = 0;
int y = 0;
float wd = 200;
float ht = 150;
float rad = 6;
float spd = 3;
int faceSize = 375;

final int STATE_OFF = 0;
final int STATE_ON = 1;
final int STATE_BCGOK = 2;
final int STATE_BCGLO = 3;
final int STATE_BCGHI = 4;
final int STATE_ERROR = 5;
final int STATE_DEFAULT = 6;

int state = 0;

color[]palette = {
  #EA2B3B, #FFC50A, #91BD49, #00A8DE //red-0, yellow-1, green-2, blue-3
};


void setup() {  
  size(400, 400);  
  background(0);  
  watch = new Watch(wd, ht, rad, spd);
  rectMode(CENTER);

  int portId = 0;
  String portName = Serial.list()[portId];
  myPort = new Serial(this, portName, 9600);
  timer = new Timer(5000);
  timer.start();
}

void draw() { 

  switch(state) {
  case STATE_OFF:
    drawState_Off();
    break;
  case STATE_ON:
    drawState_On();
    break;
  case STATE_BCGOK:
    drawState_BCGOK();
    break;
  case STATE_BCGLO:
    drawState_BCGLO();
    break;
  case STATE_BCGHI:
    drawState_BCGHI();
    break;
  case STATE_ERROR:
    drawState_Error();
    break;
  case STATE_DEFAULT:
    drawState_Default();
    break;
  }
} 

void drawState_Off() {
  background(0);
  if (onVal == 0) {
    state = STATE_ON;
  }
}


void drawState_On() {
  background(0);
  fill(255);
  watch.display();
  watch.displayFace(face[5], faceSize);
  if (timer.isFinished()) {    
    state = STATE_DEFAULT;
  }
}

void drawState_Default() {

  background(0);
  fill(255);
  watch.display();
  watch.displayFace(face[0], faceSize);
  if (checkVal == 0) {
    state = STATE_BCGOK;
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BCGHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BCGLO;
  } 
  else if (errorVal == 0 ) {
    state = STATE_ERROR;
  };
}

void drawState_BCGOK() {

  if (checkVal == 0) {

    background(0);
    fill(palette[3]);
    watch.display();
    watch.displayFace(face[4], faceSize);
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BCGHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BCGLO;
  } 
  else if (errorVal == 0 ) {
    state = STATE_ERROR;
  } 
  else {
    state = STATE_DEFAULT;
  };
}

void drawState_BCGHI() {
  background(0);
  fill(palette[0]);
  watch.vibrate();
  watch.display();
  watch.displayFace(face[2], faceSize);

  if (sensorVal < 150 && sensorVal > 100 && errorVal != 0) {
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BCGLO;
  } 
  else if (errorVal == 0) {
    state = STATE_ERROR;
  }
}

void drawState_BCGLO() {
  background(0);
  fill(palette[1]);
  watch.vibrate();
  watch.display();
  watch.displayFace(face[3], faceSize);

  if (sensorVal < 150 && sensorVal > 100 && errorVal != 0) {
    state = STATE_DEFAULT;
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BCGHI;
  } 
  else if (errorVal == 0) {
    state = STATE_ERROR;
  } 
}

void drawState_Error() {
  background(0);
  fill(palette[2]);
  watch.vibrate();
  watch.display();
  watch.displayFace(face[1], faceSize);

  if (sensorVal < 150 && sensorVal > 100 && errorVal != 0) {
    state = STATE_BCGOK;
  } 
  else if (sensorVal > 150 && sensorVal < 195 && errorVal != 0) {
    state = STATE_BCGHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BCGLO;
  }
}



void serialEvent( Serial ard_port) {

  //read in values
  String ard_string = ard_port.readStringUntil( '\n' );

  if ( ard_string != null) {
    ard_string = trim(ard_string);
    println( ard_string );
    vals = float(split(ard_string, ','));

    if (vals.length == 4) {
      onVal = vals[0];
      checkVal = vals[1];
      errorVal = vals[2];
      sensorVal = vals[3];
      sensorVal = map(sensorVal, 0, 1023, 0, 200);
    }
  }
}

