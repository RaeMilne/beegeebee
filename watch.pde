class Watch {

  float ht;   // height
  float wd; //width
  float x, y; // location
  float rad; //radius of rounded corners
  float xspeed; // speed

    // Constructor
  Watch(float _wd, float _ht, float _rad, float _speed) {
    wd = _wd;
    ht = _ht;
    rad = _rad;
    x = width/2;
    y = height/2;
    xspeed = _speed;
    fill(255);
  }


  void vibrate() {
    x += xspeed; // Increment x
    if (x == (width/2 + xspeed) || x == (width/2 - xspeed)) {
      xspeed *= -1;
    }
  } 

  void displayBckGrnd() {
      shapeMode(CENTER);
    PShape s;
    s = loadShape("hand.svg");
    shape(s, width/2-150, height/2+30, 900, 900);
      fill(0);
      rect(width/2, height/2, wd - 50, ht+100, rad);
  }
  
  void reset() {
    x = width/2;
    y = height/2;
  }

  void displayFace(String _inputString, int _size) {
    rect(x, y, wd, ht, rad);
    shapeMode(CENTER);
    PShape s;
    s = loadShape(_inputString);
    shape(s, x, y, _size, _size);
  }

  void displayCover(int _size) {
    shapeMode(CENTER);
    PShape s;
    s = loadShape("cover.svg");
    shape(s, width/2, height/2, _size, _size);
    
  }
}

