/* ---------------------------
Below are all of my Varables and Constants used in the game
This contains both front end and in game values (seperated and organised hopefully)
---------------------------*/

/*----------------------------
FRONT END/GAME TRACKING VALUES
----------------------------*/

//These are used to track the current state of the game
final int FRONT_END = 0;
final int IN_GAME = 1;
final int SETTINGS = 2;
final int GAME_OVER_SCREEN = 3;
final int TUTORIAL = 4;
//This is what we used to update the game state. Initialised to 0 as we want to start on the front end
int currentGameState = 0;

//We have a custon font so we need a var to store it in
PFont font;

//There are objects for each part of the game
Tutorial tutorial;
Frontend frontend;
Gameover gameover;
Settings settings;
Game game;

//We are using minim for the audio
Minim minim;

//AudioPlayer vars for the music
AudioPlayer backgroundMusic, click, wizard, place, win, lose;

/*---------------------------
IN GAME VALUES AND OBJECTS
---------------------------*/

//OBJECTS
///Player/AI Objects
Player humanPlayer;
Player aiPlayer;

//This is the AI brain, we just pass it a player and an opponent and it does the thinking
AIBrain aiBrain;

//Board is made of Pointmakers (start as blank markers)
Marker[][] gameboard;
//Preloading the markers so that we do not need to load an image ever time a new one is created
PImage[] markerImgs;

//HUMAN PLAYER TURN PROGRESS
//Storing all of the turn states as finals to save memory (rather than strings)
final int CHOOSE_ACTION = 0;
final int CHOOSE_CARD = 1;
final int CHOOSE_SQAURE = 2;
final int PLACE_SCORING_MARKER = 3;
final int REMOVE_MARKER = 4;
final int CHOOSE_SCORING_MARKER = 5;
final int CHOOSE_DEST = 6;
final int CHOOSE_DISCARD = 7;


//This int tracks what part of the turn the human player is in (starting at choose action and changing in line with the above finals)
int turnProgress = 0;

//DIFFICULTY
//We have the various states definded as finals so they take up less memory
final int EASY = 2;
final int MEDIUM = 4;
final int HARD = 8;

//This int changes depending on what difficutly we are on (and we compare with the above finals)
int difficulty = EASY;

//MISC.
//Tracks if it is the AIs turn or no
boolean AIturn = false;
//This is used to see if any marker has been played at all
boolean markerPlayed = false; 
