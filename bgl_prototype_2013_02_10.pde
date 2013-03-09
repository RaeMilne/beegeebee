/*

beegeebee watch prototype
rae milne and katie mcelroy
25 february 2013

smart objects with carla diana
sva ixd | pod

*/

import processing.serial.*; //import serial library
import ddf.minim.*;

Minim minim;
AudioPlayer onSound, happySound, highSound, lowSound, errorSound;

Watch watch; //declare watch object
Timer timer; //declare timer object

Serial myPort; //declare serial object
float vals[] = new float[2]; //array to hold serial values

String[] face =
{
  "face_default.svg", "face_error.svg", "face_hi.svg", "face_lo.svg", "face_ok.svg", "face_on.svg"
}; //face expression files

float btnVal = 1; //declare button value for "on" button
float sensorVal = 0; //declare initial sensor value for potentiometer values (simulate BGL)

int x = 0; //declare x-value for watch
int y = 0; //declare y-value for watch
float wd = 200; //declare width of rectangle
float ht = 150; //declare height of rectangle
float rad = 6; //declare radius of rounded corners
float spd = 6; //declare speed of vibration
int faceSize = 355; //declare size of face expression
int coverSize = 320; //declare faceplate size

//declare states
final int STATE_OFF = 0;
final int STATE_ON = 1;
final int STATE_BGLOK = 2;
final int STATE_BGLLO = 3;
final int STATE_BGLHI = 4;
final int STATE_ERROR = 5;
final int STATE_DEFAULT = 6;
final int STATE_A = 7;
final int STATE_B = 8;
final int STATE_C = 9;
final int STATE_D = 10;
final int STATE_Good = 11;

//declare BGL ranges
int lowMax = 60;
int aMin = 61;
int aMax = 80;
int bMin = 80;
int bMax = 100;
int goodMin = 100;
int goodMax = 150;
int cMin = 150;
int cMax = 170;
int dMin = 170;
int dMax = 190;
int highMin = 191;
int highMax = 205;
int errorMin = 206;

long timeLapse = 3000;
long savedTime;

int state = 0; 
int prevState = 0;

//array to hold color values
color[]palette = {
  #00B9C4, #11B8A5, #35B887, #49B869, #88DB5D, #C1C54D, #F3CC39, #EE4552, #BBC0CB, 192 
    //low-0, a-1, b-2, good-3, c-4, d-5, high-6, error-7, default-8, background-9
};

color prevColor = palette[8];

void setup() {  
  size(1280, 800);  
  background(palette[9]);  
  watch = new Watch(wd, ht, rad, spd);
  rectMode(CENTER);
  noStroke();

  minim = new Minim(this);
  
  //load sound files
  onSound = minim.loadFile("on_magic-chime-01.mp3");
  highSound = minim.loadFile("beepbeep.wav");
  happySound = minim.loadFile("beep-24.mp3");
  lowSound = minim.loadFile("beepbeep.wav");
  errorSound = minim.loadFile("high_button-8.mp3");

  int portId = 0;
  println(Serial.list());
  String portName = Serial.list()[portId]; 
  myPort = new Serial(this, portName, 9600); //create serial object
  timer = new Timer(5000); //create timer object, declare length of time
  timer.start(); //start timer

  textMode(CENTER);
  PFont font;
  font = loadFont("MuseoSans-300-48.vlw");
  textAlign(CENTER, CENTER);
  textFont(font, 48);
}

void draw() { 

  background(palette[9]);
  watch.displayBckGrnd();

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
  case STATE_A:
    drawState_A();
    break;
  case STATE_B:
    drawState_B();
    break;
  case STATE_C:
    drawState_C();
    break;
  case STATE_D:
    drawState_D();
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

  watch.displayCover(coverSize);
} 

void drawState_Off() {

  rect(width/2, height/2, wd, ht, rad);
  if (btnVal == 0) {
    savedTime = millis();
    state = STATE_ON;
  }
}

void drawState_On() {
  onSound.play();
  fill(255); //color of watch background
  watch.displayFace(face[5], faceSize); //draw the watch expression
  if (millis() - savedTime > timeLapse) {    
    state = STATE_DEFAULT;
  }
}

void drawState_Default() { 

  fill(prevColor);
  rect(width/2, height/2, wd, ht, rad);

  displayReading();

  if (millis() - savedTime > timeLapse) {
    fill(prevColor);
    rect(width/2, height/2, wd, ht, rad);
    displayTime();
  }

  if (btnVal == 0) {
    fill(prevColor);
    rect(width/2, height/2, wd, ht, rad);
    displayReading();
  } 
  if (sensorVal > goodMin && sensorVal < goodMax && prevState != STATE_BGLOK) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_BGLOK;
  } 
  else if (sensorVal > aMin && sensorVal <= aMax && prevState != STATE_A) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_A;
  } 
  else if (sensorVal > bMin && sensorVal <= bMax && prevState != STATE_B) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_B;
  } 
  else if (sensorVal > cMin && sensorVal <= cMax && prevState != STATE_C) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_C;
  } 
  else if (sensorVal > dMin && sensorVal <= dMax && prevState != STATE_D) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_D;
  } 
  else if (sensorVal > highMin && sensorVal <= highMax && prevState != STATE_BGLHI) {
    if (!highSound.isPlaying()) {
      highSound.pause();
      highSound.rewind();
    }
    state = STATE_BGLHI;
  } 
  else if (sensorVal < lowMax && prevState != STATE_BGLLO) {
    if (!lowSound.isPlaying()) {
      lowSound.pause();
      lowSound.rewind();
    }
    state = STATE_BGLLO;
  } 
  else if (sensorVal > errorMin) {
    if (!errorSound.isPlaying()) {
      errorSound.pause();
      errorSound.rewind();
    }

    state = STATE_ERROR;
  }
}


void drawState_BGLOK() {

  happySound.play();
  fill(palette[3]);

  watch.reset();
  watch.displayFace(face[4], faceSize);

  if (btnVal == 0) { 
    savedTime = millis();
    prevState = STATE_BGLOK;
    prevColor = palette[3];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < bMax && sensorVal > bMin) {
    state = STATE_B;
  } 
  else if (sensorVal < cMax && sensorVal > cMin) {
    state = STATE_C;
  }
}

void drawState_A() {

  happySound.play();
  fill(palette[1]);
  watch.reset();
  watch.displayFace(face[4], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_A;
    prevColor = palette[1];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < bMax && sensorVal > bMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_B;
  } 
  else if (sensorVal < lowMax) {
    if (!lowSound.isPlaying()) {
      lowSound.pause();
      lowSound.rewind();
    }
    state = STATE_BGLLO;
  }
}


void drawState_B() {

  happySound.play();
  fill(palette[2]);
  watch.reset();
  watch.displayFace(face[4], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_B;
    prevColor = palette[2];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < goodMax && sensorVal > goodMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_BGLOK;
  } 
  else if (sensorVal < aMax && sensorVal > aMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_A;
  }
}


void drawState_C() {

  happySound.play();
  fill(palette[4]);
  watch.reset();
  watch.displayFace(face[4], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_C;
    prevColor = palette[4];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < goodMax && sensorVal > goodMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_BGLOK;
  } 
  else if (sensorVal < dMax && sensorVal > dMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_D;
  }
}


void drawState_D() {

  happySound.play();
  fill(palette[5]);
  watch.reset();
  watch.displayFace(face[4], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_D;
    prevColor = palette[5];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < cMax && sensorVal > cMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_C;
  } 
  else if (sensorVal > highMin && sensorVal < highMax) {
    if (!highSound.isPlaying()) {
      highSound.pause();
      highSound.rewind();
    }
    state = STATE_BGLHI;
  }
}


void drawState_BGLHI() {

  highSound.play();
  fill(palette[6]);
  watch.vibrate();
  watch.displayFace(face[2], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_BGLHI;
    prevColor = palette[6];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal < highMin) {
    state = STATE_D;
  } 
  else if (sensorVal > errorMin) {

    if (!errorSound.isPlaying()) {
      errorSound.pause();
      errorSound.rewind();
    }
    state = STATE_ERROR;
  }
}

void drawState_BGLLO() {

  lowSound.play();
  watch.vibrate(); //vibrate the watch
  fill(palette[0]);
  watch.displayFace(face[3], faceSize);

  if (btnVal == 0) {
    savedTime = millis();
    prevState = STATE_BGLLO;
    prevColor = palette[0];
    state = STATE_DEFAULT;
  } 
  else if (sensorVal > aMin) {
    if (!happySound.isPlaying()) {
      happySound.pause();
      happySound.rewind();
    }
    state = STATE_A;
  }
}

void drawState_Error() {
  errorSound.play();
  watch.vibrate();
  fill(palette[7]);
  watch.displayFace(face[1], faceSize);

  if (sensorVal < errorMin) {
    state = STATE_BGLHI;
  }
}

void displayReading() {
  fill(0);
  textSize(48);
  text(int(sensorVal), width/2, height/2-20);
  textSize(18);
  text("mg/dL", width/2, height/2+20);
}

void displayTime() {

  fill(0);
  textSize(46);
  if (hour() < 13) {
    if (minute() < 10) {
      text(hour() + ":" + "0" + minute() + "am", width/2, height/2);
    } 
    else {
      text(hour() + ":" + minute() + "am", width/2, height/2);
    }
  } 
  else if (hour() >= 13) {
    int afternoonHour = hour() - 12;
    if (minute() < 10) {
      text(afternoonHour + ":" + "0" + minute() + "pm", width/2, height/2);
    } 
    else {
      text(afternoonHour + ":" + minute() + "pm", width/2, height/2);
    }
  }
}

void serialEvent( Serial ard_port) {

  //read in values
  String ard_string = ard_port.readStringUntil( '\n' );

  if ( ard_string != null) {
    ard_string = trim(ard_string);
    println( ard_string );
    vals = float(split(ard_string, ','));

    if (vals.length == 2) {
      btnVal = vals[0];
      //      checkVal = vals[1];
      //      errorVal = vals[2];
      sensorVal = vals[1];
      sensorVal = map(sensorVal, 0, 1023, 207, 50);
    }
  }
}


void stop()
{
  // always close Minim audio classes when you are done with them
  onSound.close();
  happySound.close();
  highSound.close();
  lowSound.close();
  errorSound.close();
  minim.stop();

  super.stop();
}

