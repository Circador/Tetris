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
//aesthetics
Board board;
MainMenu main_menu;
PauseMenu pause_menu;
ArrayList<TextPopup> popups;
PImage[] block_images;

//fonts
PFont title_font;
PFont score_font;
PFont detail_font;

Minim minim;
// Theme music
FilePlayer theme;
TickRate theme_rate_control;
AudioOutput out;
AudioPlayer main_menu_theme;
// clearing sounds
AudioPlayer tetris;
AudioPlayer line_clear;
// movement sounds
AudioPlayer move;
AudioPlayer instant_place;

// Main menu sounds
AudioPlayer select;

  
current_screen cs;

boolean paused = false;

void setup() {
  size(900, 720);
  frameRate(60);
  colorMode(RGB, 255);
    
  cs = current_screen.MAIN_MENU;
  
  minim = new Minim(this);
  theme = new FilePlayer(minim.loadFileStream("theme.wav"));
  out = minim.getLineOut();
  theme_rate_control = new TickRate(1.f);
  theme.patch(theme_rate_control).patch(out);
  // clearing sounds
  tetris = minim.loadFile("tetris.wav");
  line_clear = minim.loadFile("lineclear.wav");
  // movement sounds
  move = minim.loadFile("move.wav");
  instant_place = minim.loadFile("instantplace.wav");
  main_menu_theme = minim.loadFile("mainmenu.wav");
  // Main menu sounds
  select = minim.loadFile("freeze.wav");
  title_font = createFont("arcade_font.ttf", 36);
  score_font = createFont("arcade_font.ttf", 24);
  detail_font = createFont("arcade_font.ttf", 16);
  
  main_menu = new MainMenu(title_font, 30, 20, move, select);
  pause_menu = new PauseMenu(title_font, 30, 20, move, select);
  main_menu_theme.loop();
  popups = new ArrayList<TextPopup>();
  

  // load data into board
  String[] stats = loadStrings("scores.txt");
  board = new Board(stats);
  block_images = new PImage[]{loadImage("I_block.png"), loadImage("O_block.png"), loadImage("T_block.png"), 
  loadImage("S_block.png"), loadImage("Z_block.png"), loadImage("J_block.png"), loadImage("L_block.png"), loadImage("no_block.png")};
}

void draw() {
  background(0);
  if (cs == current_screen.MAIN_MENU) {
    main_menu.display();
  }
  else if (cs == current_screen.PAUSE_MENU) {
    board.display();
    pause_menu.display();
    // Still display the board, but faded in the background
  }
  else if (cs == current_screen.BOARD && !paused) {
    board.update_board();
    board.update_indices();
    board.display();
    for (int i = 0; i < popups.size(); i++) { 
      popups.get(i).display();
      if (popups.get(i).alpha <= 0) {
        popups.remove(popups.get(i));
        i--;
      }
    }
  }
}

void keyPressed() {
  switch (cs) {
    
  case MAIN_MENU:
    if (keyCode == UP) main_menu.arrowKeyUpEvent();
    if (keyCode == DOWN) main_menu.arrowKeyDownEvent();
    if (keyCode == ENTER) { main_menu_theme.pause(); main_menu.enterEvent(); }
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
      cs = current_screen.PAUSE_MENU;
      board.gm = game_mode.GAME_OVER;
      pause_menu.reset();
      theme.pause(); 
      main_menu_theme.rewind(); 
      main_menu_theme.loop();
    }
    if (keyCode == ' '){
      board.gm = game_mode.SKIP_DOWN;
    }
    break;
  case PAUSE_MENU:
    if (keyCode == UP) pause_menu.arrowKeyUpEvent();
    if (keyCode == DOWN) pause_menu.arrowKeyDownEvent();
    if (keyCode == ENTER) { 
      main_menu_theme.pause();
      pause_menu.enterEvent(); 
    }
    break;
  }
}

void keyReleased() {
  if (cs == current_screen.BOARD) {
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
}

void stop() {
  minim.stop();
}