class MainMenu {
  PFont font;
  int selectedIndex;
  String[] options = new String[] { "Play", "Hi Scores", "Options", "Exit" };
  int fontSize;
  int titleFontSize;
  boolean selected;
  
  AudioPlayer moveSound, selectSound;
  
  // Title flash variables
  boolean titleFlash;
  
  // Variables used for flashing animation when item is selected
  int FLASH_INTERVAL = 10;
  boolean filled;
  int alpha;
  
  MainMenu(PFont font, int titleFontSize, int fontSize, AudioPlayer moveSound, AudioPlayer selectSound) {
    this.font = font;
    selectedIndex = 0;
    selected = false;
    alpha = 255;
    this.titleFontSize = titleFontSize;
    this.fontSize = fontSize;
    this.moveSound = moveSound;
    this.selectSound = selectSound;
  }
  
  // Called when arrow key up is pressed
  void arrowKeyUpEvent() {
    if (!selected) {
      selectedIndex--;
      if (selectedIndex < 0) selectedIndex = options.length - 1;
    
      moveSound.rewind();
      moveSound.play();
    }
  }
  
  // Called when arrow key down is pressed
  void arrowKeyDownEvent() {
    if (!selected) {
      selectedIndex++;
      if (selectedIndex >= options.length) selectedIndex = 0;
    
      moveSound.rewind();
      moveSound.play();
    }
  }
  
  // called when Enter is pressed
  void enterEvent() {
    if (!selected) {
      selected = true;
      filled = true;
      selectSound.rewind();
      selectSound.play();
    }
  }
  
  void display() {
    if (frameCount % FLASH_INTERVAL == 0) {
      titleFlash = !titleFlash; 
    }
    if (selected) {
      if (alpha <= 0) {
        execute(); 
      }
      
      if (frameCount % FLASH_INTERVAL == 0) {
         filled = !filled;
      }
      
      //display the score
      textAlign(CENTER, CENTER);
      fill(255, alpha);
      stroke(155, 155, 155);
      textFont(title_font);
      textSize(titleFontSize);
      text("TETRIS", width / 2, height / 4);
      noStroke();
      
      // Display the menu items
      for (int i = 0; i < options.length; i++) {
        textAlign(CENTER, CENTER);
        if (selectedIndex == i) {
          fill(filled ? 255 : 155);
        }
        else fill(155, alpha);
        stroke(155, 155, 155);
        textFont(title_font);
        textSize(fontSize);
        text(options[i], width / 2, (height / 3) + (30 * i));
        noStroke();
      }
      
      
      alpha -= 5;
    }
    else {
      //display the score
      textAlign(CENTER, CENTER);
      fill(titleFlash ? 255 : 155 );
      stroke(155, 155, 155);
      textFont(title_font);
      textSize(titleFontSize);
      text("TETRIS", width / 2, height / 4);
      noStroke();
      
      // Display the menu items
      for (int i = 0; i < options.length; i++) {
        textAlign(CENTER, CENTER);
        if (selectedIndex == i) fill(255); 
        else fill(155);
        stroke(155, 155, 155);
        textFont(title_font);
        textSize(fontSize);
        text(options[i], width / 2, (height / 3) + (30 * i));
        noStroke();
      }
    }
  }
  
  void execute() {
    switch (selectedIndex) {
      case 0: play(); break;
      case 1: hiScores(); break;
      case 2: options(); break;
      case 3: exit(); break;
    }
  }
  
  
  void play() {
    cs = current_screen.BOARD;
    theme.rewind();
    theme.loop();
    board = new Board();
  }
  
  void hiScores()  {
    
  }
  
  void options() {
    
  }
  void reset() {
    selected = false;
    filled = false;
    alpha = 255;
  }
}