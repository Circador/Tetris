class Block{
  // magenta, red, yellow, green, cyan, blue, white, BLACK
  //// I piece, O piece, T piece, S piece, Z piece, J piece, L piece, no piece
  //color[] COLORS = new color[]{#93bcff, #ffda23, #9b27f9, #7dff59, #ff5151, #4f4fff, #ff8e2b, #000000};
  //color currentColor;
  PImage img;
  static final int SIZE = 30;
  boolean stopped;
  
  Block(PImage img){
    this.img = img;
    img.resize(SIZE, SIZE);
    stopped = false;
  }
  
  void display(int row, int col, int x_pad, int y_pad){
    stroke(0);
    image(img, col*SIZE + x_pad, row*SIZE + y_pad);
    noStroke();
  } 
  
  void stop(){
    stopped = true;
  }
  
  boolean stopped(){
    return stopped;
  }
}