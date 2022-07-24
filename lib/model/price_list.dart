import 'package:demo_1/model/scryfall_1.dart';
import 'package:flutter/material.dart';

//default variables for pricelist
class PriceList {
  static const SCRYFALLURI = 'scryfalluri';
  static const EMAIL = 'username';
  static const CID = 'cid';
  static const NAME = 'name';
  static const IMAGEURL = 'imageurl';
  static const NUMOWNED = 'numowned';
  static const PURCHASED = 'purchased';

//pricelist information for the card selected in realtime
  PriceList({
    this.docId,
    this.email,
    this.price = '0.0',
    required this.scryfallUri,
    required this.cid,
    required this.name,
    required this.imageURL,
    required this.numOwned,
    this.purchased = false,
  });

  String? docId; //firebase use
  String? email; //to establish the owner of the card
  String cid;
  String scryfallUri;
  String name;
  String? imageURL;
  bool purchased;

  num numOwned;
  String price = '0.0'; //price default format

//pricelist call in firebase
  static PriceList? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    PriceList plist = PriceList(
      docId: docId,
      email: doc[EMAIL],
      scryfallUri: doc[SCRYFALLURI],
      cid: doc[CID],
      name: doc[NAME],
      imageURL: doc[IMAGEURL],
      numOwned: doc[NUMOWNED],
      purchased: doc[PURCHASED],
    );
    return plist;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      EMAIL: email,
      SCRYFALLURI: scryfallUri,
      CID: cid,
      NAME: name,
      IMAGEURL: imageURL,
      NUMOWNED: numOwned,
      PURCHASED: purchased,
    };
  }
}
