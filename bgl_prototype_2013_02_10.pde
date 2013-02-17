Watch watch; //declare watch object
Timer timer; //declare timer object
import processing.serial.*; //import serial library

Serial myPort; //declare serial object
float vals[] = new float[3]; //array to hold serial values

String[] face =
{
  "face_default.svg", "face_error.svg", "face_hi.svg", "face_lo.svg", "face_ok.svg", "face_on.svg"
}; //face expression files

float onVal = 1; //declare button value for "on" button
float checkVal = 1; //declare button value for "check status" button
float errorVal = 1; //declare button value for "error" button
float sensorVal = 0; //declare initial sensor value for potentiometer values (simulate BGL)

int x = 0; //declare x-value for watch
int y = 0; //declare y-value for watch
float wd = 200; //declare width of rectangle
float ht = 150; //declare height of rectangle
float rad = 6; //declare radius of rounded corners
float spd = 3; //declare speed of vibration
int faceSize = 350; //declare size of face expression

final int STATE_OFF = 0;
final int STATE_ON = 1;
final int STATE_BGLOK = 2;
final int STATE_BGLLO = 3;
final int STATE_BGLHI = 4;
final int STATE_ERROR = 5;
final int STATE_DEFAULT = 6;

int state = 0;

//array to hold color values
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
  myPort = new Serial(this, portName, 9600); //create serial object
  timer = new Timer(7000); //create timer object, declare length of time
  timer.start(); //start timer
}

void draw() { 

  switch(state) {
  case STATE_OFF:
    drawState_Off();
    break;
  case STATE_ON:
    drawState_On();
    break;
  case STATE_BGLOK:
    drawState_BGLOK();
    break;
  case STATE_BGLLO:
    drawState_BGLLO();
    break;
  case STATE_BGLHI:
    drawState_BGLHI();
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
  background(0); //re-initialize
  fill(palette[3]); //color of watch background
  watch.display(); //draw the watch background
  watch.displayFace(face[5], faceSize); //draw the watch expression
  if (timer.isFinished()) {    
    state = STATE_DEFAULT;
  }
}

void drawState_Default() {

  background(0);
  fill(palette[3]);
  watch.display();
  watch.displayFace(face[0], faceSize);
  if (checkVal == 0) {
    state = STATE_BGLOK;
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BGLHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BGLLO;
  } 
  else if (errorVal == 0 ) {
    state = STATE_ERROR;
  };
}

void drawState_BGLOK() {

  if (checkVal == 0) {
    background(0);
    fill(palette[3]);
    watch.display();
    watch.displayFace(face[4], faceSize);
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BGLHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BGLLO;
  } 
  else if (errorVal == 0 ) {
    state = STATE_ERROR;
  } 
  else {
    state = STATE_DEFAULT;
  };
}

void drawState_BGLHI() {
  
  background(0);
  fill(palette[0]);
  watch.vibrate();
  watch.display();
  watch.displayFace(face[2], faceSize);

  if (sensorVal < 150 && sensorVal > 100 && errorVal != 0) {
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BGLLO;
  } 
  else if (errorVal == 0) {
    state = STATE_ERROR;
  }
}

void drawState_BGLLO() {
  
  background(0);
  fill(palette[1]);
  watch.vibrate(); //vibrate the watch
  watch.display();
  watch.displayFace(face[3], faceSize);

  if (sensorVal < 150 && sensorVal > 100 && errorVal != 0) {
    state = STATE_DEFAULT;
  } 
  else if (sensorVal > 150 && errorVal != 0) {
    state = STATE_BGLHI;
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
    state = STATE_BGLOK;
  } 
  else if (sensorVal > 150 && sensorVal < 195 && errorVal != 0) {
    state = STATE_BGLHI;
  } 
  else if (sensorVal < 100 && errorVal != 0) {
    state = STATE_BGLLO;
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


