class Block{
  // magenta, red, yellow, green, cyan, blue, white, BLACK
  // I piece, O piece, T piece, S piece, Z piece, J piece, L piece, no piece
  color[] COLORS = new color[]{#93bcff, #ffda23, #9b27f9, #7dff59, #ff5151, #282bd3, #ff8e2b, #000000};
  color currentColor;
  static final int SIZE = 30;
  boolean stopped;
  
  Block(int colorCode){
    currentColor = COLORS[colorCode];
    stopped = false;
  }
  
  void display(int row, int col, int padding){
    stroke(0);
    fill(currentColor);
    rect(row*SIZE, col*SIZE + padding, SIZE, SIZE);
    noStroke();
  } 
  
  void stop(){
    stopped = true;
  }
  
  boolean stopped(){
    return stopped;
  }
}