//Class for the tutorial
class Tutorial {
  //Has an array of images for the tutorial slideshow
  PImage[] tutorialImages;
  //A right arrow
  PImage rightArrow;
  //A left arrow
  PImage leftArrow;
  //A back button
  PImage backButton;
  //We start on the first image in the slideshow
  int currentImg = 0;

  Tutorial() {
    //We have 10 images in the tutorial
    tutorialImages = new PImage[10];
    //All loaded here
    for (int i = 0; i < tutorialImages.length; i++) {
      tutorialImages[i] = loadImage("Images/TutorialScreens/" + (i+1) + ".jpg");
    }
    //Other image loading
    rightArrow = loadImage("Images/TutorialScreens/rightArrow.png");
    leftArrow = loadImage("Images/TutorialScreens/leftArrow.png");
    rightArrow.resize(100, 30);
    leftArrow.resize(100, 30);
    backButton = loadImage("Images/Buttons/back.png");
    backButton.resize(0, 40);
  }

  void drawtut() {
    //Draws the tutorial
    //Work out which image we are drawing and draw it
    image(tutorialImages[currentImg], 0, 0);
    //If it is not the first image draw a left arrow
    if (currentImg > 0) {
      image(leftArrow, 10, 10);
    }
    //If it is not the last image draw a right arrow
    if (currentImg < tutorialImages.length-1) {
      image(rightArrow, width-10-rightArrow.width, 10);
    }
    //And draw the back ground
    image(backButton, width/2-(backButton.width/2), 10);
  }

  void click() {
    //Click handler for tut

    //If we have clicked the left button
    if (currentImg > 0 && mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 40) {
      //Move back one image
      currentImg--;
      //Done so return
      return;
    } else if (currentImg < tutorialImages.length-1 && mouseX > width-110 && mouseX < width-10 && mouseY > 10 && mouseY < 40) {
      //We have clicked the right button so move forward one
      currentImg++;
      //Done so return
      return;
    } else if (mouseX > width/2-(backButton.width/2) && mouseX < width/2+(backButton.width/2) && mouseY > 10 && mouseY < 10+backButton.height) {
      //We have clicked back so reset the current image and go to the frontend
      currentImg = 0;
      currentGameState = FRONT_END;
      //Done so return
      return;
    }
  }
}  
