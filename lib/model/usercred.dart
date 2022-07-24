class UserCred {
  static const USERNAME = 'username';
  static const EMAIL = 'email';
  static const PHOTOFILENAME = 'photoFilename';
  static const PROFILEPICURL = 'profilePicURL';
  static const TIMESTAMP = 'timestamp';

  String? docId; // Firestore auto-generated id
  late String username;
  late String email;
  late String photoFilename; // image filed in Cloud Storage
  late String profilePicURL; // URL of image
  DateTime? timestamp;

  // constructor
  UserCred({
    this.docId,
    this.username = '',
    this.email = '',
    this.photoFilename = '',
    this.profilePicURL = '',
    this.timestamp,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      USERNAME: username,
      EMAIL: email,
      PHOTOFILENAME: photoFilename,
      PROFILEPICURL: profilePicURL,
      TIMESTAMP: timestamp,
    };
  }

  static UserCred? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return UserCred(
      docId: docId,
      username: doc[USERNAME] ??= 'N/A',
      email: doc[EMAIL] ??= 'N/A',
      photoFilename: doc[PHOTOFILENAME] ??= 'N/A',
      profilePicURL: doc[PROFILEPICURL] ??= 'N/A',
      timestamp: doc[TIMESTAMP] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }
}
