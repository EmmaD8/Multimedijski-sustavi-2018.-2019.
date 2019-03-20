class ScrollRect {
 
  float rectPosX=0;
  float rectPosY=0;
  float rectWidth=14; 
  float rectHeight=30;
 
  boolean holdScrollRect = false; 
 
  float offsetMouseY; 
 
  //constr
  ScrollRect() {
    // you have to make a scrollRect in setup after size()
    rectPosX = width - rectWidth - 1;
    
  }//constr
 
  void display() {
    
    
    stroke(0);
    fill(255);
    rect(rectPosX - 1, 0, rectWidth + 1, height);
    
    //line (rectPosX-1, 0, 
    //  rectPosX-1, height);
      
    fill(122);
    rect(rectPosX, rectPosY, 
      rectWidth, rectHeight);
 
    // Three small lines in the center   
    centerLine(-3); 
    centerLine(0);
    centerLine(3);
  }
 
  void centerLine(float offset) {
    line(rectPosX+3, rectPosY+rectHeight/2+offset, 
      rectPosX+rectWidth-3, rectPosY+rectHeight/2+offset);
  }
 
  void mousePressedRect() {
    if (mouseOver()) {
      holdScrollRect = true;
      offsetMouseY = mouseY - rectPosY;
      redraw();
    }
  }
 
  void mouseReleasedRect() {
       holdScrollRect = false;
  }
 
  void update() {
    // dragging of the mouse 
    if (holdScrollRect) {
      rectPosY=mouseY-offsetMouseY;
      if (rectPosY<0)
        rectPosY=0;
      if (rectPosY+rectHeight>height-1)
        rectPosY=height-rectHeight-1;
    }
  }
 
  float scrollValue() {
    return
      map(rectPosY, 
      0, height-rectHeight, 
      0, - (heightOfCanvas - height));
  }
 
  boolean mouseOver() {
    return mouseX>rectPosX&&
      mouseX<rectPosX+rectWidth&&
      mouseY>rectPosY&&
      mouseY<rectPosY+rectHeight;
  } 
 
} 
