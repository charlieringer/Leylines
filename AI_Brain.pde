class AIBrain { //<>//
  //This is for working out what moves we have available
  ArrayList<Move>totalMoves;
  //This is for the sorted list of moves
  ArrayList<Move>sortedMoves;
  //These are for waiting. We wait before making a move to make the AI look like it is thinking hard before making a move
  int timeStarted;
  int waitTime;
  //This is so that we know when to set up the AI wait
  boolean startingAI = true;
  //We want to know how many moves the AI has had
  int AIturnNumber = 1;

  void runAI(Player thisPlayer, Player opponent) {
    //Is we want to start the AI going
    if (startingAI) {
      //We only want to do this once
      startingAI = false;
      //Record the start time
      timeStarted = millis();
      //And create a semi random wait time 
      waitTime = int(random(1000, 1500));
    } 
    //If we have waited long enough
    if (millis() > timeStarted+waitTime) {
      //Create the move array
      createMoveArray(thisPlayer, opponent);
      //remove the 'bad' scoring moves
      removeMoves();
      //Sort the moves 
      sortMoves();
      //Work out and execute a move
      chooseAndExecuteMove();
      //We are done with the AI but before we finish we set the startingAI back to true so that it is ready for the next time. 
      startingAI = true;
    }
  }
  
  //This is the function that works out all of the available moves and stores them in the total moves array
  void createMoveArray(Player thisPlayer, Player opponent) {
    //totalMoves becomes a new list so that it is empty
    totalMoves = new ArrayList<Move>();

    //We want the AI to play a scoring marker at least every 4 turns so that the AI always plays enough scoring markers
    if (AIturnNumber%4 == 0 && AIturnNumber > 0 && thisPlayer.markersLeft > 0) {
      //Loop through all of the places on the board
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          //if it is a blank marker
          if (gameboard[i][j].type == "BlankMarker") {
            //loop through all of the scoring markers
            for (int k = 0; k < thisPlayer.scoringMarkerArray.length; k++) {
              //find the first unplaed one
              if (thisPlayer.scoringMarkerArray[k].played == false) {
                //Add this to the moves array
                totalMoves.add(new ScoreMove(k, i, j, thisPlayer, opponent));
                //then break (as all of the scroing markers are the same)
                break;
              }
            }
          }
        }
      }
    } else {
      //We are free to do what we want 
      //Loop through all of the places on the board
      for (int j = 0; j < 5; j++) {
        for (int k = 0; k < 5; k++) {
          //Blank space so lets add moves for point markers and score markers
          if (gameboard[j][k].type == "BlankMarker") {
            //Loop through all of the leypoint markers in the players hand
            for (int i = 0; i < thisPlayer.hand.size (); i++) {
              //And create a move for each of them 
              totalMoves.add( new PlaceMove(i, j, k, thisPlayer, opponent));
            }
            //Then if we have a wizard left to play
            if (thisPlayer.markersLeft > 0) {
              //Loop through the scoring marker array
              for (int i = 0; i < thisPlayer.scoringMarkerArray.length; i++) {
                if (thisPlayer.scoringMarkerArray[i].played == false) {
                  //find the first unplayed one and add it to the move list
                  totalMoves.add( new ScoreMove(i, j, k, thisPlayer, opponent));
                  //then break (as all of the scroing markers are the same)
                  break;
                }
              }
            }
          } else if (gameboard[j][k].type == "PointMarker" && thisPlayer.hand.size() > 1) {
            //This space is occupied by a point marker (leypoint)
            //so loop though every card in the players hand
            for (int i = 0; i < thisPlayer.hand.size (); i++) {
              //and create a move for removing that marker and discarding the card from your hand
              totalMoves.add( new RemoveMove(i, j, k, thisPlayer, opponent));
            }
          } else if (gameboard[j][k].type == "ScoringMarker" && gameboard[j][k].owner == thisPlayer && thisPlayer.hand.size() > 1) {
            println("Found a marker at: " + j + " " + k);
            //We have one of the AIs scoring markers so we can move it, let's create moves for that
            //Loop through the 9 squares arround the location
            for (int l = j-1; l < j+2; l++) {
              for (int m = k-1; m < k+2; m++) {
                //Is it makes part of the board and is empty
                if (l >= 0 && l < 5 && m >=0 && m < 5 && gameboard[l][m].type == "BlankMarker" ) {
                  //If it is in line with the original position in either the j or k line then we have a square we can move to
                  if (j %2 == l%2 || k%2 == m%2) {
                    //so create a new move 
                    for (int i = 0; i < thisPlayer.hand.size (); i++) {
                      //For every card in hand
                      totalMoves.add( new MoveMove(i, j, k, l, m, thisPlayer, opponent));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  //This is for removing Scoring moves that art not actually that good. Otherwise the AI will pretty much always play it's scoring markers straight away which is poor
  //It also removes all of the move moves that do not increase the current score (as otherwise the AI will see these as better than just playing sometimes)
  void removeMoves() {
    //We only do this is we have at least one other move type so that the AI will always have a move available. 
    //Loop through all of the moves
    for (int i = 0; i < totalMoves.size (); i++) { 
      //We have found a non score move
      if (totalMoves.get(i).type != "score") {
        //So lets get rid of the bad move scores
        for (int j = 0; j < totalMoves.size (); j++) {
          //loop through again and find all the moves that are worth less tahn 6 extra points
          if (totalMoves.get(j).type == "score" && totalMoves.get(j).score < aiPlayer.score-humanPlayer.score+6 ) {
            //and remove them
            totalMoves.remove(j);
          }
        }
        //Only need to do this once so return out of the function
        return;
      }
    }
  }

  //We need a sorted list of moves for the AI to think about
  void sortMoves() {
    //We create a new list of moves ready to receive the sorted total moves
    sortedMoves = new ArrayList<Move>();
    //Then quick sort out total moves and set this list to that
    sortedMoves = quickSort(totalMoves);
  }

  //Quick sort algorithm implementation base on this http://codereview.stackexchange.com/questions/27861/simplest-quick-sort-using-one-19-line-function
  ArrayList<Move> quickSort(ArrayList<Move> sortArray) {
    //function is recursive so this is out base case
    //If the have a list with 1 or 0 items in it then it is already sorted
    if (sortArray.size() <= 1) {
      //so we can just return it
      return sortArray;
    }
    //This pivot location can be anywhere but I chose mid way just incase the list is already mostly sorted
    int pivotLoc = floor(sortArray.size()/2);
    //Create a move for the pivot
    Move pivotMove = new Move();
    //and make it a copy of the move in the pivot location
    pivotMove = sortArray.get(pivotLoc);
    //Also storing it's score in a local as we need to get hold of it alot
    int pivotScore = sortArray.get(pivotLoc).score;
    //We then remove the move at the pivot location (as we have it stored in a local already
    sortArray.remove(pivotLoc);
    //Time to split the list in half so lets make two lists, one high and one low
    ArrayList<Move> low = new ArrayList<Move>();
    ArrayList<Move> high = new ArrayList<Move>();
    //Then loop through all of the moves
    for (int i = 0; i < sortArray.size (); i++) {
      //If the score is left than or equal to the pivot then add it to the low array otherwise add to the high array
      if (sortArray.get(i).score <= pivotScore) {
        low.add(sortArray.get(i));
      } else {
        high.add(sortArray.get(i));
      }
    }
    //Then quick sort these tweo smaller lists
    quickSort(low);
    quickSort(high);
    //Ensure that the sort array is clear
    sortArray.clear();
    //THen add the lower part
    sortArray.addAll(low);
    //then the pivot 
    sortArray.add(pivotMove);
    //then the higher part
    sortArray.addAll(high);
    //all sorted so return it
    return sortArray;
  }

  void chooseAndExecuteMove() {
    //AI choice based on Fitness Proportionate Selection (read about it here http://en.wikipedia.org/wiki/Fitness_proportionate_selection)
    //We only want to work out a move if we have moves avaiable (although this should never happen)
    if (sortedMoves.size() > 0) {
      //The worst move we have is always in position 0
      int worstMove = sortedMoves.get(0).score;
      //We need to sum all of the scores
      int sumofScores = 0;
      //Then we will choose a random value from amoung that
      int chosenValue = 0;
      //And use this to track where we are through the sum of scores will we find the chosen value
      int runningTotal = 0;

      //Debug stuff
      println("AI hand size: " + aiPlayer.hand.size());
      println("AI's move list:");
      //Loop through all of the moves
      for (int i = 0; i <sortedMoves.size (); i++) {
        //Is we have some negative scores
        if (worstMove < 0) {
          //We need to modify all of the scores to shift the range to start at 0
          int modScore = -worstMove+(sortedMoves.get(i).score);
          //Then we need to calculate the power of that (raising to a power based on difficulty)
          //We do this becasue the high the power the more likely we are to do the best move. 
          //Current values are easy - ^2, medium - ^4, hard - ^8
          int modScorePow = int(pow(modScore, difficulty));
          //Then we add this value to the sum of scores
          sumofScores+=modScorePow;
          //Debug stuff
          println(i + ": Move type: " + sortedMoves.get(i).type + ", Move score: " + sortedMoves.get(i).score + ", Modified score: " + modScore + ", current score: " + sumofScores);
        } else {
          //Same as above but the worst score is = 0 so no need to modify the scores first
          sumofScores += pow(sortedMoves.get(i).score, difficulty);
          println(i + ": Move type: " + sortedMoves.get(i).type + ", Move score: " + sortedMoves.get(i).score + ", no modified score"+ ", current score: " + sumofScores);
          sumofScores += pow(sortedMoves.get(i).score, difficulty);
        }
      }
      //We have summed all of the scores
      //Debug stuff
      println("Sum of scores: " + sumofScores);
      //So now we can choose a random values in the range 
      chosenValue = int(random(0, sumofScores+1));
      //Debug stuff
      println("Chosen val: " + chosenValue);

      //Now we need to find that move
      //So loop through all of the moves again
      for (int j = 0; j <sortedMoves.size (); j++) {
        //If we have a negative move
        if (worstMove < 0) {
          //We need to modifiy the moves again 
          int modScore = -worstMove+(sortedMoves.get(j).score);
          //The running total gets incremented based on the new score (same as the sum of scores before)
          runningTotal += pow(modScore, difficulty);
          //If we have gone past the chosen values
          if (chosenValue <= runningTotal) {
            //This is the move to execute
            //Debug stuff
            println("The move we have chosen is a " + sortedMoves.get(j).type + " move and scores: " + sortedMoves.get(j).score + " ,it was the " + j + "th item in a list. Running total was: " + runningTotal);
            //If we are interacting with a leypoint
            if (sortedMoves.get(j).type == "place" || sortedMoves.get(j).type == "remove") {
              //play that sound
              playLeypoint();
            } else {
              //otherwise play the wizard sound
              playWizard() ;
            }
            //execute the move
            sortedMoves.get(j).execute();
            //AI's turn is done
            AIturn = false;
            //Increment the number of moves
            this.AIturnNumber++;
            //And return, we are done
            return;
          }
        } else {
          //No need to raise to the power
          runningTotal += pow(sortedMoves.get(j).score, difficulty);
          //If we have gone past the chosen values
          if (chosenValue <= runningTotal) {
            //This is the move to execute
            //Debug stuff
            println("The move we have chosen is a " + sortedMoves.get(j).type + " move and scores: " + sortedMoves.get(j).score + " ,it was the " + j + "th item in a list. Running total was: " + runningTotal);
            //If we are interacting with a leypoint
            if (sortedMoves.get(j).type == "place" || sortedMoves.get(j).type == "remove") {
              //play that sound
              playLeypoint();
            } else {
              //otherwise play the wizard sound
              playWizard() ;
            }
            //execute the move
            sortedMoves.get(j).execute();
            //AI's turn is done
            AIturn = false;
            //Increment the number of moves
            this.AIturnNumber++;
            //And return, we are done
            return;
          }
        }
      }
    }
  }
}
