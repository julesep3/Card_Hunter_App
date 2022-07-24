class GamePlaySetup {
  int numberOfPlayers;
  int startingLifeTotal;
  bool poison;
  bool energy;
  bool dayboundNightbound;

  GamePlaySetup({
    this.numberOfPlayers = 0,
    this.startingLifeTotal = 0,
    this.poison = false,
    this.energy = false,
    this.dayboundNightbound = false,
  });
}
