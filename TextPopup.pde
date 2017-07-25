
class TextPopup {
  String text;
  int fontSize;
  
  // Used for flashing effect
  int alpha;
  boolean flash;
  int FLASH_INTERVAL = 10;
  int verticalOffset = 0;
  
  
  TextPopup(String text, int fontSize) {
    this.text = text;
    this.fontSize = fontSize;
    alpha = 255;
  }
  
  
  
  void display() {
    if (frameCount % FLASH_INTERVAL == 0) {
      flash = !flash; 
    }
    
    alpha--;
    verticalOffset++;
    
    textAlign(CENTER, CENTER);
    fill(flash ? 255 : 0, alpha);
    strokeWeight(10);
    stroke(flash ? 0 : 255, alpha);
    textFont(title_font);
    textSize(fontSize);
    text(text, width / 2, (height / 2) - verticalOffset);
    strokeWeight(1);
    noStroke();
  }
}