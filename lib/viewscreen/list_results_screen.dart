/*
 * Model Imports 
 */
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/set.dart';
import 'package:demo_1/model/scryfall_1.dart';
import 'package:demo_1/model/tokens.dart';
import 'package:demo_1/model/usercred.dart';
//import 'package:demo_1/model/magic_card.dart';
/*
 * View Imports 
 */
import 'package:demo_1/viewscreen/set_results_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
//import 'package:demo_1/viewscreen/wishlist_screen.dart';
//import 'package:demo_1/viewscreen/card_results_screen.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter/scheduler.dart';
//import 'package:url_launcher/url_launcher.dart';

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
 * Returns set blob from setcode as string 
 */
Future<String> getSearchUri(String setName) async {
  final url = Uri.parse('https://api.scryfall.com/sets/' + setName);

  final response = await http.get(url);
  try {
    if (setName == "0") {
      return "";
    } else {
      /*print('SET URI RESPONSE: ' +
          response.statusCode.toString() +
          ' https://api.scryfall.com/sets/' +
          setName.toString());*/
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
 * Returns image uri from setcode as string
 */
Future<String> getImageUri(String setName) async {
  //String? name = await setName;
  final url = Uri.parse('https://api.scryfall.com/sets/' + setName.toString());

  final response = await http.get(url);
  try {
    if (setName == "0") {
      return "";
    } else {
      /*print('SET URI RESPONSE: ' +
          response.statusCode.toString() +
          ' https://api.scryfall.com/sets/' +
          setName.toString());*/
      if (response.statusCode == 200) {
        return SetScryfall.fromJson(jsonDecode(response.body))
            .iconSvgUri
            .toString();
      } else {
        throw Exception('HTTP request response status is ' +
            response.statusCode.toString());
      }
    }
  } catch (e) {
    throw Exception(e);
  }
}

class ListSetScreen extends StatefulWidget {
  static const routeName = '/ListSetScreen';
  const ListSetScreen({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() {
    return _ListSetState();
  }
}

class _ListSetState extends State<ListSetScreen> {
  // Controllers
  late _Controller con;

  // API variables
  Future<Scryfall>? selectedCard;
  Future<SetofCards>? searchSet;
  Future<String>? searchUri;
  Future<String>? setCode;

  // User variables
  late String email;
  late String username;
  late String profilePicture;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);

    email = widget.user.email ?? 'No email';
    username = widget.user.displayName ?? 'No username';
    profilePicture = widget.user.photoURL ?? 'No profile picture';
    con.getUsersCredentials();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    //final searchCard =ModalRoute.of(context)!.settings.arguments as Future<Scryfall>;
    Object? args = ModalRoute.of(context)?.settings.arguments;
    var argument = args as Map;
    var user = argument[ArgKey.user];
    // bool hasNext = argument[ArgKey.hasNext];
    //String currentPage = argument[ArgKey.nextUri];
    final currentSet = argument[ArgKey.setArg] as Future<SetQuery>;

    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
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
            'Showing Results For...',
            style: TextStyle(
              fontFamily: 'Average',
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder<SetQuery>(
            future: currentSet,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /*
                 *  Primes useful set requests (SetScryfall) by retrieving set code
                 *  from a limited request (SetQuery) 
                 */
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.sets.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data!.totalCards);

                      Future<String> img = getImageUri(
                          snapshot.data!.sets.elementAt(index).code.toString());
                      /*
                       * Displays set icon as svg and set name 
                       */
                      return Row(
                        children: [
                          FutureBuilder<String>(
                              future: img,
                              builder: (context, snap) {
                                /*
                                 * Shows set icon 
                                 */
                                if (snap.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.network(
                                      snap.data.toString(),
                                      width: 50,
                                      height: 50,
                                    ),
                                  );
                                } else if (snap.hasError) {
                                  return const Text(
                                    'Either the set does not exist or the search is too vague',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator();
                              }),
                          /*
                               * Shows set name 
                               */
                          Flexible(
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                              /*
                               * navigates to set_results_screen where set of
                               * cards are displayed
                               */
                              onPressed: () async {
                                // Single set objact from scryfall
                                searchUri = getSearchUri(snapshot.data!.sets
                                    .elementAt(index)
                                    .code
                                    .toString());
                                // Multi card object from scryfall
                                searchSet = getSet(searchUri);
                                // Parameter variables
                                Future<bool> hasNext = getNext(searchUri);
                                Future<String> nextPage = getPage(searchUri);
                                // navigate to Set Display
                                con.goToResultsSet(
                                    searchSet, hasNext, nextPage);
                              },
                              child: Text(
                                snapshot.data!.sets
                                    .elementAt(index)
                                    .name
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'average',
                                ),
                              ),
                            ),
                          ),
                        ],
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
  _ListSetState state;
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
 * Navigates users to set that is chosen 
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
