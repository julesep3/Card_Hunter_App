class Deck {
  static const NAME = 'name';
  static const USEREMAIL = 'user_email';
  static const DOCID = 'docId';

  Deck({required this.name, required this.useremail, this.docId});

  String name;
  String useremail;
  String? docId;

  static Deck? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    Deck deck = Deck(name: doc[NAME], useremail: doc[USEREMAIL], docId: docId);

    return deck;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {NAME: name, USEREMAIL: useremail};
  }
}
