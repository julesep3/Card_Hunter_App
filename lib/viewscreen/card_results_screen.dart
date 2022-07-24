/*
 * Model Imports 
 */
import 'package:demo_1/model/scryfall_1.dart';
import 'package:demo_1/model/tokens.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/magic_card.dart';
import 'package:demo_1/model/price_list.dart';
/*
 * View Imports 
 */
//import 'package:demo_1/viewscreen/wishlist_screen.dart';
/*
 * Controller Imports 
 */
import 'package:demo_1/controller/firestore_controller.dart';
//import 'package:firebase_auth/firebase_auth.dart';
/*
 * Everything else Imports 
 */
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class CardResultsScreen extends StatefulWidget {
  static const routeName = '/GetProjectScreen';
  const CardResultsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardResultsState();
  }
}

class _CardResultsState extends State<CardResultsScreen> {
  // Controllers
  late _Controller con;
  // Chad's filthy globals
  List<bool> isChecked = [true, true, true, true, true, true];
  late bool togg;
  late bool doNotShow;

  @override
  void initState() {
    // Initializations
    con = _Controller(this);
    super.initState();
    togg = false;
    doNotShow = false;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    /*
     * Grabbing arguments from modal 
     */
    Object? args = ModalRoute.of(context)
        ?.settings
        .arguments; //final searchCard =ModalRoute.of(context)!.settings.arguments as Future<Scryfall>; // old way of grabbing arguments
    var argument = args as Map;
    var user = argument[ArgKey.user];
    final searchCard = argument[ArgKey.cardArg] as Future<Scryfall>;
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
          child: FutureBuilder<Scryfall>(
            future: searchCard,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /*
                 * List of prices seen under the card image 
                 */
                List<String> prices = [
                  '\$' + snapshot.data!.prices!.usd.toString() + ' (Common)',
                  '\$' + snapshot.data!.prices!.usdFoil.toString() + ' (Foil)',
                  '\$' +
                      snapshot.data!.prices!.usdEtched.toString() +
                      ' (Etched)',
                  '\€' + snapshot.data!.prices!.eur.toString() + ' (Common)',
                  '\€' + snapshot.data!.prices!.eurFoil.toString() + ' (Foil)',
                  'Tix ' + snapshot.data!.prices!.tix.toString()
                ];
                // Purges any prices in the list that are null
                prices.removeWhere((item) => item.contains('null'));
                /*
                 * Opens Snackbar for doublesided cards 
                 */
                if (snapshot.data!.layout == "transform" && !doNotShow) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    /* //Old Snackbar
                    showSnackBar(
                      context: context,
                      message: 'Tap on card to flip',
                      seconds: 1,
                    );*/
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('Tap on card to flip'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Color.fromARGB(255, 48, 48, 48),
                    ));
                    doNotShow = !doNotShow;
                  });
                }
                /*
                 * Shows card, prices, and other functionalities
                 */
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    /*
                     * Displays card image 
                     */
                    GestureDetector(
                      child: Container(
                        width: 1000,
                        height: 500,
                        color: Colors.black,
                        child: Center(
                          child: Image(
                            image: //(snapshot.data!.cardFaces!.isEmpty)
                                /*
                             * If card is single sided 
                             */
                                (snapshot.data!.layout != "transform")
                                    /*
                                 * Then show normal image 
                                 */
                                    ? NetworkImage(
                                        snapshot.data!.imageUris.borderCrop!)
                                    /*
                                         * Else if toggle is true 
                                         */
                                    : (togg)
                                        /*
                                     * show front side of card 
                                     */
                                        ? NetworkImage(snapshot.data!.cardFaces!
                                            .elementAt(0)
                                            .imageUris!
                                            .borderCrop!)
                                        /* 
                                             * Show back side of card
                                             */
                                        : NetworkImage(snapshot.data!.cardFaces!
                                            .elementAt(1)
                                            .imageUris!
                                            .borderCrop!),
                          ),
                        ),
                      ),
                      /*
                       * flips card image 
                       */
                      onTap: () {
                        if (snapshot.data!.layout != "transform") {
                          return;
                        } else {
                          togg = !togg;
                          setState(() {});
                        }
                      },
                    ),
                    /*
                     * shows prices of cards 
                     */
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: prices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Visibility(
                          visible: isChecked[index],
                          child: ListTile(
                            tileColor: Colors.black,
                            title: Text(
                              prices[index],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              /*
                               * Open internet browser to respective website. 
                               */
                              con.launchURL(
                                (prices[index].contains('\$')
                                    ? snapshot.data!.purchaseUris!.tcgplayer
                                    : (prices[index].contains('\€')
                                        ? snapshot
                                            .data!.purchaseUris!.cardmarket
                                        : snapshot
                                            .data!.purchaseUris!.cardhoarder)),
                              );
                            },
                            /*trailing: Wrap(spacing: 10, children: <Widget>[
                              // ignore: unnecessary_new
                              new IconButton(
                                icon: Icon(Icons.shopping_bag_sharp),
                                onPressed: () {
                                  con.addPriceList(searchCard, user.email);
                                },
                              ),
                            ]),*/
                          ),
                        );
                      },
                    ),
                    con.addCard(searchCard, user.email),
                    con.addPriceList(searchCard, user.email),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'Either the card does not exist or the search is too vague',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        /*
         * hamberger menu on right side of screen
         */
        endDrawer: Drawer(
          child: FutureBuilder<Scryfall>(
            future: searchCard,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /*
                 * List of prices for hamberger menu 
                 */
                List<String> prices = [
                  '\$' + snapshot.data!.prices!.usd.toString() + ' (Common)',
                  '\$' + snapshot.data!.prices!.usdFoil.toString() + ' (Foil)',
                  '\$' +
                      snapshot.data!.prices!.usdEtched.toString() +
                      ' (Etched)',
                  '\€' + snapshot.data!.prices!.eur.toString() + ' (Common)',
                  '\€' + snapshot.data!.prices!.eurFoil.toString() + ' (Foil)',
                  'Tix ' + snapshot.data!.prices!.tix.toString()
                ];

                List<String> text = [
                  "USD Common",
                  "USD Foil",
                  "USD Etched",
                  "Euro Common",
                  "Euro Foil",
                  "Tix"
                ];

                /*
                 * Removes any prices that are null in card blob
                 */
                for (int index = prices.length - 1; index >= 0; index--) {
                  if (prices[index].contains('null')) {
                    prices.removeAt(index);
                    text.removeAt(index);
                    // might break

                  }
                }
                /*
                 * Displays checkmark boxes corresponding to non-null
                 * prices 
                 */
                return ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: text.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            title: Text(
                              text[index],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            value: isChecked[index], //  <-- leading Checkbox
                            /*
                             * checkmark box is checked (or unchecked) 
                             */
                            onChanged: (value) {
                              setState(
                                () {
                                  //print("index " + index.toString());
                                  // Condition and visibility are updated
                                  isChecked[index] = value!;
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text(
                    'Either card does not exist or search is too vague');
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
  _CardResultsState state;
  _Controller(this.state);

  /*void goToWishlist() async {
    await Navigator.pushNamed(
      state.context,
      WishlistScreen.routeName,
    );
    state.render(() {});
  }*/

  /*
   *  Opens web browser to respective site
   */
  void launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

//uses the future Scryfall and builds the MagicCard to upload to firebase.  the
//user's email is used to ID the cards as theirs.  If a card exists for that user
//already, the card's numOwned is incremented instead and firebase updated
  Widget addCard(Future<Scryfall>? searchCard, String email) {
    List<MagicCard> cardList = [];
    return FutureBuilder<Scryfall>(
        future: searchCard,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.withOpacity(0.4),
              ),
              child: const Text('Add to Inventory'),
              onPressed: () async {
                cardList = await FirestoreController.getCards(email);
                int count = 0;
                for (var e in cardList) {
                  print('pass #' + count.toString());
                  if (e.cid == snapshot.data!.id && e.email == email) {
                    e.numOwned++;
                    await FirestoreController.updateCardInfo(
                        docId: e.docId.toString(),
                        updateInfo: {MagicCard.NUMOWNED: e.numOwned});
                    inventoryScreen();
                    return;
                  }
                }
                FirestoreController.addCard(
                  card: MagicCard(
                      email: email,
                      scryfallUri: snapshot.data!.scryfallUri!,
                      cid: snapshot.data!.id!,
                      name: snapshot.data!.name!,
                      typeLine: snapshot.data!.typeLine,
                      power: snapshot.data!.power,
                      toughness: snapshot.data!.toughness,
                      rarity: snapshot.data!.rarity!,
                      colorIdentity: snapshot.data!.colorIdentity!,
                      cmc: snapshot.data!.cmc,
                      numDeck: 0,
                      numOwned: 1,
                      inDeck: '',
                      imageURL: snapshot.data!.imageUris.large,
                      manaCost: snapshot.data!.manaCost),
                );

                inventoryScreen();
              },
            );
          } else {
            return const SizedBox(
              height: 1,
            );
          }
        }));
  }

  void inventoryScreen() {
    state.render(() {
      Navigator.of(state.context).pop();
    });
  }

  void wishlistScreen() {
    state.render(() {
      Navigator.of(state.context).pop();
    });
  }

  Widget addPriceList(Future<Scryfall>? searchCard, String email) {
    List<PriceList> priceList = [];
    return FutureBuilder<Scryfall>(
        future: searchCard,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return IconButton(
              icon: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                priceList = await FirestoreController.getPrices(email);
                int count = 0;
                for (var e in priceList) {
                  print('pass #' + count.toString());
                  if (e.cid == snapshot.data!.id && e.email == email) {
                    e.numOwned++;
                    await FirestoreController.updatePriceInfo(
                        docId: e.docId.toString(),
                        updateInfo: {PriceList.NUMOWNED: e.numOwned});
                    wishlistScreen();
                    return;
                  }
                }
                FirestoreController.addPrice(
                  plist: PriceList(
                      email: email,
                      scryfallUri: snapshot.data!.scryfallUri!,
                      cid: snapshot.data!.id!,
                      name: snapshot.data!.name!,
                      imageURL: snapshot.data!.imageUris.large,
                      //prices: snapshot.data!.prices,
                      numOwned: 1),
                );
                wishlistScreen();
                //print("done");
              },
            );
          } else {
            return const SizedBox(
              height: 1,
            );
          }
        }));
  }
}
