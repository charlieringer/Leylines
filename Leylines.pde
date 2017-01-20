//We are using the minim library
import ddf.minim.*;

void setup() {
  size(800, 600);
  //Set up is mostly done as functions so we can call them again to play again
  loadData();
  //Sets up the in game stuff, in a seperate function so we can call it to reset the game
  setUpGame();
}

void draw() {
  //Plays the background music
  playBGMusic();
  
  //This takes the current game state int and checks to see what part of the game we are in
  switch (currentGameState) {
  case FRONT_END:
    //We are in the front end so draw that and break
    frontend.drawFrontEnd();
    break;
  case IN_GAME:
    //We are playing a game so run that code and break
    game.runGameCode();
    break;
  case SETTINGS:
    //We are in the settings menu so draw that then break
    settings.drawSettings();
    break;
  case GAME_OVER_SCREEN:
    //We have finished a game so draw the game over screen and break
    gameover.drawGameOver();
    break;
  case TUTORIAL:
    //Draw the tutorial and break
    tutorial.drawtut();
    break;
  }
}


void mousePressed() {
  //We have clicked the mouse so play the mouse clicked sound
  playClick();
  
  //Simular to in the draw function
  switch(currentGameState) {
   //each class has it's own click handler method, depending on where we are we run that function
  case FRONT_END:
    frontend.click();
    break;
  case IN_GAME:
    game.inGameClickLogic();
    break;
  case SETTINGS:
    settings.click();
    break;
  case GAME_OVER_SCREEN:
    gameover.click();
    break;
  case  TUTORIAL:
    tutorial.click();
    break;
  }
}
