class Board {
  Block[][] currentBoard;
  Tetromino active_tetromino; // There should only be one active (mobile) tetromino at any given moment
  Tetromino held_tetromino;
  Tetromino next_tetromino;
  boolean hold, justSwapped;
  game_mode gm;
  int score; 
  int level;
  int totalLinesCleared;
  int tetromino_x, tetromino_y;
  
  boolean paused;
  int padding = 2;
  
  Board() {
    currentBoard = new Block[padding + height/Block.SIZE + padding][padding + width/Block.SIZE/3 + padding];
    score = 0;
    gm = game_mode.NORMAL_MOVE;
    hold = false;
    justSwapped = false;
  }  
  
  // Returns whether rotation in CW direction succeeded or not
  void rotateCW() {    
    // check to make sure there is something to rotate
    if(active_tetromino != null){
      // create tetromino to be used for testing rotation space only
      Tetromino temp_tetromino = new Tetromino(active_tetromino);
      int size = active_tetromino.rotation_space_size;
      for(int row = 0; row < size; row++){
        for(int col = 0; col < size; col++){
          int rowShift = active_tetromino.shifts[size - 2][row * size + col][1]; // y shift
          int colShift = active_tetromino.shifts[size - 2][row * size + col][0]; // x shift
          temp_tetromino.blocks[row + rowShift][col + colShift] = active_tetromino.blocks[row][col]; // 3 -------------------------------------------------
        }
      }
      // now check whether the new temp_tetromino can actually fit
      if(collision(tetromino_x, tetromino_y, temp_tetromino)){
        return;
      }
      // rotate by simpling swapping places with the tetromino
      active_tetromino = temp_tetromino;
      move.rewind();
      move.play();
    }
  }
  
  // Attempts to move down, returns false if failed
  boolean move_down() {
    /*
     * Algorithm Notes:
     *   Iterate bottom-up to eliminate issues with swapping a block of the tetromino with another block of the same tetromino.
     *   Use attempt_swap to detect if move_down should fail
     *
     * TODO: Check if the block will be out of bounds when moved down (check if it is at the bottom).
     *       If so, abort
     */
    
    if(collision(tetromino_x, tetromino_y + 1, active_tetromino)){
      //println("broken");
      return false;
    }
    move_tetromino(0, 1);
    return true;
  }
  
  boolean move_left() {
    //if (frozen) return false;
    
    if(collision(tetromino_x-1, tetromino_y, active_tetromino)){
      return false;
    }
    move_tetromino(-1, 0);
    return true;
  }
  
  boolean move_right() {
    // if (frozen) return false;
    
    if(collision(tetromino_x+1, tetromino_y, active_tetromino)){
      return false;
    }
    
    move_tetromino(1, 0);
    return true;
  }
  
  // returns true if the given tetromino with top left corner swap space has no collision with a dead block at given x, y
  // returns false in all other instances
  boolean collision(int x, int y, Tetromino tetromino){
    if(x < 0 || x > currentBoard[0].length - 1 || y > currentBoard.length - 1){
      return true;
    }
    if(tetromino != null){
      for(int row = 0; row < tetromino.blocks.length; row++){
        for(int col = 0; col < tetromino.blocks[row].length; col++){
          // first check whether there is an active block in the current location
          if(tetromino.blocks[row][col] != null){
            // next check whether the coordinate of such a block would be out of the board
            if((col + x >= padding) &&
               (col + x < currentBoard[0].length - padding) &&
               (y + row < currentBoard.length - padding) &&
               (y + row >= padding)){
              // finally check whether there is dead block within
              if(currentBoard[row+y][col+x] != null && currentBoard[row+y][col+x].stopped){ // - 1
                //println("stopped");
                return true;
              }
            } else{ // if the coordinate of a block swapped is invalid, then return true
              println("invalid swap");
              return true;
            }
          }
        }
      }
    }
    return false;
  }
  
  void move_tetromino(int x_shift, int y_shift){
    tetromino_x += x_shift;
    tetromino_y += y_shift;
  }
  
  /**
     Checks for and removes lines, updating the score as necessary.
  */
  void checkLine(){
    int linesRemoved = 0;
    for(int row = 0; row < currentBoard.length; row++){
      boolean lineIntact = true;
      while(lineIntact){
        for(int col = padding; col < currentBoard[row].length - padding; col++){
          if(currentBoard[row][col] == null || currentBoard[row][col].stopped == false){
            // breaks out of looking through this row, because a block is missing => there cannot be a line
            lineIntact = false;
            break;
          }
        }
        // checks one line and continues checking until 
        // if code gets to this loop, then the line must be intact
        // shift each line down from the bottom to the top, if it is 
        // if it shifts it should keep shifting?
        if(lineIntact){
          //for(int rowShiftIndex = row; rowShiftIndex < currentBoard.length - padding - 1; rowShiftIndex++){
            // moves the above row to be in the position of the current row
          //  currentBoard[rowShiftIndex] = currentBoard[rowShiftIndex - 1];
          //}
          shiftAllRowsAbove(row);
          linesRemoved++;
        }
      }
    }
    addScore(linesRemoved);
  }
  
  
  // Shift all rows above `row` down by one, overwriting `row` itself in the process.
  void shiftAllRowsAbove(int row) {
    for (int i = row; i > 0; i--) {
       for (int j = 0; j < currentBoard[row].length; j++) {
          currentBoard[i][j] = currentBoard[i - 1][j];
       }
    }
  }
  
  /**
     Helper function that adds score to total based on lines removed.
  */
  void addScore(int linesRemoved){
    if (linesRemoved == 4){
      println(linesRemoved);
      score += 800;
      tetris.rewind();
      tetris.play();
    } else if(linesRemoved > 0) {
      println(linesRemoved);
      score = score + linesRemoved * 100;
      line_clear.rewind();
      line_clear.play();
    }
    
    // Add number of lines cleared to total
    totalLinesCleared += linesRemoved; //<>//
  }
  /**
     Helper function that returns the score.
  */
  int getScore(){
    return score;
  }
  
  void update_board() {
        
    // update level counter
    level = totalLinesCleared / 10;
    
    // Update theme playback rate
    theme_rate_control.value.setLastValue(1.f + level * 0.01f);
    
    if(gm == game_mode.START){
      next_tetromino = new Tetromino(int(random(0, 7)));
      gm = game_mode.NORMAL_MOVE;
    } else if(gm == game_mode.SKIP_DOWN){
      if(active_tetromino != null){
        while(move_down()){
          //println("going down!");
        }
        //move.rewind();
        //move.play();
        gm = game_mode.NORMAL_MOVE;
      }
    } else if(gm == game_mode.NORMAL_MOVE || gm == game_mode.MOVE_FASTER){
      
      int frame_interval = FRAME_INTERVAL - 2 * level;
      if (frameCount % (gm == game_mode.MOVE_FASTER ? frame_interval / 6 : frame_interval) == 0) {
        if (active_tetromino == null) {
          // Create new tetromino randomly
          active_tetromino = next_tetromino;
          next_tetromino = new Tetromino(int(random(0, 7)));
          
          // allow person to hold block again
          justSwapped = false;
          
          // initial position
          reset_indices();
          // if collision detected keep moving up, or game over 
          while(collision(tetromino_x, tetromino_y, active_tetromino)){
            tetromino_y--;
            if(tetromino_y < padding){
              gm = game_mode.GAME_OVER;
            }
          }
        } else if(move_down()){
          //move.rewind();
          //move.play();
          
        }
        else {
          // Freeze this tetromino and create a new one
          active_tetromino.freeze(); // If needed
          instant_place.rewind();
          instant_place.play();
          active_tetromino = null;
          checkLine();
        }
      }      
    } 
  }
  // reset indices back to the original starting location, so block spawns on top
  void reset_indices(){
    tetromino_x = 3 + padding;
    tetromino_y = 1 + padding;
  }
  
  // using the current tetromino_x, tetromino_y and active_tetromino's swap space, redraw the block
  void update_indices(){
    if(active_tetromino != null){
      // first remove all active blocks
      for(int row = 0; row < currentBoard.length; row++){
        for(int col = padding; col < currentBoard[row].length - padding; col++){
          if(currentBoard[row][col] != null && !currentBoard[row][col].stopped){
            currentBoard[row][col] = null;
          }
        }
      }
      // next redraw all active blocks
      for(int i = 0; i < active_tetromino.rotation_space_size; i++){
        for(int j = 0; j < active_tetromino.rotation_space_size; j++){
          if(active_tetromino.blocks[i][j] != null){
            currentBoard[i + tetromino_y][j + tetromino_x] = active_tetromino.blocks[i][j];
          }
        }
      }
    }
  }
  // draw the board 
  void display() {
    for(int i = padding; i < currentBoard.length - padding; i++) {
      for(int j = padding; j < currentBoard[i].length - padding; j++) {
        if (currentBoard[i][j] != null) {
          stroke(50);
          fill(currentBoard[i][j].currentColor);
          rect((j- padding) *Block.SIZE+ width/3, (i- padding)*Block.SIZE, SIZE, SIZE);
          
          // Draw the shadowing effect
          // Enter HSB color mode
          float hu, sa, br;
          hu = hue(currentBoard[i][j].currentColor);
          sa = saturation(currentBoard[i][j].currentColor);
          br = brightness(currentBoard[i][j].currentColor);
          colorMode(HSB, 255);
          
          int x = (j- padding) *Block.SIZE+ width/3;
          int y = (i- padding)*Block.SIZE;
          
          br -= 30;
          stroke(color(hu, sa, br));
          strokeWeight(3);
          line(x + 2, y + 2, x + Block.SIZE - 2, y + 2);
          line(x + 2, y + 2, x + 2, y + Block.SIZE - 2);
          
          // Return to colorMode RGB
          colorMode(RGB, 255);
          
          // Reset strokeWeight
          strokeWeight(1);
          noStroke();
          
          // End shadow effects
        } else{
          stroke(50);
          fill(70, 70, 70);
          rect((j-padding)*Block.SIZE + width/3, (i - padding) * Block.SIZE, Block.SIZE, Block.SIZE);
        }
      }
    }
    
    //display the score
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(155, 155, 155);
    textFont(title_font);
    text("TETRIS", 3*width/18, height/6);
    noStroke();
    
    textFont(score_font);
    textAlign(RIGHT, RIGHT);
    text("Score: " + score, 17 * width / 18, height/6);
    
    // Display level
    textFont(score_font);
    textAlign(RIGHT, RIGHT);
    text("Level: " + level, 17 * width / 18, height/6 + (height/6));
        
    //display next block
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(155, 155, 155);
    textFont(score_font);
    text("NEXT", 15*width/18, 3*height/6);
    if(next_tetromino != null){
      for(int i = 0; i < next_tetromino.rotation_space_size; i++){
        for(int j = 0; j < next_tetromino.rotation_space_size; j++){
          if(next_tetromino.blocks[i][j] != null){
            stroke(0);
            fill(next_tetromino.blocks[i][j].currentColor);
            rect(14*width/18 + j*Block.SIZE, 3*height/6 + i*Block.SIZE + Block.SIZE, Block.SIZE, Block.SIZE);
          }
        }
      }
    }
    
    // display the hold block
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(155, 155, 155);
    textFont(score_font);
    text("HOLD", 15*width/18, 14*height/18);
    if(held_tetromino != null){
      for(int i = 0; i < held_tetromino.rotation_space_size; i++){
        for(int j = 0; j < held_tetromino.rotation_space_size; j++){
          if(held_tetromino.blocks[i][j] != null){
            stroke(0);
            fill(held_tetromino.blocks[i][j].currentColor);
            rect(14*width/18 + j*Block.SIZE, 14*height/18 + i*Block.SIZE + Block.SIZE, Block.SIZE, Block.SIZE);
          }
        }
      }
    }
  }
}