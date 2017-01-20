//This class controls the game over screen
class Gameover {
  //Has an image background
  PImage gameBackground;
  //And some buttons
  Button[] gameOverButtons;

  Gameover() {
    //Here we load the data
    gameBackground = loadImage("Images/Backgrounds/ingamebackground.jpg");
    gameOverButtons = new Button[2];
    gameOverButtons[0] = new Button(190, 325, "Images/Buttons/rematch.png", "rematch", 50);
    gameOverButtons[1] = new Button(190, 400, "Images/Buttons/mainmenu.png", "mainmenu", 50);
  }
  //This draws the game over screen
  void drawGameOver() {
    //First we draw the background
    image(gameBackground, 0, 0);
    //Then we draw the board by looping through each position and drawing it
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        gameboard[i][j].drawObj(380+ (i*81), 50+(j*81));
      }
    }
    
    textSize(60);
    //We work out who won
    if (humanPlayer.score > aiPlayer.score) {
      //And print the correct infomation
      text("YOU WON!", 60, 100);
    } else {
      text("YOU LOST!", 60, 100);
    }
    textSize(40);
    //Then we display the scores
    text("your score: " + humanPlayer.score, 60, 200);
    text("their score: " + aiPlayer.score, 60, 250);
    //And the buttons (for rematch/main menu)
    for (int i=0; i < gameOverButtons.length; i++) {
      gameOverButtons[i].drawButton();
    }
  }
  //This is click handler for this screen
  void click() {
    //Loop through all the buttons
    for (int i = 0; i < gameOverButtons.length; i++) {
      float minX = gameOverButtons[i].position.x-(gameOverButtons[i].imgWidth/2);
      float maxX = gameOverButtons[i].position.x+(gameOverButtons[i].imgWidth/2);
      float minY = gameOverButtons[i].position.y-(gameOverButtons[i].imgHeight/2);
      float maxY = gameOverButtons[i].position.y+(gameOverButtons[i].imgHeight/2);
      //See if we have a hit
      if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
        //if we do check to see what type
        if (gameOverButtons[i].type == "rematch") {
          //if it is a rematch then set up a new game and go to the in game state
          setUpGame();
          currentGameState = IN_GAME;
        } else if (gameOverButtons[i].type == "mainmenu") {
          //Otherwise set up (ready to play again) but go to the frontend
          setUpGame();
          currentGameState = FRONT_END;
        }
      }
    }
  }
}

