/**
 * Tetromino Class: Represents a mobile tetromino
 *
 * KNOWN BUGS:
 *  * Occasionally, when moving left or right when the movement should be restricted by another block, 
 *    the tetromino will come out of shape, some blocks moving left while the others stay where they are supposed to be.
 *    - Likely cause: the move_* methods allow for some of the blocks of the tetromino to move before returning false when an obstacle is detected.
 *      This may be why some blocks will move if their path is unobstructed after the rest come into contact with an obstacle.
 *      Possible solution: Using a double-buffering system, waiting until all the blocks have been accounted for before moving, 
 *        and cancelling the motion entirely if an obstruction is detected.
 *  * When a tetromino is directly adjacent to an edge of the screen, and it is rotated, 
 *    there is a possibility that it will go off screen into the buffer zone.
 *  * The S piece sometimes does not fit properly into a space where it can fit
 *
 * POSSIBLE IMPROVEMENTS:
 *  * The rotate method likely can be shortened drastically by mapping points within the rotation space to points rotated clockwise.
 *    Each piece can then be transformed in the same way.
 */

// Tetromino types
// final int I = 0, O = 1, T = 2, S = 3, Z = 4, J = 5, L = 6;

class Tetromino {
  boolean[][] tetromino_I = new boolean[][]{{false, false, false, false}, 
                                            {true, true, true, true},
                                            {false, false, false, false},
                                            {false, false, false, false}};
  boolean[][] tetromino_O = new boolean[][]{{true, true},
                                            {true, true}};
  boolean[][] tetromino_T = new boolean[][]{{false, false, false},
                                            {true, true, true},
                                            {false, true, false}};
  boolean[][] tetromino_S = new boolean[][]{{false, true, true},
                                            {true, true, false},
                                            {false, false, false}};
  boolean[][] tetromino_Z = new boolean[][]{{true, true, false},
                                            {false, true, true},
                                            {false, false, false}};
  boolean[][] tetromino_J = new boolean[][]{{false, false, false},
                                            {true, true, true},
                                            {false, false, true}};
  boolean[][] tetromino_L = new boolean[][]{{false, false, false},
                                            {true, true, true},
                                            {true, false, false}};
  boolean[][][] tetromino = new boolean[][][]{tetromino_I, tetromino_O, tetromino_T,
                                            tetromino_S, tetromino_Z, tetromino_J, tetromino_L};
  int[][] two_shifts = new int[][]{{0, 0}, {0, 0}, 
                                   {0, 0}, {0, 0}};
  int[][] three_shifts = new int[][]{{2, 0}, {1, 1}, {0, 2}, 
                                     {1, -1}, {0, 0}, {-1, 1}, 
                                     {0, -2}, {-1, -1}, {-2, 0}};
  int[][] four_shifts = new int[][]{{3, 0}, {2, 1}, {1, 2}, {0, 3},
                                    {2, -1}, {1, 0}, {0, 1}, {-1, 2},
                                    {1, -2}, {0, -1}, {-1, 0}, {-2, 1},
                                    {0, -3}, {-1, -2}, {-2, -1}, {-3, 0}};
                                    
  int[][][] shifts = new int[][][]{two_shifts, three_shifts, four_shifts};
  int type;
  int position;
  int rotation_space_size;
  
  Block[][] blocks;
 
  // The y is assumed to be at the top of the screen
  Tetromino(int type) {
    this.type = type;
    if (type == I){
      rotation_space_size = 4;
      blocks = new Block[4][4];
    } else if (type == O){
      rotation_space_size = 2;
      blocks = new Block[2][2];
    } else{
      rotation_space_size = 3;
      blocks = new Block[3][3];
    }
    
    // initializes blocks to be used
    for(int i = 0; i < blocks.length; i++){
      for(int j = 0; j < blocks[i].length; j++){
        if(tetromino[type][i][j]){
          blocks[i][j] = new Block(type);
        }
      }
    }
  }
  
  // creates a clone of the current tetromino
  Tetromino(Tetromino current_tetromino){
    this.type = current_tetromino.type;
    this.rotation_space_size = current_tetromino.rotation_space_size;
    blocks = new Block[rotation_space_size][rotation_space_size];
    for(int i = 0; i < blocks.length; i++){
      for(int j = 0; j < blocks[i].length; j++){
        if(current_tetromino.blocks[i][j] != null){
          blocks[i][j] = new Block(type);
        }
      }
    }
  }
  
  // May not be needed
  void freeze() {
    for(int i = 0; i < blocks.length; i++){
      for(int j = 0; j < blocks[i].length; j++){
        if(blocks[i][j] != null){
          blocks[i][j].stop();
        }
      }
    }
  }
}