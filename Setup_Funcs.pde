//This loads all of the data we need and sets up most of the objects
void loadData() { 
  //New instance of minim
  minim = new Minim(this);
  //Load the font here
  font = loadFont("CelticHand-48.vlw");
  //Text wants to be black
  fill(0);
  //Create new game screen objects
  frontend = new Frontend();
  tutorial = new Tutorial();
  gameover = new Gameover();
  settings = new Settings();
  game = new Game();
  //Create a new AI brain object readt to think about the game  
  aiBrain = new AIBrain();
  //Preload the markers (for smooth game play)
  markerImgs = new PImage[8];
  for (int i = 0; i <markerImgs.length; i++) {
    markerImgs[i] = loadImage("Images/Markers/"+ i +".jpg");
  }
  //Load all of the audio files
  click = minim.loadFile("data/audio/click.wav");
  wizard = minim.loadFile("data/audio/wizard.aiff");
  place = minim.loadFile("data/audio/place.wav");
  backgroundMusic = minim.loadFile("data/audio/background.wav");
  win = minim.loadFile("data/audio/win.wav");
  lose = minim.loadFile("data/audio/lose.wav");
}

//This is for the resetable in-game stuff
void setUpGame() {
  //Set up human player
  humanPlayer = new Player(false);
  //set up ai player
  aiPlayer = new Player(true);
  //Sets up the game board with a bunch of blank markers read to be filled
  gameboard = new Marker[5][5];
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      gameboard[i][j] = new Marker();
    }
  }
  //These two array lists represent the players hands
  humanPlayer.hand = new ArrayList<PointMarker>();
  aiPlayer.hand = new ArrayList<PointMarker>();

  //each player starts with 4 random markers in their hand 
  for (int i = 0; i < 4; i++) {
    humanPlayer.hand.add(new PointMarker(-1));
    aiPlayer.hand.add(new PointMarker(-1));
  }
  //50/50 chance that you start. Otherwise it is the AI
  int AIplays =int(random(0, 2));
  if (AIplays == 1) {
    AIturn = true;
  } else {
    AIturn = false;
  }
  //Resets the AIs turn number
  aiBrain.AIturnNumber = 1;
}
