class Watch {

  float ht;   // height
  float wd;
  float x, y; // location
  float rad;
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

  void reset() {
    x = width/2;
    y = height/2;
  }
  
  void vibrate() {
    x += xspeed; // Increment x
    if (x == (width/2 + xspeed) || x == (width/2 - xspeed)) {
      xspeed *= -1;
    }
  } 

  void display() {
    noStroke();
    rect(x, y, wd, ht, rad);
  }

void displayFace(String _inputString, int _size) {
  shapeMode(CENTER);
  PShape s;
  s = loadShape(_inputString);
  shape(s, x, y, _size, _size);
}

}
  

