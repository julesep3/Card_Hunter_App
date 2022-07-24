import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/usercred.dart';

/*
*  The purpose of this class is to minimize the calls to firebase
*    When a uid is provided to any of the return functions, the controller
*    checks to see if the key is in the map.  If so, it returns the desired
*    value.  If not, it gets the user from firebase and adds them to the map
*    before returning the value.
*/

class UserCredListController {
  late Map<String,UserCred> _userCredMap;
  UserCredListController()
  {
    _userCredMap = {};
  }

  Future<void> _checkForOrAddUserToMap(String userDocId) async
  {
    if(!_userCredMap.containsKey(userDocId))
    {
      UserCred? user = await FirestoreController.getUserCredById(userDocId);
      user ??= UserCred(docId: userDocId,
        username: 'User Not Found',
        email: '',
        photoFilename: '',
        profilePicURL: '',
        timestamp: DateTime.now());

      _userCredMap[userDocId] = user;
      
    }
  }

  //If user has already been added to the map, return their name.
  //  If the aren't in the map, get them from the database,
  //    add them to the map, and then return their name.
  Future<String> getDisplayName(String userDocId) async
  {
    print('awaiting userlookup');
    await _checkForOrAddUserToMap(userDocId);
    print('done with userlookup');

    String? displayName;

    displayName = _userCredMap[userDocId]?.username;

    return displayName ??= 'User Missing';
  }

  // This function was created due to a bug in display a Future<String>
  //  datatype on the screen.  This lets us do this without needing it asynchronously
  String getDisplayNameNoAwait(String userDocId)
  {
    String? displayName;
    displayName = _userCredMap[userDocId]?.username;

    return displayName ??= 'User is missing';
  }
}