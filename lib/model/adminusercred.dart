class AdminUserCred {
  static const EMAIL = 'email';
  static const PASSWORD = 'password';

  String? docId; // Firestore auto-generated id
  late String email;
  late String password;

  // constructor
  AdminUserCred({
    this.docId,
    this.email = '',
    this.password = '',
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      EMAIL: email,
      PASSWORD: password,
    };
  }

  static AdminUserCred? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return AdminUserCred(
      docId: docId,
      email: doc[EMAIL] ??= 'N/A',
      password: doc[PASSWORD] ??= 'N/A',
    );
  }
}
