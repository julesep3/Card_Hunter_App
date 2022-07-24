class DirectMessage {
  static const PARTICIPANT1 = 'participant1';
  static const PARTICIPANT2 = 'participant2';
  static const LASTUPDATED = 'lastupdated';

  static const MESSAGES = 'messages';
  static const CONTENT = 'content';
  static const MESSAGEAUTHOR = 'messageauthor';
  static const TIMESENT = 'timesent';

  String? docId; //firestore will generate this
  late String participant1;
  late String participant2;
  DateTime? lastUpdated;

  late List<Map<String,dynamic>> messages;

  // constructor
  DirectMessage({
    this.docId,
    this.participant1 = 'unknown',
    this.participant2 = 'unknown',
    this.lastUpdated,
    List<dynamic>? messages,
  }){
    this.messages = messages == null ? [] : [...messages];
  }

  // This function checks to see if a submitted message meets the criteria needed to be submitted.
  //  It can be called from a form.
  static String? validateMessageContent(String? value) {
    return value == null || value.trim().length < 5 ? 'Message too short' : null;
  }

  // Converts Firestore docs into DirectMessages
  static DirectMessage? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return DirectMessage(
      docId: docId,
      participant1: doc[PARTICIPANT1] ??= 'N/A',
      participant2: doc[PARTICIPANT2] ??= 'N/A',
      lastUpdated: doc[LASTUPDATED] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc[LASTUPDATED].millisecondsSinceEpoch)
          : DateTime.now(),
      messages: doc[MESSAGES] ??= [{}],
    );
  }

  // Converts the current DirectMessage object into a format that can be
  //  sent to Firestore
  Map<String, dynamic> toFirestoreDoc() {
    return {
      PARTICIPANT1: participant1,
      PARTICIPANT2: participant2,
      LASTUPDATED: lastUpdated,
      MESSAGES: messages,
    };
  }
}
