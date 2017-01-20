//This class is long and contains the game itself and handles player input when playing the game
class Game {
  //In-Game background
  PImage gameBackground;
  //Buttons for choosing an action
  Button[] inGameButtons;
  //Button for going back if the user changes their mind
  Button back;
  //List of previous moves. This tracks the path the user has taken through the turn sequence so we can go 
  //back if the user wants too
  IntList prevMoves;
  //This tracks the selected leyline for when we play one
  int currentSelectedCard;
  //This tracks the marker for when we move a score marker
  Marker markerToMove;

  Game() {
    //The game has a background image
    gameBackground = loadImage("Images/Backgrounds/ingamebackground.jpg");

    //And some buttons
    inGameButtons = new Button[4];
    inGameButtons[0] = new Button(190, 150, "Images/Buttons/play.png", "place", 30);
    inGameButtons[1] = new Button(190, 200, "Images/Buttons/playwizard.png", "score", 30);
    inGameButtons[2] = new Button(190, 250, "Images/Buttons/remove.png", "remove", 30);
    inGameButtons[3] = new Button(190, 300, "Images/Buttons/movewizard.png", "move", 30);
    back = new Button(190, 400, "Images/Buttons/back.png", "back", 40);
  }

  /* -------------------
   Herein lies the code that handles all of the in game functionality 
   It starts with a 'Master function' which contains calls to all of the other functions in the order we want to execute each frame
   Then all of the other funcs. are defined
   --------------------*/

  //This is the master function
  void runGameCode() {
    //Draws all of the info for the player to the screen
    displayInfo();
    //We only want to display the Human Players hand, not the AIs
    humanPlayer.drawHand();

    //Then runs the AI stuff if it is the AIs turn
    if (AIturn) {
      //If it is the AIs turn we have to run th calualtions from here
      //The human player turn progress is different and contingent on mouse clicks
      aiBrain.runAI(aiPlayer, humanPlayer);
      updateScores(humanPlayer, aiPlayer);
      checkforGameOver();
    }
  }

  //For drawing the info to the screen
  void displayInfo() {
    //draws the background
    image(gameBackground, 0, 0);
    //This draws the game board
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        gameboard[i][j].drawObj(380+ (i*81), 50+(j*81));
      }
    }
    //This handles the instructions to the player
    if (AIturn) {
      //Tell the user it's the AIs turn
      textFont(font, 40);
      text("AI", 100, 150);
      text("Thinking...", 62, 190);
    } else {
      //Tell them what to do, based on what part of the turn they are in
      if (turnProgress == CHOOSE_ACTION) {
        //This is for chooseing which action they want to take
        textFont(font, 40);
        text("Choose an action:", 40, 90);
        for (int i = 0; i < inGameButtons.length; i++) {
          inGameButtons[i].drawButton();
        }
      } else if (turnProgress == CHOOSE_CARD) {
        //If they have chosen to play a leypoint, instructs them which one to play
        textFont(font, 40);
        text("Choose a leypoint", 40, 150);
        text("to play:", 100, 200);
        //back option
        back.drawButton();
      } else if (turnProgress == CHOOSE_SQAURE) {
        //And then which square to play that ley point in
        textFont(font, 40);
        text("Choose a square", 40, 150);
        text("to play in:", 100, 200);
        //back option
        back.drawButton();
      } else if (turnProgress == PLACE_SCORING_MARKER) {
        //If they have chosen to play a wizard, instucts to choose a sqaure to play in
        textFont(font, 40);
        text("Choose a square", 40, 150);
        text("to play in:", 100, 200);
        //back option
        back.drawButton();
      } else if (turnProgress == REMOVE_MARKER) {
        //If the user wants to remove a marker here is where they chose which one
        textFont(font, 40);
        text("Choose a leypoint", 40, 150);
        text("to Remove:", 100, 200);
        //back option
        back.drawButton();
      } else if (turnProgress == CHOOSE_SCORING_MARKER) {
        //If they want to move a wizard about they need to select one ..
        textFont(font, 40);
        text("Choose a wizard", 40, 150);
        text("to move:", 100, 200);
        //back option
        back.drawButton();
      } else if (turnProgress == CHOOSE_DEST) {
        //...And then select a destination
        textFont(font, 40);
        text("Choose a square:", 40, 150);
        //back option
        back.drawButton();
      } else if (turnProgress == CHOOSE_DISCARD) {
        //If thye have chosen to remove or move they need to discard. No back option as it is too late at this point
        textFont(font, 40);
        text("Choose a leypoint", 40, 150);
        text("in hand to discard", 40, 200);
      }
    }
    //Finally displays the various trackable data (score and number of wizards left)
    textFont(font, 22);
    text ("Human Score: " + humanPlayer.score, 400, 510);
    text("AI Score: "+ aiPlayer.score, 600, 510);
    text("Wizards left: " + humanPlayer.markersLeft, 400, 550);
  }

  //Updates the scores of the two players
  void updateScores(Player player1, Player player2) {
    //Reset the scores as we will calcualte them from scratch now
    player1.score = 0;
    player2.score = 0;
    //Loop through the board 
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //Is the current marker a scoring marker?
        if (gameboard[i][j].type == "ScoringMarker") {
          //And is it owned by player 1?
          if (gameboard[i][j].owner == player1) {
            //Loop through the horizonal lines and add up the score
            for (int k = 0; k < 5; k++) {
              if (gameboard[k][j].type == "PointMarker") {
                player1.score+=gameboard[k][j].value;
              }
            }
            for (int l = 0; l < 5; l++) {
              //Thwn the vertical ones
              if (gameboard[i][l].type == "PointMarker") {
                player1.score+=gameboard[i][l].value;
              }
            }
          } else {
            //It must be owned by player two
            for (int k = 0; k < 5; k++) {
              //Loop through the horizonal lines and add up the score
              if (gameboard[k][j].type == "PointMarker") {
                player2.score+=gameboard[k][j].value;
              }
            }
            for (int l = 0; l < 5; l++) {
              //Loop through the vertical lines and add up the score
              if (gameboard[i][l].type == "PointMarker") {
                player2.score+=gameboard[i][l].value;
              }
            }
          }
        }
      }
    }
  }

  void checkforGameOver() {
    //Loop through ever part of the board
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //Have I found an empty space?
        if (gameboard[i][j].type == "BlankMarker")
          //Yes? Then the game is not over, we are done with this function
          return;
      }
    }
    //Every space is full so the game is over
    currentGameState = GAME_OVER_SCREEN;
    //Play the end of game audio
    playEndgame();
  }

  /* -------------------
   Herein lies the code that handles all of the in game click functionality for the human player
   It starts with a 'Master function' which contains calls to all of the other functions in the order we want to execute
   Then all of the other funcs. are defined
   --------------------*/

  void inGameClickLogic() {
    //This click logic is pretty long but hopefully make sense
    //This is all for handling each stage of the the player making a move
    //Each function can be found in 'Human Click Funcs'
    if (turnProgress == CHOOSE_ACTION) {
      //Time to chose which action we are going to do
      chooseAction();
    } else if (turnProgress == CHOOSE_CARD) {
      //For the Place action, need to chose which marker to play
      chooseCard();
    } else if (turnProgress == CHOOSE_SQAURE) {
      //And then the square to play it in
      chooseSquare();
    } else if (turnProgress == PLACE_SCORING_MARKER) {
      //Since all scoring markers are the same we just choose the a square to play in. 
      //This func does that and places the marker
      placeScoringMarker();
    } else if (turnProgress == REMOVE_MARKER) {
      //Sore the remove action, just removes a marker, we do discard later
      removeAMarker();
    } else if (turnProgress == CHOOSE_SCORING_MARKER) {
      //For move action, choses a marker to be moved
      chooseScoreMarker();
    } else if (turnProgress == CHOOSE_DEST) {
      //choses destination and moves marker
      chooseDestination(markerToMove);
    } else if (turnProgress == CHOOSE_DISCARD) {
      //Called for both the remove and move actions to discard a card
      discardCard();
    }
  }

  //This is the function that handles the first part of the turn
  void chooseAction() {
    //Creates a new int list to track where the player has been in the turn
    prevMoves = new IntList();

    //Then if there previously had been no marker played on the board
    if (!markerPlayed) {
      //We loop through all of the spaces of the board
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          //And if we find a marker
          if (gameboard[i][j].type == "PointMarker") {
            //Set it to true and break
            markerPlayed = true;
            break;
          }
        }
      }
    }
    //This draws the clickable instruction buttons
    for (int i = 0; i < game.inGameButtons.length; i++) {
      //Storing all of the XY vals in locals for readability later
      float minX = game.inGameButtons[i].position.x-(inGameButtons[i].imgWidth/2);
      float maxX = game.inGameButtons[i].position.x+(inGameButtons[i].imgWidth/2);
      float minY = game.inGameButtons[i].position.y-(inGameButtons[i].imgHeight/2);
      float maxY = game.inGameButtons[i].position.y+(inGameButtons[i].imgHeight/2);
      //If the mouse is within the bounds of the button
      if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
        //check it's type
        if (game.inGameButtons[i].type == "place") {
          //And move to the corresponding part of the turn
          //Also, appending where we have been to the list of previous moves this turn
          prevMoves.append(turnProgress);
          turnProgress = CHOOSE_CARD; 
          return;
        } else if (game.inGameButtons[i].type == "score" && humanPlayer.markersLeft > 0) {
          //Append progress and move
          prevMoves.append(turnProgress);
          turnProgress = PLACE_SCORING_MARKER;
          return;
        } else if (game.inGameButtons[i].type == "remove" && markerPlayed) {
          //Append progress and move
          prevMoves.append(turnProgress);
          turnProgress = REMOVE_MARKER;
          return;
        } else if (game.inGameButtons[i].type == "move" && humanPlayer.markersLeft<3) {
          //Append progress and move
          prevMoves.append(turnProgress);
          turnProgress = CHOOSE_SCORING_MARKER;
          return;
        }
      }
    }
  }

  void chooseCard() {
    //We have chosen to play a leypoint so now we need to choose which one to play

    //Loop through the hand and see if we have a hit
    for (int i = 0; i < humanPlayer.hand.size (); i++) {
      //This is the coords for each card in hand (as it is draw to screen
      if ((mouseX > (30+i*(90))) && (mouseX < (110+i*(90))) && (mouseY > 490) && (mouseY < 580)) {
        //set the selected card to the one we have clicked on
        currentSelectedCard = i;
        prevMoves.append(turnProgress);
        //Then move to the next part of the turn
        turnProgress = CHOOSE_SQAURE;
        return;
      } else if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
        //We have decided to go backwards so move to the previous part of the turn.
        int lengthofMoves = prevMoves.size();
        if (lengthofMoves>0) {
          turnProgress = prevMoves.get(lengthofMoves-1);
          prevMoves.remove(lengthofMoves-1);
        }
      }
    }
  }

  void chooseSquare() {
    //We are now chosing a square to play in so loop through all the squares and see if we have a hit
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //Check for hit    
        if ((mouseX > (380 + (i*81))) && (mouseX < (470+ (i*81))) && (mouseY > (50+(j*81))) && (mouseY < (130+(j*81)))) {
          //if we have a hit and it is currently blank
          if (gameboard[i][j].type == "BlankMarker") {
            //make a new marker there equal to the value of the card you wanted to play
            gameboard[i][j] = new PointMarker(humanPlayer.hand.get(currentSelectedCard).value);
            //Remove the card from the hand
            humanPlayer.hand.remove(currentSelectedCard);
            //and draw a new random one (-1 means random)
            humanPlayer.hand.add(new PointMarker(-1));
            //Reset the turn for next time
            turnProgress = CHOOSE_ACTION;
            //Play the leypoint sound
            playLeypoint();
            //It is now the AIs turn
            AIturn = true;
            //We have done everything we want to quit out of the function
            return;
          }
        }
      }
    }
    if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
      //We have decided to go backwards so move to the previous part of the turn.
      int lengthofMoves = prevMoves.size();
      if (lengthofMoves>0) {
        turnProgress = prevMoves.get(lengthofMoves-1);
        prevMoves.remove(lengthofMoves-1);
      }
    }
  }

  void placeScoringMarker() {
    //We are placing a wizard
    //Loop through all of the sqaures to see if we have a hit
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //Check to see if we have a hit
        if ((mouseX > (380 + (i*81))) && (mouseX < (470+ (i*81))) && (mouseY > (50+(j*81))) && (mouseY < (130+(j*81)))) {
          //is it a blank marker
          if (gameboard[i][j].type == "BlankMarker") {
            //Loop through the markers
            for (int k = 0; k < humanPlayer.scoringMarkerArray.length; k++) {
              //find the first one that has not been played
              if (humanPlayer.scoringMarkerArray[k].played == false) {
                //Place it on the board
                gameboard[i][j] = humanPlayer.scoringMarkerArray[k];
                //It is now played so set this and decrement the number of markers left
                humanPlayer.scoringMarkerArray[k].played = true;
                humanPlayer.markersLeft--;
                //reset the turn
                turnProgress = CHOOSE_ACTION;
                //switch to AI
                AIturn = true;
                //play the wizard audio
                playWizard(); 
                //done so quit out of the func
                return;
              }
            }
          }
        }
      }
    }
    if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
      //We have decided to go backwards so move to the previous part of the turn.
      int lengthofMoves = prevMoves.size();
      if (lengthofMoves>0) {
        turnProgress = prevMoves.get(lengthofMoves-1);
        prevMoves.remove(lengthofMoves-1);
      }
    }
  }

  void removeAMarker() {
    //This is for removing a marker from the board 
    //Again looping through all of the squares
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //Have a hit
        if ((mouseX > (380 + (i*81))) && (mouseX < (470+ (i*81))) && (mouseY > (50+(j*81))) && (mouseY < (130+(j*81)))) {
          //And it is a point marker (so ripe for removal)
          if (gameboard[i][j].type == "PointMarker") {
            //Make it a new blank marker
            gameboard[i][j] = new Marker();
            //go to discard
            turnProgress = CHOOSE_DISCARD;
            //play the leypoint sounf
            playLeypoint();
            //done with this function
            return;
          }
        }
      }
    }
    if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
      //We have decided to go backwards so move to the previous part of the turn.
      int lengthofMoves = prevMoves.size();
      if (lengthofMoves>0) {
        turnProgress = prevMoves.get(lengthofMoves-1);
        prevMoves.remove(lengthofMoves-1);
      }
    }
  }

  void chooseScoreMarker() {
    //We are moving a wizard

    //So loop through the board
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //if we have clicked it
        if ((mouseX > (380 + (i*81))) && (mouseX < (470+ (i*81))) && (mouseY > (50+(j*81))) && (mouseY < (130+(j*81)))) {
          //and it one of our markers
          if (gameboard[i][j].type == "ScoringMarker" && gameboard[i][j].owner == humanPlayer) {
            //Store the wizard we are moving
            markerToMove = gameboard[i][j];
            //track this part of the turn
            prevMoves.append(turnProgress);
            turnProgress = CHOOSE_DEST;
            //and quit out of the func
            return;
          }
        }
      }
    }
    if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
      //We have decided to go backwards so move to the previous part of the turn.
      int lengthofMoves = prevMoves.size();
      if (lengthofMoves>0) {
        turnProgress = prevMoves.get(lengthofMoves-1);
        prevMoves.remove(lengthofMoves-1);
      }
    }
  }

  void chooseDestination(Marker piMarkerToMove) {
    //This is for when you want to move a wizard
    //Loop through the board
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        //is it the one we clicked on?
        if ((mouseX > (380 + (i*81))) && (mouseX < (470+ (i*81))) && (mouseY > (50+(j*81))) && (mouseY < (130+(j*81)))) {
          //is it black?
          if (gameboard[i][j].type == "BlankMarker") {
            //if it is within one square up down left right of the original place
            if (i <= 3 && gameboard[i+1][j]  == piMarkerToMove) {
              //Move it there
              gameboard[i][j] = piMarkerToMove;
              //Make the original place empty
              gameboard[i+1][j] = new Marker();
              //Go to discard
              turnProgress = CHOOSE_DISCARD;
              //play the wizard sound
              playWizard();
              //quit out of the func
              return;
            } else if (i >= 1 && gameboard[i-1][j]  == piMarkerToMove) {
              //Move it there
              gameboard[i][j] = piMarkerToMove;
              //Make the original place empty 
              gameboard[i-1][j]  = new Marker();
              //Go to discard
              turnProgress = CHOOSE_DISCARD;
              //play the wizard sound
              playWizard();
              //quit out of the func
              return;
            } else if (j <= 3 && gameboard[i][j+1]  == piMarkerToMove) {
              //Move it there
              gameboard[i][j] = piMarkerToMove;
              //Make the original place empty
              gameboard[i][j+1] = new Marker();
              //Go to discard
              turnProgress = CHOOSE_DISCARD ;
              //play the wizard sound
              playWizard();
              //quit out of the func
              return;
            } else if (j >= 1 && gameboard[i][j-1]  == piMarkerToMove) {
              //Move it there
              gameboard[i][j] = piMarkerToMove;
              //Make the original place empty
              gameboard[i][j-1] = new Marker();
              //Go to discard
              turnProgress = CHOOSE_DISCARD;
              //play the wizard sound
              playWizard();
              //quit out of the func
              return;
            }
          }
        }
      }
    }
    if (mouseX > back.position.x-back.imgWidth/2  && mouseX < back.position.x+back.imgWidth/2 && mouseY > back.position.y-back.imgHeight/2 && mouseY < back.position.y+back.imgHeight/2) {
      //We have decided to go backwards so move to the previous part of the turn.
      int lengthofMoves = prevMoves.size();
      if (lengthofMoves>0) {
        turnProgress = prevMoves.get(lengthofMoves-1);
        prevMoves.remove(lengthofMoves-1);
      }
    }
  }

  void discardCard() {
    //Final part of the turn if you removed a leypoint or moved a wizard
    for (int i = 0; i < humanPlayer.hand.size (); i++) {
      //Did we click on a card in hand?
      if ((mouseX > (30+i*(90))) && (mouseX < (90+i*(90))) && (mouseY > 490) && (mouseY < 580)) {
        //if so remove it from the hand
        humanPlayer.hand.remove(i);
        //reset the turn
        turnProgress = CHOOSE_ACTION;
        //switch to ai's turn
        AIturn = true;
        //and return
        return;
      }
    }
  }
}
