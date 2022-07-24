/*
 * Model Imports 
 */
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/set.dart';
import 'package:demo_1/model/scryfall_1.dart'; // nicol bolas
//import 'package:demo_1/model/usercred.dart';
//import 'package:demo_1/model/constant.dart';

/*
 * View Imports 
 */
import 'package:demo_1/viewscreen/adminsettings_screen.dart';
import 'package:demo_1/viewscreen/card_results_screen.dart';
import 'package:demo_1/viewscreen/communityhome_screen.dart';
import 'package:demo_1/viewscreen/gameplaytools_screen.dart';
import 'package:demo_1/viewscreen/list_results_screen.dart';
import 'package:demo_1/viewscreen/purchasehistory_screen.dart';
import 'package:demo_1/viewscreen/set_results_screen.dart';
import 'package:demo_1/viewscreen/usersettings_screen.dart';
import 'package:demo_1/viewscreen/wishlist_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:demo_1/viewscreen/deck_screen.dart';
import 'package:demo_1/viewscreen/inventory_screen.dart';
//import 'package:demo_1/viewscreen/results.dart';

/*
 * Controller Imports 
 */
import 'package:demo_1/controller/auth_controller.dart';
//import 'package:demo_1/controller/firestore_controller.dart';
/*
 * Everything else Imports 
 */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:toggle_switch/toggle_switch.dart';

/*
 * Returns list of cards from string URI
 */
Future<SetofCards> getSet(Future<String>? searchUri) async {
  String? search_uri = await searchUri;
  final url = Uri.parse(search_uri.toString());
  final response = await http.get(url);
  try {
    print('SET OF CARDS RESPONESE: ' +
        response.statusCode.toString() +
        search_uri.toString());
    if (response.statusCode == 200) {
      return SetofCards.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 *  Returns next page of cards as list from string URI
 */
Future<String> getPage(Future<String>? searchUri) async {
  String? search_uri = await searchUri;
  final url = Uri.parse(search_uri.toString());
  final response = await http.get(url);
  try {
    print('NEXT PAGE RESPONSE: ' +
        response.statusCode.toString() +
        search_uri.toString());
    if (response.statusCode == 200) {
      return SetofCards.fromJson(jsonDecode(response.body)).nextPage.toString();
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 *  Returns whether page of cards has more cards
 */
Future<bool> getNext(Future<String>? searchUri) async {
  String? search_uri = await searchUri;
  final url = Uri.parse(search_uri.toString());
  final response = await http.get(url);
  try {
    print('HAS MORE RESPONSE: ' +
        response.statusCode.toString() +
        search_uri.toString());
    if (response.statusCode == 200) {
      return SetofCards.fromJson(jsonDecode(response.body)).hasMore;
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 * Returns set blob from setcode as string 
 */
Future<String> getSearchUri(Future<String>? setName) async {
  String? name = await setName;
  final url = Uri.parse('https://api.scryfall.com/sets/' + name.toString());

  final response = await http.get(url);
  try {
    if (name == "0") {
      return "";
    } else {
      print('SET URI RESPONSE: ' +
          response.statusCode.toString() +
          ' https://api.scryfall.com/sets/' +
          name.toString());
      if (response.statusCode == 200) {
        return SetScryfall.fromJson(jsonDecode(response.body)).searchUri;
      } else {
        throw Exception('HTTP request response status is ' +
            response.statusCode.toString());
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 * Returns status code for error handling 
 */
Future<String> getCardError(String cardName) async {
  final url =
      Uri.parse('https://api.scryfall.com/cards/named?fuzzy=' + cardName);

  final response = await http.get(url);
  try {
    print('CARD RESPONSE: ' +
        response.statusCode.toString() +
        ' https://api.scryfall.com/cards/named?fuzzy=' +
        cardName);
    if (response.statusCode == 200) {
      return Scryfall.fromJson(jsonDecode(response.body)).object.toString();
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    return "error";
  }
}

/*
 * Returns card blob as Scryfall from card name as string 
 */
Future<Scryfall> getCard(String cardName) async {
  final url =
      Uri.parse('https://api.scryfall.com/cards/named?fuzzy=' + cardName);

  final response = await http.get(url);
  try {
    if (Scryfall.fromJson(jsonDecode(response.body)).object == "error") {
      return throw Exception(
          'False Positive:HTTP request response status is actually 404');
    } else {
      print('CARD RESPONSE: ' +
          response.statusCode.toString() +
          ' https://api.scryfall.com/cards/named?fuzzy=' +
          cardName);
      if (response.statusCode == 200) {
        return Scryfall.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('HTTP request response status is ' +
            response.statusCode.toString());
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 * Returns set code as string from set name as string 
 */
Future<String> getSetCode(String setName) async {
  final url =
      Uri.parse('https://api.magicthegathering.io/v1/sets?name=' + setName);

  final response = await http.get(url);
  print('SET CODE RESPONSE: ' +
      response.statusCode.toString() +
      ' https://api.magicthegathering.io/v1/sets?name=' +
      setName);
  try {
    if (SetQuery.fromJson(jsonDecode(response.body)).sets.isEmpty) {
      return SetQuery.fromJson(jsonDecode(response.body))
          .sets
          .length
          .toString();
    } else {
      if (response.statusCode == 200) {
        return SetQuery.fromJson(jsonDecode(response.body))
            .sets
            .elementAt(0)
            .code;
      } else {
        throw Exception('HTTP request response status is ' +
            response.statusCode.toString());
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 * Returns number of sets in list of sets 
 */
Future<int> getSetLength(String setName) async {
  final url =
      Uri.parse('https://api.magicthegathering.io/v1/sets?name=' + setName);

  final response = await http.get(url);
  print('SET CODE RESPONSE: ' +
      response.statusCode.toString() +
      ' https://api.magicthegathering.io/v1/sets?name=' +
      setName);
  try {
    if (response.statusCode == 200) {
      return SetQuery.fromJson(jsonDecode(response.body)).sets.length;
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

/*
 * Returns list of sets as SetQuery from set name as String 
 */
Future<SetQuery> getSetList(String setName) async {
  final url =
      Uri.parse('https://api.magicthegathering.io/v1/sets?name=' + setName);

  final response = await http.get(url);
  print('SET CODE RESPONSE: ' +
      response.statusCode.toString() +
      ' https://api.magicthegathering.io/v1/sets?name=' +
      setName);
  try {
    if (response.statusCode == 200) {
      return SetQuery.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  // Controllers
  final TextEditingController _controller = TextEditingController();
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // User stuff
  late String email;
  late String username;
  late String profilePicture;

  // Chad's filthy state globals
  late String togg;
  late List<bool> isSelected;
  late bool val;

  // API variables
  Future<SetQuery>? setList;
  Future<Scryfall>? searchCard;
  Future<SetofCards>? searchSet;
  Future<String>? searchUri;
  Future<String>? setCode;
  Future<String>? cardError;

  @override
  void initState() {
    super.initState();
    // Initializations
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    username = widget.user.displayName ?? 'No username';
    profilePicture = widget.user.photoURL ?? 'No profile picture';
    togg = 'Set';
    isSelected = [false, true];
    val = false;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        // Below: Drawer for user and admin features
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/cardback.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                // below: Drawer header
                Container(
                  color: Colors.black26,
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    accountEmail: Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white12,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profilePicture),
                        backgroundColor: Colors.purpleAccent,
                        maxRadius: 33,
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                  ),
                ),
                // Below: Drawer buttons
                Constant.adminEmails.contains(email)
                    ? ListTile(
                        title: const Text('Administrative Settings'),
                        leading: const Icon(Icons.settings),
                        onTap: con.navToAdminSettings,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                ListTile(
                  title: const Text('User Settings'),
                  leading: const Icon(Icons.settings),
                  onTap: con.navToSettings,
                ),
                ListTile(
                  title: const Text('Game Play Tools'),
                  leading: const Icon(Icons.blur_on),
                  onTap: con.navToGamePlayTools,
                ),
                ListTile(
                  title: const Text('Sign Out'),
                  leading: const Icon(Icons.exit_to_app_rounded),
                  onTap: con.signOut,
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/HomeScreen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 0,
                        ),
                        const Text('Card Hunter Home'),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 18,
                          child: CircleAvatar(
                            maxRadius: 16,
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.black12,
                    // centerTitle: true,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.white30),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Search For a ' + togg + ':',
                            style: const TextStyle(
                              fontFamily: 'average',
                              fontSize: 24,
                            ),
                          ),
                          TextField(
                            controller: _controller,
                            decoration:
                                const InputDecoration(hintText: 'Enter Title'),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    /*
                                     * If cardmode is selected, 
                                     */
                                    if (val) {
                                      // Single card object from scryfall
                                      searchCard = getCard(_controller.text
                                          .replaceAll(' ', '+'));
                                      cardError = getCardError(_controller.text
                                          .replaceAll(' ', '+'));
                                      // Error handling
                                      if (await con.nullCardCheck(cardError)) {
                                        showSnackBar(
                                          context: context,
                                          message: 'Card Does Not Exist',
                                          seconds: 1,
                                        );
                                      } else {
                                        // Navigate to Card display
                                        con.goToResultsCard(searchCard);
                                      }
                                      /*
                                       * Then setmode is selected 
                                       */
                                    } else {
                                      // Multi set object from mtg.io
                                      Future<int>? len = getSetLength(
                                          _controller.text
                                              .replaceAll(' ', '+'));

                                      if (await len > 1) {
                                        setList = getSetList(_controller.text
                                            .replaceAll(' ', '+'));
                                        //navigate to list of sets page
                                        con.goToResulsSetList(setList);
                                      } else if (await len == 1) {
                                        setCode = getSetCode(_controller.text
                                            .replaceAll(' ', '+'));
                                        // Single set objact from scryfall
                                        searchUri = getSearchUri(setCode);
                                        // Multi card object from scryfall
                                        searchSet = getSet(searchUri);
                                        // Parameter variables
                                        Future<bool> hasNext =
                                            getNext(searchUri);
                                        Future<String> nextPage =
                                            getPage(searchUri);
                                        // navigate to Set Display
                                        con.goToResultsSet(
                                            searchSet, hasNext, nextPage);
                                        // Error handling
                                      } else if (await len == 0) {
                                        showSnackBar(
                                          context: context,
                                          message: 'Set Does Not Exist',
                                          seconds: 1,
                                        );
                                      }
                                    }

                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => const GetProjectScreen(),
                                      settings: RouteSettings(arguments: searchCard)));*/
                                    setState(() {});
                                  },
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                ToggleButtons(
                                  children: const <Widget>[
                                    Icon(Icons.circle),
                                    Icon(Icons.circle)
                                  ],
                                  borderRadius: BorderRadius.circular(60),
                                  /*
                                   * Switches modes 
                                   */
                                  onPressed: (int index) {
                                    if (index == 0) {
                                      render(() {
                                        con.switchMode();
                                      });
                                    } else if (index == 1) {
                                      render(() {
                                        con.switchMode();
                                      });
                                    }
                                  },
                                  isSelected: isSelected,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.white30),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: con.goToCommunity,
                          child: const Text(
                            'Community',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: con.deckScreen,
                          child: const Text(
                            'My Deck',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: con.wishlistScreen,
                          child: const Text(
                            'My Wishlist',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: con.inventoryScreen,
                          child: const Text(
                            'My Inventory',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: con.purchaseHistoryScreen,
                          child: const Text(
                            'Purchase History',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _HomeState state;
  _Controller(this.state) {
    user = state.widget.user;
  }
  late User _user;

  User get user => _user;

  set user(User user) {
    _user = user;
  }

  void goToCommunity() async {
    await Navigator.pushNamed(
      state.context,
      CommunityHomeScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
      },
    );
  }

/*
 * Navigates to card_results_screen where user sees individual card info 
 */
  void goToResultsCard(Future<Scryfall>? searchCard) async {
    await Navigator.pushNamed(
      state.context,
      CardResultsScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.cardArg: searchCard,
      },
    );
  }

/*
 * Navigates to set_results_screen where user 
 * sees page of cards.
 */
  void goToResultsSet(Future<SetofCards>? searchSet, Future<bool> hasNext,
      Future<String> nextPage) async {
    bool next = await hasNext;
    String page = await nextPage;
    await Navigator.pushNamed(
      state.context,
      SetScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.setArg: searchSet,
        ArgKey.hasNext: next,
        ArgKey.nextUri: page
      },
    );
  }

/*
 * Navigates to list_results_screen where you can see list of sets queried 
 */
  void goToResulsSetList(Future<SetQuery>? setList) async {
    await Navigator.pushNamed(
      state.context,
      ListSetScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.setArg: setList,
      },
    );
  }

/*
 *  Switches mode for toggle
 */
  void switchMode() {
    for (int index = 0; index < state.isSelected.length; index++) {
      state.isSelected[index] = !state.isSelected[index];
    }
    state.val = !state.val;
    if (state.val) {
      state.togg = 'Card';
    } else {
      state.togg = 'Set';
    }
  }

  void inventoryScreen() async {
    await Navigator.pushNamed(
      state.context,
      InventoryScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }

  void wishlistScreen() async {
    await Navigator.pushNamed(
      state.context,
      WishlistScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }

  void purchaseHistoryScreen() async {
    await Navigator.pushNamed(
      state.context,
      PurchaseHistoryScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }

  void deckScreen() async {
    await Navigator.pushNamed(
      state.context,
      DeckScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }

/*
 * Checks if card does not exist 
 */
  Future<bool> nullCardCheck(Future<String>? target) async {
    String? val = await target;
    if (val == "error") {
      //     print("SET DOES NOT EXIST");
      return true;
    } else {
      return false;
    }
  }

  // Below: functions for Hamburger Menu Buttons

  // function to navigate to user settings
  void navToSettings() async {
    await Navigator.pushNamed(
      state.context,
      UserSettingsScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
  }

  // function to navigate to game play tools
  void navToGamePlayTools() async {
    await Navigator.pushNamed(
      state.context,
      GamePlayToolsScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
  }

  // function to navigate to admin user settings
  // (accessible only to 'admin' and 'super' users)
  void navToAdminSettings() async {
    await Navigator.pushNamed(
      state.context,
      AdminSettingsScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
  }

  // function to sign out of the app
  Future<void> signOut() async {
    try {
      await AuthController.signOut();
      // Pop out of drawer
      Navigator.of(state.context).pop();
      // Pop out of home_screen
      Navigator.of(state.context).pop();
      showSnackBar(
        context: state.context,
        seconds: 10,
        message:
            'You have successfully signed out.\nThank you for using Card Hunter!',
      );
    } catch (e) {
      if (Constant.devMode) print('=============== Sign Out Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Sign Out Error: $e',
      );
    }
  }
}
