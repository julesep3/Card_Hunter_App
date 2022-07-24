import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_1/model/adminusercred.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/directmessage.dart';
import 'package:demo_1/model/magic_card.dart';
import 'package:demo_1/model/price_list.dart';
import 'package:demo_1/model/scryfall_1.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../model/deck.dart';
import '../model/thread.dart';

class FirestoreController {
//=====================================================================
//Controllers for creating, getting, replying threads
//from Firebase
//=====================================================================
  static Future<String> createNewThread({
    required Thread thread,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.FORUM_THREAD_COLLECTION)
        .add(thread.toFirestoreDoc());
    return ref.id;
  }

  // New DM Chain
  static Future<String> createNewDirectMessage({
    required DirectMessage directMessage,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
        .add(directMessage.toFirestoreDoc());
    return ref.id;
  }

  static Future<List<Thread>> getForumThreads() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FORUM_THREAD_COLLECTION)
        .orderBy(Thread.LASTUPDATED, descending: true)
        .get();

    var result = <Thread>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = Thread.fromFirestoreDoc(doc: document, docId: doc.id);
        if (t != null) {
          result.add(t);
        }
      }
    }

    return result;
  }

  static Future<List<DirectMessage>> getDMs(String userDocId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
        .where(DirectMessage.PARTICIPANT1, isEqualTo: userDocId)
        .orderBy(Thread.LASTUPDATED, descending: true)
        .get();

    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
        .where(DirectMessage.PARTICIPANT2, isEqualTo: userDocId)
        .orderBy(Thread.LASTUPDATED, descending: true)
        .get();

    //querySnapshot.docs.addAll(querySnapshot2.docs);
    var rawResults = [];
    rawResults.addAll(querySnapshot.docs);
    rawResults.addAll(querySnapshot2.docs);
    var result = <DirectMessage>[];

    for (var doc in rawResults) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = DirectMessage.fromFirestoreDoc(doc: document, docId: doc.id);
        if (t != null) {
          result.add(t);
        }
      }
    }

    return result;
  }

  static Future<Thread> getSingleForumThread(String threadId) async {
    DocumentSnapshot<Map<String, dynamic>> threadDoc = await FirebaseFirestore.instance
        .collection(Constant.FORUM_THREAD_COLLECTION)
        .doc(threadId)
        .get();

    Thread? thread = Thread.fromFirestoreDoc(
      doc: threadDoc.data() as Map<String, dynamic>,
      docId: threadId,
    );

    return thread!;
  }

  static Future<void> replyToThread({
    required String threadId,
    required Map<String, dynamic> post,
  }) async {
    // We're getting a fresh copy of the original thread to append our post
    DocumentSnapshot<Map<String, dynamic>> threadDoc = await FirebaseFirestore.instance
        .collection(Constant.FORUM_THREAD_COLLECTION)
        .doc(threadId)
        .get();

    // Turn it into our friendly Thread object
    Thread? thread = Thread.fromFirestoreDoc(
      doc: threadDoc.data() as Map<String, dynamic>,
      docId: threadId,
    );

    if (thread == null) return;
    thread.posts.add(post);
    thread.lastUpdated = DateTime.now();
    Map<String, dynamic> postsAndTimeStamps = {
      Thread.POSTS: thread.posts,
      Thread.LASTUPDATED: thread.lastUpdated,
    };
    await FirebaseFirestore.instance
        .collection(Constant.FORUM_THREAD_COLLECTION)
        .doc(threadId)
        .update(postsAndTimeStamps);
  }

  static Future<void> replyToDirectMessage({
    required String directMessageId,
    required Map<String, dynamic> message,
  }) async {
    // We're getting a fresh copy of the original thread to append our post
    DocumentSnapshot<Map<String, dynamic>> directMessageDoc = await FirebaseFirestore
        .instance
        .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
        .doc(directMessageId)
        .get();

    // Turn it into our friendly Thread object
    DirectMessage? directMessage = DirectMessage.fromFirestoreDoc(
      doc: directMessageDoc.data() as Map<String, dynamic>,
      docId: directMessageId,
    );

    if (directMessage == null) return;
    directMessage.messages.add(message);
    directMessage.lastUpdated = DateTime.now();
    Map<String, dynamic> postsAndTimeStamps = {
      DirectMessage.MESSAGES: directMessage.messages,
      DirectMessage.LASTUPDATED: directMessage.lastUpdated,
    };
    await FirebaseFirestore.instance
        .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
        .doc(directMessageId)
        .update(postsAndTimeStamps);
  }

  // function to get a single string of DMs between two specific users
  static Future<DirectMessage?> getDirectMessage(
      String participant1id, String participant2id) async {
    String participant1;
    String participant2;
    // compare doc ids to determine participant1, highest is participant1
    if (participant1id.compareTo(participant2id) >= 0) {
      participant1 = participant1id;
      participant2 = participant2id;
    } else {
      participant1 = participant2id;
      participant2 = participant1id;
    }
    QuerySnapshot<Map<String, dynamic>> directMessageQuerySnapshot =
        await FirebaseFirestore.instance
            .collection(Constant.DIRECT_MESSAGE_COLLTECTION)
            .where(DirectMessage.PARTICIPANT1, isEqualTo: participant1)
            .where(DirectMessage.PARTICIPANT2, isEqualTo: participant2)
            .get();
    print('I am here');
    if (directMessageQuerySnapshot.docs.isNotEmpty) {
      DirectMessage? directMessage = DirectMessage.fromFirestoreDoc(
        doc: directMessageQuerySnapshot.docs[0].data() as Map<String, dynamic>,
        docId: directMessageQuerySnapshot.docs[0].id,
      );

      return directMessage;
    }

    return null;
  }

//=====================================================================
//Controllers for adding/updating/getting user credentials (for admin purposes)
//from Firebase
//=====================================================================

  // function to add user credentials to Firestore for admin purposes
  static Future<String> adminAddUserCred({
    required AdminUserCred adminUserCred,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.adminUserFileFolder)
        .add(adminUserCred.toFirestoreDoc());
    return ref.id;
  }

  // function to get user credentials from Firestore based on email
  // for admin purposes
  static Future<List<AdminUserCred>> adminGetUserCred(String? email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.adminUserFileFolder)
        .where(AdminUserCred.EMAIL, isEqualTo: email)
        .get();

    var result = <AdminUserCred>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var uc = AdminUserCred.fromFirestoreDoc(doc: document, docId: doc.id);
        if (uc != null) {
          result.add(uc);
        }
      }
    }
    return result;
  }

  // function to update user credentials in Firestore for admin purposes
  static Future<void> adminUpdateUserCred({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.adminUserFileFolder)
        .doc(docId)
        .update(updateInfo);
  }

//=====================================================================
//Controllers for adding/updating/getting user credentials
//from Firebase
//=====================================================================

  // function to add user credentials to Firestore for general purpose access
  static Future<String> addUserCred({
    required UserCred userCred,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.userFileFolder)
        .add(userCred.toFirestoreDoc());
    return ref.id;
  }

  // function to update user credentials in Firestore
  static Future<void> updateUserCred({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.userFileFolder)
        .doc(docId)
        .update(updateInfo);
  }

  // function to get user credentials from Firestore based on email
  static Future<List<UserCred>> getUserCred(String? email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.userFileFolder)
        .where(UserCred.EMAIL, isEqualTo: email)
        .get();

    var result = <UserCred>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var uc = UserCred.fromFirestoreDoc(doc: document, docId: doc.id);
        if (uc != null) {
          result.add(uc);
        }
      }
    }
    return result;
  }

  // function to get user credentials from Firestore based on docID
  static Future<UserCred?> getUserCredById(String docId) async {
    DocumentSnapshot userCredDoc = await FirebaseFirestore.instance
        .collection(Constant.userFileFolder)
        .doc(docId)
        .get();
    if (userCredDoc.data() != null) {
      return UserCred.fromFirestoreDoc(
        doc: userCredDoc.data() as Map<String, dynamic>,
        docId: docId,
      );
    } else {
      return null;
    }
  }

  // function to get all user credentials from Firestore (admin-only privileges)
  static Future<List<UserCred>> getAllUserCreds() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(Constant.userFileFolder).get();
    var result = <UserCred>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var uc = UserCred.fromFirestoreDoc(doc: document, docId: doc.id);
        if (uc != null) {
          result.add(uc);
        }
      }
    }
    return result;
  }

// function to search for users
  static Future<List<UserCred>> searchUser(String? query) async {
    QuerySnapshot querySnapshot;
    if (query != null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(Constant.userFileFolder)
          .where(UserCred.USERNAME,
              isGreaterThanOrEqualTo: query,
              isLessThan: query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
          .get();
    } else {
      querySnapshot =
          await FirebaseFirestore.instance.collection(Constant.userFileFolder).get();
    }

    var results = <UserCred>[];
    querySnapshot.docs.forEach((doc) {
      var u = UserCred.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (u != null && u.username != 'userHasBeenDeleted') results.add(u);
    });
    return results;
  }

//=====================================================================
//Controllers for storing, retrieving, updating and deleting Magic Cards
//from Firebase
//=====================================================================

  static Future<String> addCard({
    required MagicCard card,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.userCard)
        .add(card.toFirestoreDoc());
    return ref.id;
  }

  static Future<List<MagicCard>> getCards(String? email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.userCard)
        .where(MagicCard.EMAIL, isEqualTo: email)
        .orderBy(MagicCard.NAME, descending: true)
        .get();

    var result = <MagicCard>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = MagicCard.fromFirestoreDoc(doc: document, docId: doc.id);
        if (t != null) {
          result.add(t);
        }
      }
    }
    return result;
  }

  static Future<void> updateCardInfo(
      {required String docId, required Map<String, dynamic> updateInfo}) async {
    await FirebaseFirestore.instance
        .collection(Constant.userCard)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<void> deleteCard({required String docId}) async {
    await FirebaseFirestore.instance.collection(Constant.userCard).doc(docId).delete();
  }

//Controllers for storing, retrieving, updating and deleting Wishlists
//from Firebase
//=====================================================================

//Adds the list to firebase
  static Future<String> addPrice({
    required PriceList plist,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.userWishlist)
        .add(plist.toFirestoreDoc());
    return ref.id;
  }

//retrieves prices from the user's wishlist
  static Future<List<PriceList>> getPrices(String? email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.userWishlist)
        .where(PriceList.EMAIL, isEqualTo: email)
        .orderBy(PriceList.NAME, descending: true)
        .get();

    var result = <PriceList>[];

    await Future.forEach(querySnapshot.docs, (QueryDocumentSnapshot doc) async {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = PriceList.fromFirestoreDoc(doc: document, docId: doc.id);
        if (t != null) {
          var selectedCard = await scryfallGet(
            t.name.toString().replaceAll(' ', '+'),
          );
          if (selectedCard.prices!.usd != null) {
            t.price = selectedCard.prices!.usd!;
          } else {
            t.price = '0.00';
          }
        }

        if (t != null) {
          result.add(t);
        }
      }
    });
    return result;
  }

//scryfall api parsing and retrieval to firebase
  static Future<Scryfall> scryfallGet(String cardName) async {
    final url = Uri.parse('https://api.scryfall.com/cards/named?fuzzy=' + cardName);

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

//update price info in realtime
  static Future<void> updatePriceInfo(
      {required String docId, required Map<String, dynamic> updateInfo}) async {
    await FirebaseFirestore.instance
        .collection(Constant.userWishlist)
        .doc(docId)
        .update(updateInfo);
  }

//delete price info in real time
  static Future<void> deletePrices({required String docId}) async {
    await FirebaseFirestore.instance
        .collection(Constant.userWishlist)
        .doc(docId)
        .delete();
  }

//=====================================================================
//Controllers for storing, retrieving, updating and deleting Decks
//from Firebase
//=====================================================================
  static Future<String> addDeck({
    required Deck deck,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.userDecks)
        .add(deck.toFirestoreDoc());
    return ref.id;
  }

  // function to update deck information
  static Future<void> updateDeckInfo(
      {required String docId, required Map<String, dynamic> updateInfo}) async {
    await FirebaseFirestore.instance
        .collection(Constant.userDecks)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<List<Deck>> getDecks(String? email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.userDecks)
        .where(Deck.USEREMAIL, isEqualTo: email)
        .orderBy(Deck.NAME, descending: false)
        .get();

    var result = <Deck>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var t = Deck.fromFirestoreDoc(doc: document, docId: doc.id);
        if (t != null) {
          result.add(t);
        }
      }
    }
    return result;
  }

  static Future<void> deleteDeck({required String docID}) async {
    await FirebaseFirestore.instance.collection(Constant.userDecks).doc(docID).delete();
  }
}
