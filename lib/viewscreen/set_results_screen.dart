/*
 * Model Imports 
 */
import 'package:demo_1/model/scryfall_1.dart';
import 'package:demo_1/model/tokens.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/usercred.dart';
//import 'package:demo_1/model/magic_card.dart';
//import 'package:demo_1/model/set.dart';
/*
 * View Imports 
 */
import 'package:demo_1/viewscreen/card_results_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
//import 'package:demo_1/viewscreen/wishlist_screen.dart';
//import 'package:demo_1/viewscreen/results.dart';
/*
 * Controller Imports 
 */
import 'package:demo_1/controller/firestore_controller.dart';
/*
 * Everything else Imports 
 */
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/scheduler.dart';
//import 'package:url_launcher/url_launcher.dart';

/*
 * Returns list of cards from string URI
 */
Future<SetofCards> getSet(String? searchUri) async {
  final url = Uri.parse(searchUri.toString());
  final response = await http.get(url);
  try {
    print('SET OF CARDS RESPONESE: ' +
        response.statusCode.toString() +
        searchUri.toString());
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
Future<String> getPage(String? searchUri) async {
  final url = Uri.parse(searchUri.toString());
  final response = await http.get(url);
  try {
    print('NEXT PAGE RESPONSE: ' +
        response.statusCode.toString() +
        searchUri.toString());
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
Future<bool> getNext(String? searchUri) async {
  final url = Uri.parse(searchUri.toString());
  final response = await http.get(url);
  try {
    print('HAS MORE RESPONSE: ' +
        response.statusCode.toString() +
        searchUri.toString());
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
 * Returns card blob from a card name as a string
 */
Future<Scryfall> getCard(String cardName) async {
  final url =
      Uri.parse('https://api.scryfall.com/cards/named?fuzzy=' + cardName);

  final response = await http.get(url);
  try {
    print('CARD RESPONSE: ' +
        response.statusCode.toString() +
        ' https://api.scryfall.com/cards/named?fuzzy=' +
        cardName);
    if (response.statusCode == 200) {
      return Scryfall.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'HTTP request response status is ' + response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}

class SetScreen extends StatefulWidget {
  static const routeName = '/SetScreen';
  const SetScreen({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() {
    return _SetState();
  }
}

class _SetState extends State<SetScreen> {
  // Controllers
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // API variables
  Future<Scryfall>? selectedCard;
  Future<SetofCards>? searchSet;
  Future<String>? searchUri;
  Future<String>? setCode;

  // User variables
  late String email;
  late String username;
  late String profilePicture;

  // Chad's Filthy globals
  bool togg = false;

  @override
  void initState() {
    super.initState();
    // Initializations
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    username = widget.user.displayName ?? 'No username';
    profilePicture = widget.user.photoURL ?? 'No profile picture';
    con.getUsersCredentials();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    /*
     * Grab arguments from modal
     */
    //final searchCard =ModalRoute.of(context)!.settings.arguments as Future<Scryfall>;
    Object? args = ModalRoute.of(context)?.settings.arguments;
    var argument = args as Map;
    var user = argument[ArgKey.user];
    bool hasNext = argument[ArgKey.hasNext];
    String currentPage = argument[ArgKey.nextUri];
    final currentSet = argument[ArgKey.setArg] as Future<SetofCards>;

    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              curToken = '';
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Hold To Select',
            style: TextStyle(
              fontFamily: 'Average',
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: <Widget>[
            /*
             * Next Page button on appbar
             */
            Visibility(
              visible: hasNext,
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  searchSet = getSet(currentPage);
                  // Parameter variables
                  Future<bool>? hasNext = getNext(currentPage);
                  Future<String>? nextPage = getPage(currentPage);
                  // navigate to Set Display
                  con.goToResultsSet(searchSet, hasNext, nextPage);
                },
                child: const Text(
                  "Next Page",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'average',
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          /*
           * List of cards displayed to user 
           */
          child: FutureBuilder<SetofCards>(
            future: currentSet,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data!.totalCards);

                      return GestureDetector(
                        /*
                         * Navigates user to card_results_screen
                         */
                        onLongPress: () {
                          print(snapshot.data!.data
                                  .elementAt(index)
                                  .name
                                  .toString() +
                              " was tapped");

                          selectedCard = getCard(snapshot.data!.data
                              .elementAt(index)
                              .name
                              .toString()
                              .replaceAll(' ', '+'));
                          con.goToResultsCard(selectedCard);
                        },
                        /*
                         * Flips card image if card is doubled sided transform 
                         */
                        onTap: () {
                          if (snapshot.data!.data.elementAt(index).layout !=
                              "transform") {
                            return;
                          } else {
                            togg = !togg;
                            setState(() {});
                          }
                        },
                        /*
                         * Displays Card image to user 
                         */
                        child: Container(
                          width: 1000,
                          height: 500,
                          color: Colors.black,
                          child: Center(
                            child: Image(
                              /*
                               * If card is not doublesided
                               */
                              image: (snapshot.data!.data
                                          .elementAt(index)
                                          .layout !=
                                      "transform")
                                  /*
                                       * Then show card image 
                                       */
                                  ? NetworkImage(snapshot.data!.data
                                      .elementAt(index)
                                      .imageUris
                                      .borderCrop!)
                                  /*
                                  * Else If toggle is true
                                  */
                                  : (togg)
                                      /*
                                       * Then show front side 
                                       */
                                      ? NetworkImage(snapshot.data!.data
                                          .elementAt(index)
                                          .cardFaces!
                                          .elementAt(0)
                                          .imageUris!
                                          .borderCrop!)
                                      /*
                                       * Else show back side
                                       */
                                      : NetworkImage(snapshot.data!.data
                                          .elementAt(index)
                                          .cardFaces!
                                          .elementAt(1)
                                          .imageUris!
                                          .borderCrop!),
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Text(
                  'Either the set does not exist or the search is too vague',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SetState state;
  _Controller(this.state) {
    user = state.widget.user;
  }
  late User _user;
  List<UserCred> userCredList = [];

  User get user => _user;

  set user(User user) {
    _user = user;
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
 * Navigates to the same screen (set_results_screen) where user 
 * sees next page of cards.
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

  void getUsersCredentials() async {
    try {
      userCredList.clear();
      userCredList = await FirestoreController.getUserCred(state.email);
      state.profilePicture = userCredList[0].profilePicURL;
    } catch (e) {
      if (Constant.devMode) print('=============== Get User Cred Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Get User Cred Error: $e',
      );
    }
    state.render(() {});
  }
}
