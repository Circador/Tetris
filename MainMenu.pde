class MainMenu {
  PFont font;
  int selectedIndex;
  String[] options = new String[] { "Play", "Hi Scores", "Options", "Exit" };
  int FLASH_INTERVAL = 10;
  int fontSize;
  int titleFontSize;
  boolean selected;
  int alpha;
  
  MainMenu(PFont font, int titleFontSize, int fontSize) {
    this.font = font;
    selectedIndex = 0;
    selected = false;
    alpha = 255;
    this.titleFontSize = titleFontSize;
    this.fontSize = fontSize;
  }
  
  // Called when arrow key up is pressed
  void arrowKeyUpEvent() {
    selectedIndex--;
    if (selectedIndex < 0) selectedIndex = options.length - 1;
  }
  
  // Called when arrow key down is pressed
  void arrowKeyDownEvent() {
    selectedIndex++;
    if (selectedIndex >= options.length) selectedIndex = 0;
  }
  
  // called when Enter is pressed
  void enterEvent() {
    selected = true;
  }
  
  void display() {
    if (selected) {
      if (alpha == 0) {
        execute(); 
      }
      
      //display the score
      textAlign(CENTER, CENTER);
      fill(255);
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
      
      
      alpha--;
    }
    else {
      //display the score
      textAlign(CENTER, CENTER);
      fill(255);
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
    
  }
  
  void hiScores()  {
    
  }
  
  void options() {
    
  }
}