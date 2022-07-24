import 'package:demo_1/controller/firestore_controller.dart';
//import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/magic_card.dart';
//import 'package:demo_1/model/usercred.dart';
//import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/deck.dart';

class DeckScreen extends StatefulWidget {
  static const routeName = '/DeckScreen';
  const DeckScreen({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() {
    return _DeckState();
  }
}

//this class displays all card images in a scrollable row.  The screen can be changed to
//show certain decks' cards or all cards in inventory.  Cards are added to decks with the
//left and right arrows and the decks dropdown list under each card.  Decks can be created
//and deleted on this screen

class _DeckState extends State<DeckScreen> {
  TextStyle labelStyle = const TextStyle(color: Colors.black);
  var createDeckKey = GlobalKey<FormState>();
  var deckDeleteKey = GlobalKey<FormState>();
  late List<Deck> deckList = [];
  late List<MagicCard> cardList = [];
  late String currentDeck = '';
  late _Controller con;
  double manaAverage = 0;
  int deckSize = 0;
  String? deleteDeckId;
  String? deleteDeckName;
  late bool showAll;
  late String profilePicture;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    manaAverage = con.getManaAverage();
    deckSize = con.getDeckSize();
    showAll = true;
    profilePicture = widget.user.photoURL ?? 'No profile picture';
  }

  void render(fn) => setState(fn);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.5,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/Deck.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              AppBar(
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.black12,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 0,
                    ),
                    const Text('My Decks'),
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
                centerTitle: true,
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  border: Border.all(color: Colors.black12),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                //toggle view of either all cards or just deck cards (and chose deck)
                child: TextButton(
                  onPressed: () => render(() {
                    showAll = !showAll;
                    if (showAll) currentDeck = '';
                  }),
                  child: showAll
                      ? Text(
                          'Show only Cards in Deck (All Cards Showing)',
                          style: TextStyle(
                            color: Colors.blue[800],
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              'Current Deck Showing - ',
                              style: TextStyle(
                                color: Colors.blue[800],
                              ),
                            ),
                            con.getDeckNameList(),
                          ],
                        ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //child completed for each applicable card
                  children: con.getDeck(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: currentDeck == ''
                          ? Colors.transparent
                          : Colors.black45,
                      border: Border.all(color: Colors.white30),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: currentDeck != '' && con.getManaAverage() == -1
                        ? const Text(
                            'No Cards in Deck',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'average',
                              color: Colors.white,
                            ),
                          )
                        : con.getManaAverage() != -1.0 && currentDeck != ''
                            ? Text(
                                'Average Card Cost: ' +
                                    con.getManaAverage().toStringAsPrecision(2),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'average',
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: currentDeck != ''
                      ? Colors.black38
                      : const Color.fromARGB(0, 0, 0, 0),
                  border: Border.all(color: Colors.white10),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                width: 250,
                child: currentDeck != ''
                    ? con.getDeckColors()
                    : const SizedBox(
                        height: 0.0,
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  border: Border.all(color: Colors.white30),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: AlignmentDirectional.topStart,
                child: Form(
                  key: createDeckKey,
                  child: Container(
                    //color: Colors.red, //just testing
                    width: 350,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Create a new deck: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'average',
                                fontSize: 18,
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'enter name',
                                  constraints: BoxConstraints(
                                      maxWidth: 200, maxHeight: 50)),
                              validator: con.validateName,
                              onSaved: con.saveName,
                            )
                          ],
                        ),
                        // const SizedBox(
                        //   width: 25,
                        // ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.bottomRight,
                          //color: Colors.amber, //testing
                          child: ElevatedButton(
                            onPressed: con.createDeck,
                            child: const Text('Create'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  border: Border.all(color: Colors.white30),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: AlignmentDirectional.topStart,
                child: Form(
                  key: deckDeleteKey,
                  child: Container(
                    //color: Colors.red, //just testing
                    width: 360,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              // decoration: BoxDecoration(
                              // color: Colors.red[600],
                              // borderRadius: BorderRadius.circular(5.0)),
                              child: const Text(
                                'Delete a deck: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'average',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'enter name of deck',
                                constraints: BoxConstraints(
                                    maxWidth: 200, maxHeight: 50),
                              ),
                              validator: con.validateDeleteName,
                              onSaved: con.saveName,
                            )
                          ],
                        ),
                        // const SizedBox(
                        //   width: 25,
                        // ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          alignment: Alignment.bottomRight,
                          //color: Colors.amber, //testing
                          child: ElevatedButton(
                            onPressed: con.deleteDialog,
                            child: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
  _DeckState state;
  _Controller(this.state) {
    initDeckandCards();
  }
  String? deckName;

//will display all applicable cards based on if showAll is true and what currentDeck value is
  List<Widget> getDeck() {
    return state.cardList.map((e) {
      return Container(
        child: e.inDeck == state.currentDeck || state.showAll
            ? Card(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: .1,
                        ),
                        Container(
                          color: Colors.transparent,
                          child: Image.network(
                            e.imageURL.toString(),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                double percent = loadingProgress
                                        .cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes as num);
                                return SizedBox(
                                  width: 135,
                                  height: 265,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: percent,
                                      strokeWidth: 8.0,
                                      color: const Color.fromARGB(142, 0, 0, 0),
                                    ),
                                  ),
                                );
                              }
                            },
                            width: 200,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                child: e.inDeck! == ''
                                    //dropdown for deck list if card is not in a deck
                                    ? cardDeckList(e)
                                    //display card deck name if in deck
                                    : Text(
                                        e.inDeck.toString(),
                                        style: state.labelStyle,
                                      ),
                              ),
                              Row(
                                children: [
                                  //add and remove cards from deck
                                  IconButton(
                                    onPressed: e.numDeck != 0
                                        ? () => removeCard(e)
                                        : null,
                                    icon: const Icon(Icons.chevron_left_sharp),
                                    color: Colors.red,
                                    iconSize: 40,
                                  ),
                                  SizedBox(
                                    width: 65,
                                    child: Text(
                                      e.numDeck.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                  IconButton(
                                    //logic below - as long as the user has the cards to put in the deck
                                    //they can add 4; but there are no limits if the card is a basic land card
                                    onPressed: (e.numDeck < e.numOwned &&
                                                (e.typeLine!.contains(
                                                        'Basic Land') ||
                                                    e.numDeck < 4)) &&
                                            e.inDeck != ''
                                        ? () => addCard(e)
                                        : null,
                                    icon:
                                        const Icon(Icons.chevron_right_rounded),
                                    color: Colors.green,
                                    iconSize: 40,
                                  ),
                                ],
                              ),
                              Row(children: [
                                const SizedBox(
                                  width: 39,
                                ),
                                Text(
                                  'in deck - ' +
                                      e.numOwned.toString() +
                                      ' owned',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const SizedBox(
                width: 0.1,
                height: 365,
              ),
      );
    }).toList();
  }

//ensure after initial blank screen that cards and decks are loaded, then re-render
  void initDeckandCards() async {
    state.deckList =
        await FirestoreController.getDecks(state.widget.user.email);
    state.cardList =
        await FirestoreController.getCards(state.widget.user.email);

    state.render(() {});
  }

  double getManaAverage() {
    double avg = 0;
    int count = 0;
    for (var e in state.cardList) {
      //exclude basic land cards in average
      if (e.inDeck == state.currentDeck &&
          !e.typeLine!.contains('Basic Land')) {
        avg += ((e.cmc as num).toDouble() * e.numDeck.toDouble());
        count += e.numDeck as int;
      }
    }
    if (count != 0) {
      avg /= count;
      return avg;
    } else {
      return -1;
    }
  }

//sets up the color icons to show what colors are in the deck.  If a color is not
//present, its icon remains transparent.  If present, the color will change to the
//card's identity
  Row getDeckColors() {
    Color blackDeck = Colors.transparent;
    Color whiteDeck = Colors.transparent;
    Color blueDeck = Colors.transparent;
    Color greenDeck = Colors.transparent;
    Color redDeck = Colors.transparent;
    for (var x in state.cardList) {
      if (x.inDeck == state.currentDeck) {
        if (x.colorIdentity.contains(BLACK)) {
          blackDeck = blackCard;
        }
        if (x.colorIdentity.contains(WHITE)) {
          whiteDeck = whiteCard;
        }
        if (x.colorIdentity.contains(BLUE)) {
          blueDeck = blueCard;
        }
        if (x.colorIdentity.contains(RED)) {
          redDeck = redCard;
        }
        if (x.colorIdentity.contains(GREEN)) {
          greenDeck = greenCard;
        }
      }
    }
    //lay icons out
    return Row(
      children: [
        const SizedBox(
          width: 9.0,
        ),
        const Text(
          'Deck colors: ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'average',
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              color: blackDeck,
            ),
            Icon(
              Icons.circle,
              color: whiteDeck,
            ),
            Icon(
              Icons.circle,
              color: blueDeck,
            ),
            Icon(
              Icons.circle,
              color: redDeck,
            ),
            Icon(
              Icons.circle,
              color: greenDeck,
            ),
          ],
        ),
      ],
    );
  }

//decrements in firebase, remove deck name when numDeck == 0
  void removeCard(MagicCard c) async {
    c.numDeck--;
    if (c.numDeck == 0) {
      c.inDeck = '';
    }
    //update stats and firebase
    state.deckSize = getDeckSize();
    state.manaAverage = getManaAverage();
    await FirestoreController.updateCardInfo(
        docId: c.docId.toString(), updateInfo: {MagicCard.NUMDECK: c.numDeck});
    await FirestoreController.updateCardInfo(
        docId: c.docId.toString(), updateInfo: {MagicCard.INDECK: c.inDeck});
    state.render(() => initDeckandCards());
  }

  void addCard(MagicCard c) async {
    c.numDeck++;
    if (c.inDeck == '') c.inDeck = 'true';
    //update stats and firebase
    state.deckSize = getDeckSize();
    state.manaAverage = getManaAverage();
    await FirestoreController.updateCardInfo(
        docId: c.docId.toString(), updateInfo: {MagicCard.NUMDECK: c.numDeck});
    state.render(() => initDeckandCards());
  }

  int getDeckSize() {
    int count = 0;
    for (var e in state.cardList) {
      if (e.numDeck != 0) {
        count += e.numDeck as int;
      }
    }
    return count;
  }

  Column deckStats() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                border: Border.all(color: Colors.white30),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: getManaAverage() == -1.00
                  ? const Text(
                      'No Cards in Deck',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Average Card Cost: ' + getManaAverage().toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

//add deck to firebase
  void createDeck() async {
    FormState? currentState = state.createDeckKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    Deck? deck;
    //circularProgressStart(state.context);
    deck = Deck(
        name: deckName.toString(),
        useremail: state.widget.user.email.toString());
    await FirestoreController.addDeck(deck: deck);
    state.render(() => initDeckandCards());
  }

//delete deck from firebase, and update each card that it was in to show numDeck=0 and
//inDeck =''
  void deleteDeck(String? id) async {
    for (var x in state.cardList) {
      if (x.inDeck == deckName) {
        await FirestoreController.updateCardInfo(
            docId: x.docId.toString(), updateInfo: {MagicCard.INDECK: ''});
        await FirestoreController.updateCardInfo(
            docId: x.docId.toString(), updateInfo: {MagicCard.NUMDECK: 0});
      }
    }

    state.render(() {
      //if current viewed deck is deleted, go back to show all view
      FirestoreController.deleteDeck(docID: state.deleteDeckId.toString());
      if (state.currentDeck == deckName) {
        state.currentDeck = '';
        state.showAll = true;
      }
      initDeckandCards();
      Navigator.pop(state.context);
    });
  }

  String? validateName(String? e) {
    if (e == null || e.length < 6) {
      return 'Deck name is too short';
    }
    return null;
  }

  String? validateDeleteName(String? e) {
    for (var x in state.deckList) {
      if (x.name == e) {
        state.deleteDeckName = e;
        state.deleteDeckId = x.docId;
        return null;
      }
    }
    return 'Not a valid Deck';
  }

  void saveName(String? e) {
    deckName = e;
  }

  Future? deleteDialog() {
    FormState? currentState = state.deckDeleteKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return null;
    }
    currentState.save();

//final notice before deleting deck; name is already validated
    return showDialog(
      context: state.context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Deck "' + deckName.toString() + '"?'),
        content: Row(
          children: [
            ElevatedButton(
              onPressed: () => deleteDeck(state.deleteDeckId),
              child: const Text('DELETE'),
            ),
            const SizedBox(
              width: 25.0,
            ),
            ElevatedButton(
                onPressed: () =>
                    state.render(() => Navigator.pop(state.context)),
                child: const Text('Cancel'))
          ],
        ),
      ),
    );
  }

//dropdown used for top of screen filter
  DropdownButton<String> getDeckNameList() {
    List<String> nameList = [];
    for (var e in state.deckList) {
      nameList.add(e.name);
    }
    return DropdownButton<String>(
      hint: Text(
        state.currentDeck,
        style: TextStyle(color: Colors.blue[800]),
      ),
      onChanged: ((value) {
        state.currentDeck = value!;
        state.render(() {});
      }),
      items: nameList
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }

//name of deck dropdown - selecting a deck will automatically add 1 to the
//deck as well.  Will only show if card is not in deck
  DropdownButton<String> cardDeckList(MagicCard card) {
    List<String> nameList = [];
    for (var e in state.deckList) {
      nameList.add(e.name);
    }
    return DropdownButton<String>(
      hint: Text(
        card.inDeck.toString(),
        style: TextStyle(color: Colors.blue[800]),
      ),
      onChanged: ((value) {
        card.inDeck = value;
        card.numDeck = 1;
        FirestoreController.updateCardInfo(
            docId: card.docId.toString(),
            updateInfo: {MagicCard.INDECK: card.inDeck});
        FirestoreController.updateCardInfo(
            docId: card.docId.toString(),
            updateInfo: {MagicCard.NUMDECK: card.numDeck});
        state.render(() {});
      }),
      items: nameList
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList(),
    );
  }
}
