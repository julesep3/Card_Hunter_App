// class to hold global constant definitions
class Constant {
  static const devMode = true;
  static const FORUM_THREAD_COLLECTION = 'forum_thread_collection';
  static const DIRECT_MESSAGE_COLLTECTION = 'direct_message_collection';
  static const photoFileFolder = 'photo_files';
  static const userFileFolder = 'users_files';
  static const adminUserFileFolder = 'admin_users_files';
  static const userCard = 'user_card';
  static const userDecks = 'user_decks';
  static const userWishlist = 'user_wishlist';

  //rarity strings as found in json

  static const adminEmails = [
    'admin@test.com',
    'super@test.com',
  ];
}

enum ArgKey {
  user,
  downloadURL,
  filename,
  thread,
  cardArg,
  setArg,
  dmUserId,
  dmRecipientId,
  userEmail,
  hasNext,
  nextUri,
  gamePlaySetup,
  userToBeModified,
}

enum PhotoSource {
  CAMERA,
  GALLERY,
}
