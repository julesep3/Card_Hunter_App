import 'dart:io';
import 'package:demo_1/controller/auth_controller.dart';
import 'package:demo_1/controller/cloudstorage_controller.dart';
import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/adminusercred.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/deck.dart';
import 'package:demo_1/model/magic_card.dart';
import 'package:demo_1/model/price_list.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminUserSettingsScreen extends StatefulWidget {
  static const routeName = './adminUserSettingsScreen';
  const AdminUserSettingsScreen(
      {required this.user, required this.userToBeModified, Key? key})
      : super(key: key);
  final User user;
  final User userToBeModified;
  @override
  State<StatefulWidget> createState() {
    return _AdminUserSettingsState();
  }
}

class _AdminUserSettingsState extends State<AdminUserSettingsScreen> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  late _Controller con;
  late String email;
  late String username;
  late String profilePicture;
  File? photo;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.userToBeModified.email ?? 'No email';
    username = widget.userToBeModified.displayName ?? 'No username';
    profilePicture = widget.userToBeModified.photoURL ?? '';

    // con.getUsersCredentials();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/AdminUserSettings.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Below: App Bar
              AppBar(
                title: const Text('Admin Access - User Settings'),
                centerTitle: true,
                backgroundColor: Colors.black12,
              ),
              // Below: Profile Picture Circle (Stack)
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 35),
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: FittedBox(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        // if no loaded photo and no saved profile pic
                        child: photo == null && profilePicture == ''
                            ? const FittedBox(
                                child: CircleAvatar(
                                  // backgroundImage: NetworkImage(profilePicture),
                                  backgroundColor: Colors.black45,
                                  maxRadius: 19,
                                ),
                              )
                            : photo != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(photo!),
                                    backgroundColor: Colors.purpleAccent,
                                    maxRadius: 19,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(profilePicture),
                                    backgroundColor: Colors.purpleAccent,
                                    maxRadius: 19,
                                  ),
                      ),
                    ),
                  ),
                  // Below: button to choose profile picture update
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40),
                        ),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: PopupMenuButton(
                        onSelected: con.getPhoto,
                        itemBuilder: (context) => [
                          for (var source in PhotoSource.values)
                            PopupMenuItem(
                              value: source,
                              child: Text('${source.toString().split('.')[1]}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Below: Account Information Box (Padding)
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),
                child: Form(
                  key: formKey1,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(color: Colors.white30),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$username\'s Account',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        TextFormField(
                          initialValue: username,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: con.validateUsername,
                          onSaved: con.saveUsername,
                        ),
                        TextFormField(
                          initialValue: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: con.validateEmail,
                          onSaved: con.saveEmail,
                        ),
                        ElevatedButton(
                          onPressed: con.saveChanges,
                          child: Text(
                            'Save Changes',
                            style: Theme.of(context).textTheme.button,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Below: 'Delete User Account' button
              ElevatedButton(
                onPressed: con.deleteAccount,
                child: Text(
                  'Delete User Account',
                  style: Theme.of(context).textTheme.button,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _AdminUserSettingsState state;
  _Controller(this.state);
  String? email;
  String? username;
  String? password;
  String? confirmationPassword;
  String? progressMessage;
  List<UserCred> userCredList = [];
  List<AdminUserCred> adminUserCredList = [];

  // Below: FormKey1 Functions
  void saveChanges() async {
    FormState? currentState = state.formKey1.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    // update user account info
    circularProgressStart(state.context);
    try {
      // get user credentials for user to be modified
      userCredList.clear();
      userCredList = await FirestoreController.getUserCred(state.email);

      // get admin's user cred list for user to be modified
      adminUserCredList.clear();
      adminUserCredList =
          await FirestoreController.adminGetUserCred(state.email);

      User? user = await AuthController.signIn(
        email: adminUserCredList[0].email,
        password: adminUserCredList[0].password,
      );

      // update username
      if (username != state.widget.userToBeModified.displayName) {
        await AuthController.updateDisplayName(
          displayName: username!,
          user: user!,
        );
        await FirestoreController.updateUserCred(
          docId: userCredList[0].docId!,
          updateInfo: {UserCred.USERNAME: username},
        );
      }

      // update email
      if (email != state.widget.userToBeModified.email) {
        // update each price's (wishlist) email
        List<PriceList> priceList = await FirestoreController.getPrices(
            state.widget.userToBeModified.email);
        for (int i = 0; i < priceList.length; i++) {
          await FirestoreController.updatePriceInfo(
            docId: priceList[i].docId!,
            updateInfo: {PriceList.EMAIL: email},
          );
        }
        // update each card's email
        List<MagicCard>? cardList = await FirestoreController.getCards(
            state.widget.userToBeModified.email);
        for (int i = 0; i < cardList.length; i++) {
          await FirestoreController.updateCardInfo(
            docId: cardList[i].docId!,
            updateInfo: {MagicCard.EMAIL: email},
          );
        }
        // update each deck's email
        List<Deck> deckList = await FirestoreController.getDecks(
            state.widget.userToBeModified.email);
        for (int i = 0; i < deckList.length; i++) {
          await FirestoreController.updateDeckInfo(
            docId: deckList[i].docId!,
            updateInfo: {Deck.USEREMAIL: email},
          );
        }
        // update Firebase Authentication User email
        await AuthController.updateEmail(
          email: email!,
          user: user!,
        );
        // update 'users_files' email
        await FirestoreController.updateUserCred(
          docId: userCredList[0].docId!,
          updateInfo: {UserCred.EMAIL: email},
        );
        // update 'admin_users_files' email
        await FirestoreController.adminUpdateUserCred(
          docId: adminUserCredList[0].docId!,
          updateInfo: {AdminUserCred.EMAIL: email},
        );
      }

      // upload profile pic to Cloud Storage
      if (state.photo != null) {
        Map photoInfo = await CloudStorageController.uploadPhotoFile(
          photo: state.photo!,
          uid: state.widget.user.uid,
          listener: (int progress) {
            state.render(() {
              if (progress == 100)
                progressMessage = null;
              else
                progressMessage = 'Uploading $progress %';
            });
          },
        );
        await AuthController.updatePhotoURL(
          photoURL: photoInfo[ArgKey.downloadURL],
          user: user!,
        );
        await FirestoreController.updateUserCred(
          docId: userCredList[0].docId!,
          updateInfo: {
            UserCred.PROFILEPICURL: photoInfo[ArgKey.downloadURL],
            UserCred.PHOTOFILENAME: photoInfo[ArgKey.filename],
          },
        );
      }
      circularProgressStop(state.context);

      // pop out of app
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'The user\'s account information has been updated.',
      );
      // logoutUser();
    } catch (e) {
      circularProgressStop(state.context);
      if (Constant.devMode) {
        print('=============== Update User Account Error: $e');
      }
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Update User Account Error: $e',
      );
    }
  }

  // function to get the photo from the source
  void getPhoto(PhotoSource source) async {
    try {
      var imageSource = source == PhotoSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return; // cancelled by camera or gallery
      state.render(() => state.photo = File(image.path));
      showSnackBar(
        context: state.context,
        message:
            '''Selected profile picture for preview only until you select <Save Changes>''',
      );
    } catch (e) {
      if (Constant.devMode) {
        print('=============== Get Photo Error: $e');
      }
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Get Photo Error: $e',
      );
    }
  }

  // function to validate username
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty || value.length > 16) {
      return 'Invalid username (must be 1 - 16 characters)';
    } else {
      return null;
    }
  }

  // function to validate email
  String? validateEmail(String? value) {
    if (value == null || !(value.contains('.') && value.contains('@'))) {
      return 'Invalid email.\nMust contain \'.\' and \'@\'.\n(example: janedoe@email.com)';
    } else {
      return null;
    }
  }

  // function to save email (post validation)
  void saveEmail(String? value) {
    email = value;
  }

  // function to save username (post validation)
  void saveUsername(String? value) {
    username = value;
  }

  // Below: delete account function
  void deleteAccount() async {
    circularProgressStart(state.context);
    try {
      // get user credentials
      userCredList.clear();
      userCredList = await FirestoreController.getUserCred(state.email);

      // get admin's user cred list
      adminUserCredList.clear();
      adminUserCredList =
          await FirestoreController.adminGetUserCred(state.email);

      // update Firebase 'users_files' collection of account deletion
      await FirestoreController.updateUserCred(
        docId: userCredList[0].docId!,
        updateInfo: {
          UserCred.EMAIL: 'userHasBeenDeleted@.com',
          UserCred.USERNAME: 'userHasBeenDeleted',
          UserCred.PHOTOFILENAME: '',
          UserCred.PROFILEPICURL: '',
        },
      );

      // update Firebase 'admin_users_files' collection of account deletion
      await FirestoreController.adminUpdateUserCred(
        docId: adminUserCredList[0].docId!,
        updateInfo: {
          AdminUserCred.EMAIL: 'userHasBeenDeleted@.com',
          AdminUserCred.PASSWORD: 'xxx',
        },
      );

      // delete account from Firebase Authentication
      await AuthController.delete(
        user: state.widget.userToBeModified,
      );

      circularProgressStop(state.context);
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: '${state.username}\'s account has been deleted.',
      );
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
    } catch (e) {
      circularProgressStop(state.context);
      if (Constant.devMode) print('=============== Delete Account Error: $e');
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Delete Account Error: $e',
      );
    }
  }
}
