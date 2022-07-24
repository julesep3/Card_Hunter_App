import 'dart:io';

import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/gameplaysetup.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/gameplay_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GamePlayToolsScreen extends StatefulWidget {
  static const routeName = './gamePlayToolsScreen';
  const GamePlayToolsScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _GamePlayToolsState();
  }
}

class _GamePlayToolsState extends State<GamePlayToolsScreen> {
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
    con.user = widget.user;
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
          child: Column(
            children: [
              // below: App Bar
              AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 0,
                    ),
                    const Text('Game Play Setup'),
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
              // Below: 'Number of Players' dropdown button
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                margin: const EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 58,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: null,
                      onChanged: (int? value) {
                        value == 0
                            ? con.setNumberOfPlayers(2)
                            : value == 1
                                ? con.setNumberOfPlayers(3)
                                : value == 2
                                    ? con.setNumberOfPlayers(4)
                                    : value == 3
                                        ? con.setNumberOfPlayers(5)
                                        : value == 4
                                            ? con.setNumberOfPlayers(6)
                                            : con.setNumberOfPlayers(0);
                      },
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      hint: const Center(child: Text('Number of Players')),
                      items: const [
                        DropdownMenuItem(
                          child: Center(
                            child: Text('2'),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('3'),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('4'),
                          ),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('5'),
                          ),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('6'),
                          ),
                          value: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Starting Life Total' dropdown button
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                margin: const EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 58,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: null,
                      onChanged: (int? value) {
                        value == 0
                            ? con.setStartingLifeTotal(10)
                            : value == 1
                                ? con.setStartingLifeTotal(20)
                                : value == 2
                                    ? con.setStartingLifeTotal(30)
                                    : value == 3
                                        ? con.setStartingLifeTotal(40)
                                        : value == 4
                                            ? con.setStartingLifeTotal(50)
                                            : value == 5
                                                ? con.setStartingLifeTotal(60)
                                                : value == 6
                                                    ? con.setStartingLifeTotal(
                                                        70)
                                                    : value == 7
                                                        ? con
                                                            .setStartingLifeTotal(
                                                                80)
                                                        : value == 8
                                                            ? con
                                                                .setStartingLifeTotal(
                                                                    90)
                                                            : value == 9
                                                                ? con
                                                                    .setStartingLifeTotal(
                                                                        100)
                                                                : con
                                                                    .setStartingLifeTotal(
                                                                        0);
                      },
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      hint: const Center(child: Text('Starting Life Total')),
                      items: const [
                        DropdownMenuItem(
                          child: Center(
                            child: Text('10'),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('20'),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('30'),
                          ),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('40'),
                          ),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('50'),
                          ),
                          value: 4,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('60'),
                          ),
                          value: 5,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('70'),
                          ),
                          value: 6,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('80'),
                          ),
                          value: 7,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('90'),
                          ),
                          value: 8,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('100'),
                          ),
                          value: 9,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Current Setup' display box
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: 200,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  border: Border.all(color: Colors.white30),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Setup',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Text(
                      'Number of Players: ${con.gamePlaySetup.numberOfPlayers}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Starting Life Total: ${con.gamePlaySetup.startingLifeTotal}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Poison: ' + con.getPoison(con.gamePlaySetup.poison),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Energy: ' + con.getEnergy(con.gamePlaySetup.energy),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Day/Night Tracking: ' +
                          con.getDayboundNightboundTracking(
                              con.gamePlaySetup.dayboundNightbound),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Below: 'Poison Counters' dropdown button
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 58,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: null,
                      onChanged: (int? value) {
                        value == 0
                            ? con.setPoisonCounter(false)
                            : value == 1
                                ? con.setPoisonCounter(true)
                                : con.setPoisonCounter(false);
                      },
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      hint: const Center(child: Text('Poison Counter On/Off')),
                      items: const [
                        DropdownMenuItem(
                          child: Center(
                            child: Text('OFF'),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('ON'),
                          ),
                          value: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Energy Counters' dropdown button
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                margin: const EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 58,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: null,
                      onChanged: (int? value) {
                        value == 0
                            ? con.setEnergyCounter(false)
                            : value == 1
                                ? con.setEnergyCounter(true)
                                : con.setEnergyCounter(false);
                      },
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      hint: const Center(child: Text('Energy Counter On/Off')),
                      items: const [
                        DropdownMenuItem(
                          child: Center(
                            child: Text('OFF'),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('ON'),
                          ),
                          value: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Day/Night Tracking' dropdown button
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 58,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: null,
                      onChanged: (int? value) {
                        value == 0
                            ? con.setDayboundNightboundTracking(false)
                            : value == 1
                                ? con.setDayboundNightboundTracking(true)
                                : con.setDayboundNightboundTracking(false);
                      },
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      hint: const Center(
                          child: Text('Day/Night Tracking On/Off')),
                      items: const [
                        DropdownMenuItem(
                          child: Center(
                            child: Text('OFF'),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text('ON'),
                          ),
                          value: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Begin Game' button
              ElevatedButton(
                onPressed: con.navToGamePlay,
                child: const Text(
                  'Begin Game',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _GamePlayToolsState state;
  GamePlaySetup gamePlaySetup = GamePlaySetup();
  _Controller(this.state) {}
  List<UserCred> userCred = [];
  late User user;

  // function to set the number of players
  void setNumberOfPlayers(players) {
    gamePlaySetup.numberOfPlayers = players;
    state.render(() {});
  }

  // function to set the starting life total
  void setStartingLifeTotal(life) {
    gamePlaySetup.startingLifeTotal = life;
    state.render(() {});
  }

  // function to set the poison counter option
  void setPoisonCounter(poison) {
    gamePlaySetup.poison = poison;
    state.render(() {});
  }

  // function to set the energy counter option
  void setEnergyCounter(energy) {
    gamePlaySetup.energy = energy;
    state.render(() {});
  }

  // function to set the day/night bound tracking option
  void setDayboundNightboundTracking(dayNight) {
    gamePlaySetup.dayboundNightbound = dayNight;
    state.render(() {});
  }

  // function to get a displayable String equivalent of day/night bound tracking
  String getDayboundNightboundTracking(dayNight) {
    if (dayNight == true) {
      return 'On';
    } else {
      return 'Off';
    }
  }

  // function to get a displayable String equivalent of poison option choice
  String getPoison(poison) {
    if (poison == true) {
      return 'On';
    } else {
      return 'Off';
    }
  }

  // function to get a displayable String equivalent of energy option choice
  String getEnergy(energy) {
    if (energy == true) {
      return 'On';
    } else {
      return 'Off';
    }
  }

  // function to navigate to game play screen (post game play setup)
  void navToGamePlay() async {
    // validate that number of players have been set
    if (gamePlaySetup.numberOfPlayers == 0) {
      showSnackBar(
        context: state.context,
        message:
            'Please choose the number of players before starting the game.',
      );
      // validate that starting life total has been set
    } else if (gamePlaySetup.startingLifeTotal == 0) {
      showSnackBar(
        context: state.context,
        message:
            'Please choose the starting life total before starting the game.',
      );
    } else {
      await Navigator.pushNamed(
        state.context,
        GamePlayScreen.routeName,
        arguments: {
          ArgKey.user: user,
          ArgKey.gamePlaySetup: gamePlaySetup,
        },
      );
    }
  }
}
