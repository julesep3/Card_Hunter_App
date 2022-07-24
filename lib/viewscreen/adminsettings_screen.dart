import 'dart:io';

import 'package:demo_1/controller/auth_controller.dart';
import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/adminusercred.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/adminusersettings_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';

class AdminSettingsScreen extends StatefulWidget {
  static const routeName = './adminSettingsScreen';
  const AdminSettingsScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _AdminSettingsState();
  }
}

class _AdminSettingsState extends State<AdminSettingsScreen> {
  late _Controller con;
  late String email;
  late String username;
  late String profilePicture;
  File? photo;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    username = widget.user.displayName ?? 'No username';
    profilePicture = widget.user.photoURL ?? '';
  }

  void render(fn) => setState(fn);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Below: App Bar
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 0,
            ),
            const Text('Admin Settings'),
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 18,
              child: CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(profilePicture),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black12,
      ),
      // Builder to dynamically show each user (username/email) in a card
      body: con.userCredentialsList == null ||
              con.userCredentialsList?.length == 0
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // put image as background
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/cherryBlossom.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Text('No Users Available'),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              // put image as background
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/admin.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                  itemCount: con.userCredentialsList!.length,
                  itemBuilder: (context, index) {
                    return con.userCredentialsList![index].username !=
                            'userHasBeenDeleted'
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              border: Border.all(color: Colors.white30),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            margin: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                            child: ListTile(
                              title: Text(
                                  con.userCredentialsList![index].username),
                              subtitle:
                                  Text(con.userCredentialsList![index].email),
                              onTap: con.userCredentialsList![index].username !=
                                      'userHasBeenDeleted'
                                  ? () {
                                      con.navToAdminUserSettings(con
                                          .userCredentialsList![index].email);
                                    }
                                  : () {},
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          );
                  }),
            ),
    );
  }
}

class _Controller {
  late _AdminSettingsState state;
  _Controller(this.state) {
    getUsers();
  }
  List<UserCred>? userCredentialsList = [];
  List<AdminUserCred> adminUserCredList = [];

  // function to get all the user credentials
  void getUsers() async {
    userCredentialsList = [];
    userCredentialsList = await FirestoreController.getAllUserCreds();
    state.render(() {});
  }

  // function to navigate to admin user settings page
  void navToAdminUserSettings(String userEmail) async {
    User? user;
    try {
      // get admin's user cred list
      adminUserCredList.clear();
      adminUserCredList = await FirestoreController.adminGetUserCred(userEmail);
      // sign in as user to be modified by admin
      user = await AuthController.signIn(
        email: adminUserCredList[0].email,
        password: adminUserCredList[0].password,
      );
    } catch (e) {
      if (Constant.devMode) print('============ user sign in failed: $e');
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Cannot sign in user account: $e',
      );
    }

    await Navigator.pushNamed(
      state.context,
      AdminUserSettingsScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.userToBeModified: user,
      },
    );
  }
}
