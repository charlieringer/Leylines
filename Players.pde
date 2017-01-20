//This is for the two players in the game
class Player {
  //Need to know if this player is AI or not for AI behavior and scoring things.
  Boolean isAI;
  //If we give each player a score now we can track/modifiy it each time the score changes for live scoring updates. 
  int score;
  //Each player have a set of scroing markers inside
  ScoringMarker [] scoringMarkerArray;
  ArrayList<PointMarker> hand;
  int markersLeft; 

  //Constructor (passing in if this is an AI or not)
  Player(boolean AI) {
    //Sets AI or not
    if (AI) {
      isAI = true;
    } else {
      isAI = false;
    }
    //Score starts at zero
    score = 0;

    //Each player gets 3 scoring markers set up here
    scoringMarkerArray = new ScoringMarker[3];
    for (int i = 0; i < scoringMarkerArray.length; i++) {
      //We pass the player in so that we can work out if they are AI or not to determine what picture the markers get
      scoringMarkerArray[i] = new ScoringMarker(this);
    }
    markersLeft = 3;
  }

  void drawHand() {
    //Loops through the objects in the hand and displays them
    for (int i = 0; i < this.hand.size (); i++) {
      this.hand.get(i).drawObj(30+i*(90), 490);
    }
  }
}
