//These are the game markers (leypoint, wizards etc.) 
//The marker class is the base class and represents a blank marker
class Marker {
  //This is that it looks like
  PImage displayImage;
  //it's type (for the extention classes)
  String type;
  //its value (for the extention classes)
  int value;
  //and who owns it (for the extention classes)
  Player owner;

  Marker() {
    //Basic blank marker
    displayImage = markerImgs[0];
    type = "BlankMarker";
    value = 0;
  }

  //method to draw the object at the supplied coords
  void drawObj(int x, int y) {
    image(displayImage, x, y);
  }
}

//This extends marker to make it into a point marker (leypoint)
class PointMarker extends Marker {

  PointMarker(int newValue) {
    //if we pass in -1 it means we want a random point val
    if (newValue == -1) {
      value = getRandomPointValue();
    } else {
      //Otherwise we want the score to = what we based in
      value = newValue;
    }
    //Then depending on what the value is we set the display image to the right one
    if (value == -2) {
      displayImage = markerImgs[1];
    } else if (value == 1) {
      displayImage = markerImgs[2];
    } else if (value == 2) {
      displayImage = markerImgs[3];
    } else if (value == 3) {
      displayImage = markerImgs[4];
    } else if (value == 4) {
      displayImage = markerImgs[5];
    }
    //And it's type is a point marker
    type = "PointMarker";
  }

  //This returns a point value for the constructor
  int getRandomPointValue() { 
    //This is for semi-randomly giving a Point Marker a value (to simulate being drawn from a 'bottomless' deck) 
    int intialRandomInt = int(random(0, 13));
    //Out of 13 (0-12) we want -2 to happen twice, 1 to happen 4 times, 2 to happen 3 times, three to happen twice and 4 to happen twice below does that 
    if (intialRandomInt == 0||intialRandomInt == 1) {
      return -2;
    } else if (intialRandomInt == 2||intialRandomInt == 3||intialRandomInt == 4||intialRandomInt == 5) {
      return 1;
    } else if (intialRandomInt == 6||intialRandomInt == 7||intialRandomInt == 8) {
      return 2;
    } else if (intialRandomInt == 9||intialRandomInt == 10) {
      return 3;
    } else {
      return 4;
    }
  }
}

//This extends marker to make it into a scoring marker (wizard)
class ScoringMarker extends Marker {
  //Has an extra bool to see if it is played or not
  boolean played;
  ScoringMarker(Player player) {
    //Two different images based on if AI or not
    if (player.isAI) {
      displayImage = markerImgs[7];
    } else {
      displayImage = markerImgs[6];
    }
    //Start the marker not being played
    played = false;
    //It is a scoring marker
    type = "ScoringMarker";
    //and the owner is the player we based in
    owner = player;
  }
}
