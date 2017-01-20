//Class to contain all of the front end stuff
class Frontend {
  //This are the buttons for the options 
  Button[] frontEndButtons;
  //This the background image 
  PImage frontEndBackground;
  //The x val and image for the 'leylines' banner
  float bannerX;
  PImage leylines;

  //Constructor
  Frontend() {
    //Loads the images
    frontEndBackground = loadImage("Images/Backgrounds/febg.jpg");
    leylines = loadImage("Images/Buttons/Leylines.png");
    //And creates the buttons 
    frontEndButtons = new Button[3];
    frontEndButtons[0] = new Button(width/2, 240, "Images/Buttons/begingame.png", "start", 40);
    frontEndButtons[1] = new Button(width/2, 310, "Images/Buttons/Tutorial.png", "tut", 40);
    frontEndButtons[2] = new Button(width/2, 380, "Images/Buttons/settings.png", "settings", 40);
    //This is for making the Leylines image display nicely
    bannerX = width/2-(leylines.width/2);
  }
  
  //Displays the frontend
  void drawFrontEnd() {
    //First draw the background
    image(frontEndBackground, 0, 0);
    //Then the banner
    image(leylines, bannerX, 60);
    //And finally the clickable options buttons
    for (int i = 0; i < frontEndButtons.length; i++) {
      frontEndButtons[i].drawButton();
    }
  }

  //Handles click input
  void click() {
    //Loop through all of the buttons
    for (int i = 0; i < frontEndButtons.length; i++) {
      //store the location in vars for easy reading
      float minX = frontEndButtons[i].position.x-(frontEndButtons[i].imgWidth/2);
      float maxX = frontEndButtons[i].position.x+(frontEndButtons[i].imgWidth/2);
      float minY = frontEndButtons[i].position.y-(frontEndButtons[i].imgHeight/2);
      float maxY = frontEndButtons[i].position.y+(frontEndButtons[i].imgHeight/2);
      //Then see if the mouse in inside of these coords
      if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
        //If it is we see what button it is
        if (frontEndButtons[i].type == "start") {
          //And switch the current game state to the new state
          currentGameState = IN_GAME;
        } else if (frontEndButtons[i].type == "tut") {
          currentGameState = TUTORIAL;
        } else if (frontEndButtons[i].type == "settings") {
          currentGameState = SETTINGS;
        }
      }
    }
  }
}
