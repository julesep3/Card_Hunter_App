//This class it possibly temporary for testing the inventory screen

import 'package:demo_1/model/scryfall_1.dart';
import 'package:flutter/material.dart';

class MagicCard {
  static const SCRYFALLURI = 'scryfalluri';
  static const EMAIL = 'username';
  static const CID = 'cid';
  static const NAME = 'name';
  static const TYPELINE = 'typeline';
  static const POWER = 'power';
  static const TOUGHNESS = 'toughness';
  static const RARITY = 'rarity';
  static const COLORIDENTITY = 'coloridentity';
  static const CMC = 'cmc';
  static const NUMOWNED = 'numowned';
  static const INDECK = 'indeck';
  static const NUMDECK = 'numdeck';
  static const IMAGEURL = 'imageurl';
  static const MANACOST = 'manacost';

  MagicCard({
    this.docId,
    this.email,
    required this.scryfallUri,
    required this.cid,
    required this.name,
    required this.typeLine,
    this.power,
    this.toughness,
    required this.rarity,
    required this.colorIdentity,
    required this.cmc,
    required this.numOwned,
    required this.inDeck,
    required this.numDeck,
    required this.imageURL,
    required this.manaCost,
  });

  String? docId; //firebase use
  String? email; //to establish the owner of the card
  String cid;
  String scryfallUri;
  String name;
  String? typeLine;
  String? power;
  String? toughness;
  String? imageURL;
  String rarity;
  num? cmc;
  num numOwned;
  List<dynamic> colorIdentity;
  String? inDeck;
  num numDeck;
  String? manaCost;

  static MagicCard? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    MagicCard card = MagicCard(
        docId: docId,
        email: doc[EMAIL],
        scryfallUri: doc[SCRYFALLURI],
        cid: doc[CID],
        name: doc[NAME],
        typeLine: doc[TYPELINE],
        rarity: doc[RARITY],
        colorIdentity: doc[COLORIDENTITY],
        cmc: doc[CMC],
        numOwned: doc[NUMOWNED],
        inDeck: doc[INDECK],
        numDeck: doc[NUMDECK],
        imageURL: doc[IMAGEURL],
        manaCost: doc[MANACOST]);
    if (doc[POWER] != null) {
      card.power = doc[POWER];
    } else {
      card.power = '';
    }
    if (doc[TOUGHNESS] != null) {
      card.toughness = doc[TOUGHNESS];
    } else {
      card.toughness = '';
    }
    return card;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      EMAIL: email,
      SCRYFALLURI: scryfallUri,
      CID: cid,
      NAME: name,
      TYPELINE: typeLine,
      POWER: power,
      TOUGHNESS: toughness,
      RARITY: rarity,
      COLORIDENTITY: colorIdentity,
      CMC: cmc,
      NUMOWNED: numOwned,
      INDECK: inDeck,
      NUMDECK: numDeck,
      IMAGEURL: imageURL,
      MANACOST: manaCost,
    };
  }
}

const String UNCOMMON = 'uncommon';
const String COMMON = 'common';
const String RARE = 'rare';
const String MYTHIC = 'mythic';
const String RED = 'R';
const String BLUE = 'U';
const String BLACK = 'B';
const String WHITE = 'W';
const String GREEN = 'G';

const String INSTANT = 'Instant';
const String CREATURE = 'Creature';
const String ENCHANTMENT = 'Enchantment';
const String SORCERY = 'Sorcery';
const String ARTIFACT = 'Artifact';
const String LAND = 'Land';
const PLANESWALKER = 'Planeswalker';

const Color blackCard = Color.fromARGB(255, 17, 17, 17);
const Color redCard = Color.fromARGB(255, 211, 116, 109);
const Color whiteCard = Color.fromARGB(255, 238, 233, 233);
const Color blueCard = Color.fromARGB(255, 109, 183, 243);
const Color greenCard = Color.fromARGB(255, 36, 138, 40);
const Color nonColorCard = Color.fromARGB(255, 131, 129, 129);
const Color multiCard = Color.fromARGB(255, 241, 228, 105);

enum CType { creature, instant, socery, land, artifact }

enum Rarity { common, uncommon, rare, ultraRare }

//List<MagicCard> inventoryList = [];

//testing

MagicCard dummy = MagicCard(
    scryfallUri: "na",
    cid: "testid111",
    name: "Murder",
    typeLine: 'instant',
    power: '3',
    toughness: '2',
    rarity: RARE,
    colorIdentity: ['B'],
    manaCost: '{1}{B}{B}',
    cmc: 3,
    numDeck: 2,
    numOwned: 1,
    inDeck: '',
    imageURL:
        "https://c1.scryfall.com/file/scryfall-cards/large/front/4/4/440bfb8c-f29a-4c11-9fcb-ee935dead03f.jpg?1608909810");
// List<MagicCard> inventoryList = <MagicCard>[
//   MagicCard(
//       scryfallUri: "na",
//       cid: "testid111",
//       name: "Murder",
//       typeLine: 'instant',
//       power: '3',
//       toughness: '2',
//       rarity: RARE,
//       colorIdentity: ['B'],
//       manaCost: '{1}{B}{B}',
//       cmc: 3,
//       numDeck: 2,
//       numOwned: 1,
//       inDeck: true,
//       imageURL:
//           "https://c1.scryfall.com/file/scryfall-cards/large/front/4/4/440bfb8c-f29a-4c11-9fcb-ee935dead03f.jpg?1608909810"),
//   MagicCard(
//       scryfallUri: "na",
//       cid: "testid112",
//       name: 'Alela, Artful Provocateur',
//       typeLine: 'creature',
//       power: '2',
//       toughness: '3',
//       rarity: MYTHIC,
//       colorIdentity: ['W'],
//       manaCost: '{1}{B}{B}',
//       cmc: 4,
//       numDeck: 1,
//       numOwned: 1,
//       inDeck: true,
//       imageURL:
//           'https://c1.scryfall.com/file/scryfall-cards/large/front/7/2/726e7dc5-2089-4758-93e1-79212aedf75f.jpg?1591605150'),
//   MagicCard(
//       scryfallUri: "na",
//       cid: "testid113",
//       name: "Black Cat",
//       typeLine: 'creature',
//       power: '1',
//       toughness: '1',
//       rarity: COMMON,
//       colorIdentity: ['W'],
//       manaCost: '{1}{B}{B}',
//       cmc: 2,
//       numDeck: 0,
//       numOwned: 1,
//       inDeck: false,
//       imageURL:
//           'https://c1.scryfall.com/file/scryfall-cards/large/front/c/9/c90a12af-b453-4d83-9a14-5411b562d480.jpg?1600699446'),
//   MagicCard(
//       scryfallUri: "na",
//       cid: "testid114",
//       name: 'Blighted Cataract',
//       typeLine: 'land',
//       power: '',
//       toughness: '',
//       rarity: UNCOMMON,
//       colorIdentity: ['R'],
//       numDeck: 0,
//       numOwned: 1,
//       inDeck: false,
//       manaCost: '{1}{B}{B}',
//       cmc: 0,
//       imageURL:
//           'https://c1.scryfall.com/file/scryfall-cards/large/front/a/6/a6d03a79-4219-492f-bf9a-0b810e97e5f5.jpg?1625979790'),
//   MagicCard(
//       scryfallUri: "na",
//       cid: "testid114",
//       name: 'Canyon Wildcat',
//       typeLine: 'creature',
//       power: '12',
//       toughness: '1',
//       rarity: COMMON,
//       colorIdentity: ['R', 'B'],
//       manaCost: '{1}{B}{B}',
//       cmc: 2,
//       numDeck: 4,
//       numOwned: 1,
//       inDeck: true,
//       imageURL:
//           'https://c1.scryfall.com/file/scryfall-cards/large/front/4/b/4bd2baa7-1264-4139-881d-e8169391c48b.jpg?1562429362'),
// ];

  // static void addCard(Future<Scryfall>? searchCard, String username) {
  //   print('function started');
  //   FutureBuilder<Scryfall>(
  //     future: searchCard,
  //     builder: ((context, snapshot) {
  //       if (snapshot.hasData) {
  //         print('card creation started');
  //         inventoryList.add(
  //           MagicCard(
  //               email: username,
  //               scryfallUri: snapshot.data!.scryfallUri,
  //               cid: snapshot.data!.id,
  //               name: snapshot.data!.name,
  //               typeLine: snapshot.data!.typeLine,
  //               power: snapshot.data!.power,
  //               toughness: snapshot.data!.toughness,
  //               rarity: snapshot.data!.rarity,
  //               colorIdentity: snapshot.data!.colorIdentity,
  //               cmc: snapshot.data!.cmc,
  //               numDeck: 0,
  //               numOwned: 1,
  //               inDeck: false,
  //               imageURL: snapshot.data!.imageUris.large,
  //               manaCost: snapshot.data!.manaCost),
  //         );
  //         print('card added');
  //         return Text(inventoryList.last.name + 'added');
  //       } else {
  //         print('card not added');
  //         return const Text('Card could not be added');
  //       }
  //     }),
  //   );
  // }