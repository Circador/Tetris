import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// CONSTANTS
final int SIZE = 30;
final int FRAME_INTERVAL = 30;

// Tetromino types
// These can be passed directly into the Block constructor for the colorCode
final int I = 0, 
          O = 1, 
          T = 2, 
          S = 3, 
          Z = 4, 
          J = 5, 
          L = 6,
          DEBUG = 7;

enum game_mode{
  START, 
  MOVE_FASTER,
  SKIP_DOWN,
  NORMAL_MOVE,
  GAME_OVER;
}

enum current_screen { 
  MAIN_MENU,
  BOARD,
  PAUSE_MENU;
}

Board board;
MainMenu main_menu;

PFont title_font;
PFont score_font;
Minim minim;
//AudioPlayer theme;
FilePlayer theme;
TickRate theme_rate_control;
AudioOutput out;
// clearing sounds
AudioPlayer tetris;
AudioPlayer line_clear;
// movement sounds
AudioPlayer move;
AudioPlayer instant_place;
  
current_screen cs;

boolean paused = false;

void setup() {
  size(900, 720);
  frameRate(60);
  
  cs = current_screen.MAIN_MENU;
  
  minim = new Minim(this);
  theme = new FilePlayer(minim.loadFileStream("theme.wav"));
  out = minim.getLineOut();
  theme_rate_control = new TickRate(1.f);
  theme.patch(theme_rate_control).patch(out);
  theme.loop();
  // clearing sounds
  tetris = minim.loadFile("tetris.wav");
  line_clear = minim.loadFile("lineclear.wav");
  // movement sounds
  move = minim.loadFile("move.wav");
  instant_place = minim.loadFile("instantplace.wav");
  
  title_font = createFont("arcade_font.ttf", 36);
  score_font = createFont("arcade_font.ttf", 24);
  board = new Board();
  main_menu = new MainMenu(title_font, 30, 20);
  
  colorMode(RGB, 255);
}

void draw() {
  background(0);
  if (cs == current_screen.MAIN_MENU) {
    main_menu.display();
  }
  else if (cs == current_screen.BOARD && !paused) {
    board.update_board();
    board.update_indices();
    board.display();
  }
}

void keyPressed() {
  switch (cs) {
    
  case MAIN_MENU:
    if (keyCode == UP) main_menu.arrowKeyUpEvent();
    if (keyCode == DOWN) main_menu.arrowKeyDownEvent();
    if (keyCode == ENTER) main_menu.enterEvent();
    break;
    
  case BOARD:
    if (keyCode == UP) {
      if (board.active_tetromino != null) {
        board.rotateCW();
      }
    }
    if (keyCode == DOWN) {
      board.gm = game_mode.MOVE_FASTER;
    }
    if (keyCode == LEFT) {
      if (board.active_tetromino != null) {
        board.move_left();
      }
    }
    if (keyCode == RIGHT) {
      if (board.active_tetromino != null) {
        board.move_right();
      }
    }
    if (key == 'p')  {
      board.gm = game_mode.GAME_OVER;
    }
    if (keyCode == ' '){
      board.gm = game_mode.SKIP_DOWN;
    }
    break;
  case PAUSE_MENU:
    break;
  }
}

void keyReleased() {
  if (keyCode == DOWN) {
    board.gm = game_mode.NORMAL_MOVE;
  }
  if (keyCode == CONTROL){
    if(!board.hold && board.active_tetromino != null){
      board.held_tetromino = board.active_tetromino;
      board.active_tetromino = null;
      board.hold = true;
      board.justSwapped = true;
      board.reset_indices();
    } else if(board.hold && !board.justSwapped){
      Tetromino temp = board.held_tetromino;
      board.held_tetromino = board.active_tetromino;
      board.active_tetromino = temp;
      board.justSwapped = true;
      board.reset_indices();
    }
  }
}

void stop() {
  minim.stop();
}