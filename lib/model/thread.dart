// This class represents forum threads
class Thread {
  static const TITLE = 'title';
  static const THREADAUTHOR = 'threadauthor';
  static const FIRSTPOSTED = 'firstposted';
  static const LASTUPDATED = 'lastupdated';

  static const POSTS = 'posts';
  static const CONTENT = 'CONTENT';
  static const POSTAUTHOR = 'postauthor';
  static const TIMEPOSTED = 'timeposted';

  String? docId; //firestore will generate this
  late String title;
  late String threadAuthor;
  DateTime? firstPosted;
  DateTime? lastUpdated;

  late List<dynamic> posts;

  // Constructor
  Thread({
    this.docId,
    this.title = 'unknown',
    this.threadAuthor = 'unknown',
    this.firstPosted,
    this.lastUpdated,
    List<dynamic>? posts,
  }){
    this.posts = posts == null ? [] : [...posts];
  }

  // Called from a form, this checks to see if a submitted title fits the criteria
  static String? validateTitle(String? value) {
    return value == null || value.trim().length < 3 ? 'Title too short' : null;
  }

  // Called from a form, this checks to see if a submitted post's content fits the criteria
  static String? validatePostContent(String? value) {
    return value == null || value.trim().length < 5 ? 'Post too short' : null;
  }

  // Takes a Firestore document and returns the data as a thread object
  static Thread? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return Thread(
      docId: docId,
      title: doc[TITLE] ??= 'N/A',
      threadAuthor: doc[THREADAUTHOR] ??= 'N/A',
      firstPosted: doc[FIRSTPOSTED] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc[FIRSTPOSTED].millisecondsSinceEpoch)
          : DateTime.now(),
      lastUpdated: doc[LASTUPDATED] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc[LASTUPDATED].millisecondsSinceEpoch)
          : DateTime.now(),
      posts: doc[POSTS] ??= [],
    );
  }

  // Returns the current thread in a format that is capable of being sent to firestore.
  Map<String, dynamic> toFirestoreDoc() {
    return {
      TITLE: title,
      THREADAUTHOR: threadAuthor,
      FIRSTPOSTED: firstPosted,
      LASTUPDATED: lastUpdated,
      POSTS: posts,
    };
  }
}
