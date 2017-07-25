class PauseMenu {
  // Almost the same as the MainMenu class
  PFont font;
  int selectedIndex;
  String[] options = new String[] { "Resume", "Restart", "Hi Scores", "Options", "Quit" };
  int fontSize;
  int titleFontSize;
  boolean selected;
  
  AudioPlayer moveSound, selectSound;
  
  // Variables used for flashing animation when item is selected
  int FLASH_INTERVAL = 10;
  boolean filled;
  int alpha;
  
  PauseMenu(PFont font, int titleFontSize, int fontSize, AudioPlayer moveSound, AudioPlayer selectSound) {
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
    fill(0, 100);
    rect(0, 0, width, height);
    if (selected) {
      if (alpha <= 0) {
        execute(); 
      }
      
      if (frameCount % FLASH_INTERVAL == 0) {
         filled = !filled;
      }
      
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
      case 0: resume(); break;
      case 1:
      case 2: hiScores(); break;
      case 3: options(); break;
      case 4: quit(); break;
    }
  }
  
  
  void resume() {
    cs = current_screen.BOARD;
    board.gm = game_mode.NORMAL_MOVE;
    theme.loop();
  }
  
  void restart() {
    
  }
  
  void hiScores()  {
    
  }
  
  void options() {
    
  }
  
  void quit() {
    main_menu.reset();
    main_menu_theme.rewind();
    main_menu_theme.loop();
    cs = current_screen.MAIN_MENU;
  }
  
  void reset() {
    selected = false;
    filled = false;
    alpha = 255;
  }
}