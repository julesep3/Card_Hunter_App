import 'package:demo_1/controller/firestore_controller.dart';
//import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/magic_card.dart';
import 'package:demo_1/model/scryfall_1.dart';
//import 'package:demo_1/model/usercred.dart';
//import 'package:demo_1/viewscreen/results.dart';
//import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'home_screen.dart';

/*
This screen pulls a user's cards from firebase and loads them into a list with the basic
information about the card listed.  the number of each card owned can be increased and decreased
from this screen.
 */

class InventoryScreen extends StatefulWidget {
  static const routeName = '/InventoryScreen';
  final User user;
  const InventoryScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InventoryState();
  }
}

class _InventoryState extends State<InventoryScreen> {
  late _Controller con;
  late String profilePicture;
  late bool isSelected;
  late List<String>? filterList;
  //Future<Scryfall>? searchCard;
  List<MagicCard>? cardList;
  TextStyle style = const TextStyle(fontSize: 15.0, color: Colors.black);
  TextStyle headerStyle = const TextStyle(fontSize: 15.0, color: Colors.white);
  final TextEditingController _controller = TextEditingController();

  void initInventory({required String email}) async {
    cardList = await FirestoreController.getCards(email);
  }

  @override
  void initState() {
    con = _Controller(this);

    super.initState();
    isSelected = false;
    filterList = []; //testing

    profilePicture = widget.user.photoURL ?? 'No profile picture';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    //cardList = inventoryList;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        // put image as background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Inventory.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          child: Column(
            children: [
              AppBar(
                leading: BackButton(
                  //this shouldn't ever have to be changed :)
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 0,
                    ),
                    cardList != null
                        ? Text('Inventory -  ' +
                            con.cardCount(cardList!).toString() +
                            ' Cards Total')
                        : const Text('No cards in Inventory'),
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
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 145,
                      child: Text(
                        '           Card Name',
                        style: headerStyle,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'In Deck',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'CMC',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'A/D',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Rarity',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '# owned',
                        style: headerStyle,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              cardList != null
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: con.getInventory(),
                      ))
                  : const SizedBox(
                      height: 1.0,
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        onPressed: () => con.searchDialog(),
        child: const Icon(Icons.list),
      ),
    );
  }
}

class _Controller {
  _InventoryState state;
  late MagicCard selected;
  _Controller(this.state) {
    initInventory();
    selected = dummy;
  }

  //ensures the inventory will display - initial render will be blank, but page will not re-render until cardlist is filled
  void initInventory() async {
    state.cardList =
        await FirestoreController.getCards(state.widget.user.email);
    state.render(() {});
  }

//creates the columns with each card and stats
  List<Widget> getInventory() {
    int count = 0;
    return state.cardList!.map((e) {
      String simpleCardType = getSimpleCardType(e: e);
      count++; //use to alternate colors below
      //this logic will check if there are any filters in place, and if so, if the card's type is one of those filters
      //will return the current card's info if no filters or filter applies to the card
      return state.filterList!.contains(simpleCardType) ||
              state.filterList!.isEmpty
          ? Column(
              children: [
                Container(
                  color: count.isEven
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Row(
                    children: [
                      expandDetails(e),
                      const SizedBox(
                        width: 1.0,
                      ),
                      SizedBox(
                        width: 100.0,
                        child: e.name.length > 12
                            ? Text(
                                e.name.substring(0, 12) + '...',
                                style: const TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              )
                            : Text(
                                e.name,
                                style: const TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                      ),
                      SizedBox(
                        width: 50,
                        child: e.inDeck != ''
                            ? const Icon(
                                Icons.document_scanner_sharp,
                                color: Colors.black,
                              )
                            : null,
                      ),
                      SizedBox(
                        width: 40.0,
                        child: Text(
                          (e.cmc?.toInt()).toString(),
                          textAlign: TextAlign.center,
                          style: state.style,
                        ),
                      ),
                      SizedBox(
                        width: 60.0,
                        //displays power/toughness if applicable
                        child: e.toughness != '' && e.power != ''
                            ? Text(
                                e.power.toString() +
                                    '/' +
                                    e.toughness.toString(),
                                textAlign: TextAlign.center,
                                style: state.style,
                              )
                            : const Text(''),
                      ),
                      SizedBox(
                        width: 40.0,
                        child: e.rarity == COMMON
                            ? Text(
                                'C',
                                style: state.style,
                                textAlign: TextAlign.center,
                              )
                            : e.rarity == UNCOMMON
                                ? Text(
                                    'U',
                                    style: state.style,
                                    textAlign: TextAlign.center,
                                  )
                                : e.rarity == RARE
                                    ? Text(
                                        'R',
                                        style: state.style,
                                        textAlign: TextAlign.center,
                                      )
                                    : e.rarity == MYTHIC
                                        ? Text(
                                            'M',
                                            style: state.style,
                                            textAlign: TextAlign.center,
                                          )
                                        : null,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          e.numOwned.toString(),
                          style: state.style,
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ),
                //checks if a details section should be showing and on what card
                state.isSelected && selected == e
                    ? showDetails(e)
                    : const SizedBox(
                        height: .1,
                      ),
              ],
            )
          : const SizedBox(
              height: 0.1,
            );
    }).toList();
  }

//used to sanitize the card types and ensure addition text in type is removed.  this is used instead of
//the card's actual type
  String getSimpleCardType({required MagicCard e}) {
    if (e.typeLine!.contains(CREATURE)) {
      return CREATURE;
    } else if (e.typeLine!.contains(ARTIFACT)) {
      return ARTIFACT;
    } else if (e.typeLine!.contains(LAND)) {
      return LAND;
    } else if (e.typeLine!.contains(INSTANT)) {
      return INSTANT;
    } else if (e.typeLine!.contains(SORCERY)) {
      return SORCERY;
    } else if (e.typeLine!.contains(PLANESWALKER)) {
      return PLANESWALKER;
    } else if (e.typeLine!.contains(ENCHANTMENT)) {
      return ENCHANTMENT;
    } else {
      return '';
    }
  }

//calculates total number of cards owned for the title bar
  int cardCount(List<MagicCard> clist) {
    int count = 0;

    if (state.cardList != null) {
      for (var e in clist) {
        count += e.numOwned.toInt();
      }
    }
    return count;
  }

  //dialog for the filters - checks boxes of current filters in place.  checking a box adds that filter to
  //the filter list, unchecking removes it.  all unchecks filters out nothing and all cards show
  Future? searchDialog() {
    return showDialog(
      context: state.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Filter (None Checked Shows All)'),
        content: Container(
          height: 375,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Filter Cards by:'),
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(ARTIFACT),
                              onChanged: (bool? value) {
                                toggleSelection(ARTIFACT);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(ARTIFACT),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(CREATURE),
                              onChanged: (bool? value) {
                                toggleSelection(CREATURE);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(CREATURE),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(ENCHANTMENT),
                              onChanged: (bool? value) {
                                toggleSelection(ENCHANTMENT);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(ENCHANTMENT),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(INSTANT),
                              onChanged: (bool? value) {
                                toggleSelection(INSTANT);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(INSTANT),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(LAND),
                              onChanged: (bool? value) {
                                toggleSelection(LAND);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(LAND),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(PLANESWALKER),
                              onChanged: (bool? value) {
                                toggleSelection(PLANESWALKER);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(PLANESWALKER),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: state.filterList!.contains(SORCERY),
                              onChanged: (bool? value) {
                                toggleSelection(SORCERY);
                                state.render(() {
                                  Navigator.pop(state.context);
                                });
                              }),
                          const Text(SORCERY),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//the function that adds and removes filters
  void toggleSelection(String selection) {
    if (!state.filterList!.contains(selection) && state.filterList != null) {
      state.filterList!.add(selection);
    } else if (state.filterList!.contains(selection)) {
      state.filterList!.remove(selection);
    }
  }

//gives the icon the applicable color of the cards' identity
  Icon cardIcon(MagicCard e) {
    Color cardcolor;
    if (e.colorIdentity.length > 1) {
      cardcolor = multiCard;
      return Icon(Icons.circle, color: cardcolor);
    } else if (e.colorIdentity.isEmpty) {
      cardcolor = nonColorCard;
      return Icon(Icons.circle, color: cardcolor);
    }
    switch (e.colorIdentity[0]) {
      case RED:
        cardcolor = redCard;
        break;
      case BLUE:
        cardcolor = blueCard;
        break;
      case WHITE:
        cardcolor = whiteCard;
        break;
      case GREEN:
        cardcolor = greenCard;
        break;
      case BLACK:
        cardcolor = blackCard;
        break;
      default:
        cardcolor = nonColorCard;
        break;
    }
    return Icon(Icons.circle, color: cardcolor);
  }

//used for expanding and collapsing details
  IconButton expandDetails(MagicCard e) {
    return IconButton(
        onPressed: () {
          if (selected != e) {
            selected = e;
            state.isSelected = true;
          } else {
            state.isSelected = !state.isSelected;
          }

          state.render(() {});
        },
        icon: cardIcon(e));
  }

//when card's icon is selected, these details are shown.  It displays full card name,
//plus and minus to add and remove copies of the card, and show card count
  Container showDetails(MagicCard e) {
    Color cardcolor;
    //determines the background color based on card identity
    if (e.colorIdentity.isNotEmpty) {
      switch (e.colorIdentity[0]) {
        case RED:
          cardcolor = redCard;
          break;
        case BLUE:
          cardcolor = blueCard;
          break;
        case WHITE:
          cardcolor = whiteCard;
          break;
        case GREEN:
          cardcolor = greenCard;
          break;
        case BLACK:
          cardcolor = blackCard;
          break;
        default:
          cardcolor = nonColorCard;
          break;
      }
    } else {
      cardcolor = nonColorCard;
    }
    if (e.colorIdentity.length > 1) {
      cardcolor = multiCard;
    } else if (e.colorIdentity.isEmpty) {
      cardcolor = nonColorCard;
    }
    return Container(
      height: 70.0,
      color: cardcolor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
              flex: 1,
              child: SizedBox(
                height: 1,
              )),
          Expanded(
            child: Text(
              e.name,
              //ensures text displayed can be read on the various background colors
              style: TextStyle(
                  color: (cardcolor == whiteCard || cardcolor == multiCard)
                      ? Colors.black
                      : Colors.white),
            ),
            flex: 2,
          ),
          //with the plus and minus icons below, cards are added and removed from firebase with each press
          //cards are removed entirely if count falls to 0 or below.  Cards cannot be removed passed the
          //number in a deck
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: e.numDeck != e.numOwned
                  ? () async {
                      e.numOwned--;
                      await FirestoreController.updateCardInfo(
                          docId: e.docId.toString(),
                          updateInfo: {MagicCard.NUMOWNED: e.numOwned});
                      if (e.numOwned <= 0) {
                        state.isSelected = false;
                        await FirestoreController.deleteCard(
                            docId: e.docId.toString());
                        state.render(() => initInventory());
                      } else {
                        state.render(() {});
                      }
                    }
                  : () {},
              icon: Icon(
                Icons.remove,
                color: e.numDeck != e.numOwned
                    ? (cardcolor == whiteCard || cardcolor == multiCard)
                        ? Colors.black
                        : Colors.white
                    : cardcolor,
                size: 40,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' ' + e.numOwned.toString(),
                  style: TextStyle(
                    color: (cardcolor == whiteCard || cardcolor == multiCard)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                Text(
                  '# owned',
                  style: TextStyle(
                    fontSize: 10,
                    color: (cardcolor == whiteCard || cardcolor == multiCard)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () async {
                e.numOwned++;
                await FirestoreController.updateCardInfo(
                    docId: e.docId.toString(),
                    updateInfo: {MagicCard.NUMOWNED: e.numOwned});
                state.render(() {});
              },
              icon: Icon(
                Icons.add,
                color: (cardcolor == whiteCard || cardcolor == multiCard)
                    ? Colors.black
                    : Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
