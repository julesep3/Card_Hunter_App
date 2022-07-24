import 'dart:io';
import 'dart:math';

import 'package:demo_1/model/gameplaysetup.dart';
import 'package:demo_1/model/player.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GamePlayScreen extends StatefulWidget {
  static const routeName = './gamePlayScreen';
  const GamePlayScreen(
      {required this.user, required this.gamePlaySetup, Key? key})
      : super(key: key);
  final User user;
  final GamePlaySetup gamePlaySetup;

  @override
  State<StatefulWidget> createState() {
    return _GamePlayState();
  }
}

class _GamePlayState extends State<GamePlayScreen> {
  late _Controller con;
  late String email;
  late String username;
  late String profilePicture;
  File? photo;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    username = widget.user.displayName ?? 'No username';
    profilePicture = widget.user.photoURL ?? '';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/gpt2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Appbar Below:
                AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 0,
                      ),
                      const Text('Game Play Tools'),
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        maxRadius: 18,
                        child: CircleAvatar(
                          maxRadius: 16,
                          backgroundImage: NetworkImage(profilePicture),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.black12,
                ),
                // Daybound/Nightbound features appear if user chooses to use feature
                widget.gamePlaySetup.dayboundNightbound
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          border: Border.all(color: Colors.white30),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Below: Row containing Night/Day Buttons and Day/Night status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: ElevatedButton(
                                    onPressed: con.setNightbound,
                                    child: const Text(
                                      'Night',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromARGB(255, 6, 35, 80),
                                    ),
                                  ),
                                ),
                                Text(
                                  con.getDayNightBound(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'average',
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                    onPressed: con.setDaybound,
                                    child: const Text(
                                      'Day',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color.fromARGB(
                                          255, 247, 218, 56),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Below: Row containing the Day/Night/General rules
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: con.seeNightRules,
                                    child: const Text(
                                      'Night Rules',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.withOpacity(0.4),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: con.seeRules,
                                    child: const Text(
                                      'General Rules',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.withOpacity(0.4),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: con.seeDayRules,
                                    child: const Text(
                                      'Day Rules',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                // Dice roll button area
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: con.rollDice,
                    child: const Text(
                      'Roll D20 Dice',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ),
                // Column of Players Dynamically Sized (displayed within Cards)
                Column(
                  children: [
                    for (int i = 0;
                        i < widget.gamePlaySetup.numberOfPlayers;
                        i++)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            border: Border.all(color: Colors.white30),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Card(
                            color: Colors.black.withOpacity(0.4),
                            // Column of rows for each stat dynamically optional (life total, poison counters, energy counters)
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Text(
                                    'Player ${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'average',
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                // Below: Life Total row
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 58.0,
                                  color: Colors.black.withOpacity(0.4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              con.decrementLifeTotal(i),
                                          child: const Text(
                                            '-',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Colors.red.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Life Total: ${con.players[i].startingLifeTotal}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              con.incrementLifeTotal(i),
                                          child: const Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.greenAccent
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Poison Counter appears if user chooses to use feature
                                widget.gamePlaySetup.poison
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 58.0,
                                        color: Colors.black.withOpacity(0.4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              child: ElevatedButton(
                                                onPressed: () => con
                                                    .decrementPoisonCounter(i),
                                                child: const Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Poison: ${con.players[i].poison}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: ElevatedButton(
                                                onPressed: () => con
                                                    .incrementPoisonCounter(i),
                                                child: const Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.greenAccent
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),
                                // Energy Counter appears if user chooses to use feature
                                widget.gamePlaySetup.energy
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 58.0,
                                        color: Colors.black.withOpacity(0.4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              child: ElevatedButton(
                                                onPressed: () => con
                                                    .decrementEnergyCounter(i),
                                                child: const Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Energy: ${con.players[i].energy}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: ElevatedButton(
                                                onPressed: () => con
                                                    .incrementEnergyCounter(i),
                                                child: const Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.greenAccent
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _GamePlayState state;
  List<UserCred> userCred = [];
  List<Player> players = [];
  Player player1 = Player();
  Player player2 = Player();
  Player player3 = Player();
  Player player4 = Player();
  Player player5 = Player();
  Player player6 = Player();
  int dayNightBound = 2;
  _Controller(this.state) {
    setPlayersStartLifeTotal();
  }

  // function to set initial values of each player's starting life total to the value specified by the user in the previous gameplaytools_screen.dart screen.
  void setPlayersStartLifeTotal() {
    player1.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    player2.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    player3.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    player4.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    player5.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    player6.startingLifeTotal = state.widget.gamePlaySetup.startingLifeTotal;
    players.add(player1);
    players.add(player2);
    players.add(player3);
    players.add(player4);
    players.add(player5);
    players.add(player6);
  }

  // function to set variable 'dayNightBound' to daybound value (1)
  void setDaybound() {
    dayNightBound = 1;
    state.render(() {});
  }

  // function to set variable 'dayNightBound' to nightbound value (0)
  void setNightbound() {
    dayNightBound = 0;
    state.render(() {});
  }

  // function to pop up the Magic the Gathering General Daybound/Nightbound Rules
  void seeRules() {
    showSnackBar(
      context: state.context,
      message:
          'GENERAL RULES\n\n1. - When the game starts, it is neither day nor night.\n\n2. - If it becomes day or night or if a daybound permanent enters the battlefield, track day/night for the rest of the game.',
      seconds: 15,
    );
  }

  // function to pop up the Magic the Gathering Nightbound Rules
  void seeNightRules() {
    showSnackBar(
      context: state.context,
      message:
          'NIGHTBOUND RULES\n\n1. - As it becomes night, transform all daybound permanents.\n\n2. - Permanents enter the battlefield nightbound.\n\n3. - If a player casts at least two spells during their own turn, it becomes day next turn.',
      seconds: 15,
    );
  }

  // function to pop up the Magic the Gathering Daybound Rules
  void seeDayRules() {
    showSnackBar(
      context: state.context,
      message:
          'DAYBOUND RULES\n\n1. - As it becomes day, transform all nightbound permanents.\n\n2. - If a player casts no spells during their own turn, it becomes night next turn.',
      seconds: 15,
    );
  }

  // function that returns a string of which day/night bound state the game is in
  String getDayNightBound() {
    if (dayNightBound == 0) {
      return 'Nightbound';
    } else if (dayNightBound == 1) {
      return 'Daybound';
    } else {
      return 'Neither Day/Night';
    }
  }

  // function to increment the life total
  void incrementLifeTotal(player) {
    players[player].startingLifeTotal++;
    state.render(() {});
  }

  // function to decrement the life total (can go below 0)
  void decrementLifeTotal(player) {
    players[player].startingLifeTotal--;
    state.render(() {});
  }

  // function to increment the poison counter
  void incrementPoisonCounter(player) {
    if (players[player].poison < 10) {
      players[player].poison++;
      state.render(() {});
    }
  }

  // function to decrement the poison counter (stops at 0)
  void decrementPoisonCounter(player) {
    if (players[player].poison > 0) {
      players[player].poison--;
      state.render(() {});
    }
  }

  // function to increment the energy counter
  void incrementEnergyCounter(player) {
    players[player].energy++;
    state.render(() {});
  }

  // function to decrement the energy counter (stops at 0)
  void decrementEnergyCounter(player) {
    if (players[player].energy > 0) {
      players[player].energy--;
      state.render(() {});
    }
  }

  // rolls dice - snackbar pops up showing the dice roll
  void rollDice() {
    Random random = new Random();
    int randomNumber = random.nextInt(19) + 1;
    showSnackBar(
      context: state.context,
      message: '~~ Shaking the dice ~~',
      seconds: 1,
    );
    showSnackBar(
      context: state.context,
      message: 'You rolled a $randomNumber',
      seconds: 3,
    );
  }
}
