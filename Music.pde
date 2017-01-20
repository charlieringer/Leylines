//Functions for the music
//I chose not to put them in class becasue it did not seem worth it

//This is for playing the background music
void playBGMusic() {
  //If the sound is on and the background music is not currently playing
  if (settings.soundOn && !backgroundMusic.isPlaying()) {
    //Then play the music from the start
    backgroundMusic.play(0);
  } else if (!settings.soundOn && backgroundMusic.isPlaying()) {
    //If the music is not playing and we are currently playing some music then pause it
    backgroundMusic.pause();
  }
}

//Plays whenever you click
void playClick() {
  //If the SFXs are on
  if (settings.sfxOn) {
    //Play the sound from the start
    click.play(0);
  }
}

//Plays whenever a leypoint is played or removed
void playLeypoint() {
  //If the SFXs are on
  if (settings.sfxOn) {
    //Play the sound from the start
    place.play(0);
  }
}

//Plays whenever you a wizard is played or moved
void playWizard() {
  //If the SFXs are on
  if (settings.sfxOn) {
    //Play the sound from the start
    wizard.play(0);
  }
}

//Plays at the end of the game
void playEndgame() {
  //If the SFXs are on
  if (settings.sfxOn) {
    //And the player one
    if (humanPlayer.score > aiPlayer.score) {
      //Play the win sound from the start
      win.play(0);
    } else {
      //Otherwise play the lose sound
      lose.play(0);
    }
  }
}
