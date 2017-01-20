//Class for the buttons in the game
class Button {
  //Each  button has a position
  PVector position;
  //A display image
  PImage disImage;
  //A width and height
  int imgWidth, imgHeight;
  //and a type (for checking which button it is)
  String type;

  //Constructor 
  Button(int x, int y, String path, String name, int size) {
    //Pass in all of the values + the path to the file for display image and get the vars to them
    position = new PVector(x, y);
    disImage = loadImage(path);
    disImage.resize(0, size);
    imgWidth = disImage.width;
    imgHeight = disImage.height;
    type = name;
  }

  void drawButton() {
    /*The position is the center of the displayed image so we want to offset by half the height and width to draw the image as the image draws from the
    corner*/
    float modX = position.x-imgWidth/2;
    float modY = position.y-imgHeight/2;
    //Draw the image at this offset location
    image(disImage, modX, modY);
  }
}

