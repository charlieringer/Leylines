//These are all of the classes for the move
//This class is the blank one that we built off of
class Move {
  //This is very empty but becasue we use a move array list in the AI brain we have to have this stuff sadly. 
  int score;  
  String type;

  Move() {
  }
  void execute() {
  }
}

//This is for when playing a leypoint
class PlaceMove extends Move {
  //Has a location on the bard and a location in hand for the marker we are going to play
  int boardI, boardJ, handLoc;
  //And the players 
  Player player, opp;

  PlaceMove( int newHandLoc, int newI, int newJ, Player newPlayer, Player newOpp ) {
    //We take the that we pass in from the AI brain and set the vars to it
    boardI = newI;
    boardJ = newJ;
    handLoc  = newHandLoc;
    player = newPlayer;
    opp = newOpp;
    //And then we work out how good the score is
    score = this.calculateScore();
    //And set the type of move to 'place'
    type = "place";
  }

  int calculateScore() {
    //play the move
    gameboard[boardI][boardJ] = new PointMarker(player.hand.get(handLoc).value);
    //update the scores
    game.updateScores(player, opp);
    //Work out how good the move is
    int newScore = player.score-opp.score;
    //Clear the move
    gameboard[boardI][boardJ] = new Marker();
    return newScore;
  }

  void execute() {
    //This plays the move 
    //Put a marker on the board
    gameboard[boardI][boardJ] = new PointMarker(player.hand.get(handLoc).value);
    //Remove it from the players hand
    player.hand.remove(handLoc);
    //And put a new random marker in
    player.hand.add(new PointMarker(-1));
  }
}

//This is for playing a wizard
class ScoreMove extends Move {
  //This time we have a location on board and a wizard to place
  int boardI, boardJ, markerToPlace;
  Player player, opp;

  ScoreMove( int unusedMarker, int newI, int newJ, Player newPlayer, Player newOpp ) {
    //We take the that we pass in from the AI brain and set the vars to it
    boardI = newI;
    boardJ = newJ;
    markerToPlace  = unusedMarker;
    player = newPlayer;
    opp = newOpp;
    //Work out the score
    score = this.calculateScore();
    //This is type score
    type = "score";
  }

  int calculateScore() {
    //play the move
    gameboard[boardI][boardJ] = player.scoringMarkerArray[markerToPlace];
    //update the scores
    game.updateScores(player, opp);
    //Work out how good the move is
    int newScore = player.score-opp.score;
    //Clear the move
    gameboard[boardI][boardJ] = new Marker();
    return newScore;
  }

  void execute() {
    //This plays the move
    //Put the marker on the board
    gameboard[boardI][boardJ] = player.scoringMarkerArray[markerToPlace];
    //Now the marker is played
    player.scoringMarkerArray[markerToPlace].played = true;
    //And the player has one less move to play
    player.markersLeft--;
  }
}

class RemoveMove extends Move {
  int boardI, boardJ, handLoc;
  Player player, opp;

  RemoveMove( int newHandLoc, int newI, int newJ, Player newPlayer, Player newOpp ) {
    //We take the that we pass in from the AI brain and set the vars to it
    boardI = newI;
    boardJ = newJ;
    handLoc  = newHandLoc;
    player = newPlayer;
    opp = newOpp;
    //work out the score
    score = this.calculateScore();
    //this is a remove move
    type = "remove";
  }

  int calculateScore() {
    //store the value of the piece to be removed
    int removeVal = gameboard[boardI][boardJ].value;
    //play the move
    gameboard[boardI][boardJ] = new Marker();
    //update the scores
    game.updateScores(player, opp);
    //Work out how good the move is
    int newScore = player.score-opp.score;
    //Clear the move
    gameboard[boardI][boardJ] = new PointMarker(removeVal);
    //The -2 part is because we need to simulate the value of the card that is discarded
    return newScore-2;
  }

  void execute() {
    //This plays the move
    //Make this location blank
    gameboard[boardI][boardJ] = new Marker();
    //Then remove the card we are discarding from the hand
    player.hand.remove(handLoc);
  }
}

class MoveMove extends Move {
  int oldBoardI, oldBoardJ, newBoardI, newBoardJ, handLoc;
  Player player, opp;

  MoveMove(int newHandLoc, int currI, int currJ, int toI, int toJ, Player newPlayer, Player newOpp ) {
    //We take the that we pass in from the AI brain and set the vars to it
    oldBoardI = currI;
    oldBoardJ = currJ;
    newBoardI = toI;
    newBoardJ = toJ;
    handLoc = newHandLoc;
    player = newPlayer;
    opp = newOpp;
    //Calculate the scores
    score = this.calculateScore();
    //This is a move move
    type = "move";
  }

  int calculateScore() {
    //Set the new location to the old one 
    gameboard[newBoardI][newBoardJ] = gameboard[oldBoardI][oldBoardJ];
    //The remove from the old location
    gameboard[oldBoardI][oldBoardJ] = new Marker();
    //Then update the scores
    game.updateScores(player, opp);
    //Set the new score to the updated scores
    int newScore = player.score-opp.score;
    //Then move the peice back
    gameboard[oldBoardI][oldBoardJ] = gameboard[newBoardI][newBoardJ];
    //And clear the moved to location
    gameboard[newBoardI][newBoardJ] = new Marker();
    //And return the score -2 (as a cost to discarding the card from hand)
    return newScore-2;
  }

  void execute() {
    //This plays the move
    //places the wizard in the new location
    gameboard[newBoardI][newBoardJ] = gameboard[oldBoardI][oldBoardJ];
    //and removes it from th old location
    gameboard[oldBoardI][oldBoardJ] = new Marker();
    //then removes the discarded card
    player.hand.remove(handLoc);
  }
}
