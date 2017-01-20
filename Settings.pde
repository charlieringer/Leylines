//This is the class for the settings menu //<>//
class Settings {
  //Has a background
  PImage backgroundImg;
  //Therse are the arrays for the buttons
  //Difficutly buttons
  Button[] diffButtons;
  //Arrows for all the switching
  Button[] arrows;
  //On off for the background music
  Button[] sound;
  //On off for the sfx
  Button[] sfx;
  //Button for back
  Button back;
  //int to track the difficutly
  int currentDifficulty;
  //Bool for sound on/off
  boolean soundOn;
  //Bool for sfx on/off
  boolean sfxOn;

  Settings() {
    //Background image is the same as the front end background
    backgroundImg = loadImage("Images/Backgrounds/febg.jpg");
    //These are the difficutly buttons
    diffButtons = new Button[3];
    diffButtons[0] = new Button(width/2, 100, "Images/Settings/easy.png", "easy", 30);
    diffButtons[1] = new Button(width/2, 100, "Images/Settings/medium.png", "medium", 30);
    diffButtons[2] = new Button(width/2, 100, "Images/Settings/hard.png", "hard", 30);

    //And arrow buttons 
    arrows = new Button[6];
    arrows[0] = new Button(width/2-100, 100, "Images/Settings/leftArrow.png", "leftDiff", 30);
    arrows[1] = new Button(width/2+100, 100, "Images/Settings/rightArrow.png", "rightDiff", 30);
    arrows[2] = new Button(width/2-100, 260, "Images/Settings/leftArrow.png", "leftSound", 30);
    arrows[3] = new Button(width/2+100, 260, "Images/Settings/rightArrow.png", "rightSound", 30);
    arrows[4] = new Button(width/2-100, 400, "Images/Settings/leftArrow.png", "leftSFX", 30);
    arrows[5] = new Button(width/2+100, 400, "Images/Settings/rightArrow.png", "rightSFX", 30);

    //Sound buttons
    sound = new Button[2];
    sound[0] = new Button(width/2, 260, "Images/Settings/on.png", "on", 30);
    sound[1] = new Button(width/2, 260, "Images/Settings/off.png", "off", 30);

    //SFX buttons
    sfx = new Button[2];
    sfx[0] = new Button(width/2, 400, "Images/Settings/on.png", "on", 30);
    sfx[1] = new Button(width/2, 400, "Images/Settings/off.png", "off", 30);

    //
    back = new Button(width/2, 550, "Images/Settings/back.png", "back", 40);

    //Difficutly starts at 0 (easy)
    currentDifficulty = 0;
    //Sounds start on
    soundOn = true;
    sfxOn = true;
  }

  //Method for drawing the settings
  void drawSettings() {
    //Background image draw first
    image(backgroundImg, 0, 0);
    //Make sure we are using the right font
    textFont(font, 40);
    //diffiuclty text
    text("difficutly:", 320, 60);
    //Now draw the correct button
    diffButtons[currentDifficulty].drawButton();
    //and draw all of the arrows
    for (int i = 0; i <arrows.length; i++) {
      arrows[i].drawButton();
    }
    //Text for the music option
    text("music:", 350, 220);
    //If the sound is on draw the on button, if it is off then draw the off button
    if (soundOn) {
      sound[0].drawButton();
    } else {
      sound[1].drawButton();
    }
    //Text for the sfx option
    text("SFX:", 360, 360);
    //If the sfx is on draw the on button, if it is off then draw the off button
    if (sfxOn) {
      sfx[0].drawButton();
    } else {
      sfx[1].drawButton();
    }
    //Finally draw the back button
    back.drawButton();
  }

  void click() {
    //Settings click handler

    //It is only the arrows we care about clicking on
    for (int i = 0; i < arrows.length; i++) {
      //These are just set here for readability
      float minX = arrows[i].position.x-(arrows[i].imgWidth/2);
      float maxX = arrows[i].position.x+(arrows[i].imgWidth/2);
      float minY = arrows[i].position.y-(arrows[i].imgHeight/2);
      float maxY = arrows[i].position.y+(arrows[i].imgHeight/2);
      if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
        //Is we have clicked on a button check to see what type it is
        if (arrows[i].type == "leftDiff") {
          //Left difficulty button so changing the difficutly down
          changeDifficultyDown();
          //done with the func so return
          return;
        } else if (arrows[i].type == "rightDiff") {
          //Right difficulty button so changing the difficutly up
          changeDifficultyUp();
          //done with the func so return
          return;
        } else if (arrows[i].type == "leftSound"||arrows[i].type == "rightSound") {
          //Either of the sound buttons so switch the on off of the sound
          soundOn = !soundOn;
          //done with the func so return
          return;
        } else if (arrows[i].type == "leftSFX"||arrows[i].type == "rightSFX") {
          //Either of the sfx buttons so switch the on off of the sfx
          sfxOn = !sfxOn;
          //done with the func so return
          return;
        }
      }
    }
    //This is checking if we have clicked the back button
    float minX = back.position.x-(back.imgWidth/2);
    float maxX = back.position.x+(back.imgWidth/2);
    float minY = back.position.y-(back.imgHeight/2);
    float maxY = back.position.y+(back.imgHeight/2);
    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
      //we want to go back to the front end
      currentGameState = FRONT_END;
    }
  }

  void changeDifficultyDown() {
    //We want to change the difficutly down
    if (difficulty == MEDIUM) {
      //if it is medium then diff is now easy
      difficulty = EASY;
      currentDifficulty = 0;
    } else if (difficulty == HARD) {
      //if it is hard then diff is now medium
      difficulty = MEDIUM;
      currentDifficulty = 1;
    }
  }

  void changeDifficultyUp() {
    //We want to change the difficutly up
    if (difficulty == EASY) {
      //if it is easy then diff is now medium
      difficulty = MEDIUM;
      currentDifficulty = 1;
    } else if (difficulty == MEDIUM) {
      //if it is medium then diff is now hard
      difficulty = HARD;
      currentDifficulty = 2;
    }
  }
}
