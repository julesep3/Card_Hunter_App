import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'dm_viewscreen.dart';

class SearchUserScreen extends StatefulWidget {
  static const routeName = '/SearchUserScreen';
  final User user;
  SearchUserScreen({required this.user});
  List<UserCred> userCredList = [];
  @override
  State<StatefulWidget> createState() {
    return _SearchUserState();
  }
}

class _SearchUserState extends State<SearchUserScreen> {
  late _Controller con;
  UserCredListController userCredListController = UserCredListController();
  late String profilePicture;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    profilePicture = widget.user.photoURL ?? 'No profile picture';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 0,
            ),
            const Text('Search For A User'),
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/cherryBlossom.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'User search query (empty for all)',
                          fillColor: Colors.black26,
                          filled: true,
                        ),
                        autocorrect: true,
                        onSaved: con.saveSearchKey,
                      ),
                    ),
                    IconButton(
                      onPressed: con.search,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              widget.userCredList.isEmpty
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        border: Border.all(color: Colors.white30),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Text('No users to show'),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: widget.userCredList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              border: Border.all(color: Colors.white30),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: ListTile(
                              title: Text(
                                  userCredListController.getDisplayNameNoAwait(
                                      widget.userCredList[index].docId!)),
                              subtitle: Column(
                                children: [
                                  Text(
                                      'eMail: ${widget.userCredList[index].email}'),
                                ],
                              ),
                              onTap: () {
                                con.openDirectMessage(
                                    widget.userCredList[index].docId!);
                              },
                            ),
                          );
                        },
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
  _SearchUserState state;
  _Controller(this.state);
  String? searchKeyString;

  // called on form save
  void saveSearchKey(String? value) {
    searchKeyString = value;
  }

  // take the string query from the search bar,
  //  run the user search from the FirstoreController class
  //  then display the users on the screen.
  void search() async {
    print('here');
    print(searchKeyString);
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    currentState.save();

    // send the query to firebase
    try {
      late List<UserCred> results;
      results = await FirestoreController.searchUser(searchKeyString);
      for (UserCred u in results) {
        await state.userCredListController.getDisplayName(u.docId!);
      }
      // update the search results on the screen
      state.render(() => state.widget.userCredList = results);
    } catch (e) {
      print('whoops');
    }
  }

  // called when the user taps ona displayed user.
  //    this function navigates to the appropriate direct message page for the user
  void openDirectMessage(String recipDocId) async {
    List<UserCred> userCredList =
        await FirestoreController.getUserCred(state.widget.user.email);
    String? userDocId = userCredList[0].docId;
    if (userDocId == null) {
      showSnackBar(context: state.context, message: 'User Doc ID is null');
      return;
    }

    Navigator.pushNamed(
      state.context,
      DMScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
        ArgKey.dmUserId: userDocId,
        ArgKey.dmRecipientId: recipDocId
      },
    );
  }
}
