import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/thread.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/usercred.dart';
import '../model/directmessage.dart';

class DMScreen extends StatefulWidget {
  static const routeName = '/dMViewScreen';

  final User user;
  final String userDocId;
  final String recipientDocId;

  DMScreen(
      {required this.user,
      required this.userDocId,
      required this.recipientDocId});

  @override
  State<StatefulWidget> createState() {
    return _DMState();
  }
}

class _DMState extends State<DMScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  UserCredListController userCredListController = UserCredListController();

  late _Controller con;
  late String profilePicture;

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
            const Text('Viewing Messages'),
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
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // put image as background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/lava.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            con.dmList == null || con.dmList.length == 0
                ? const Text('Nothing to show yet')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: con.dmList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          border: Border.all(color: Colors.white30),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ListTile(
                          title: Text(
                              '${userCredListController.getDisplayNameNoAwait(con.dmList[index][DirectMessage.MESSAGEAUTHOR])} says:'),
                          subtitle: Column(
                            children: [
                              Text(
                                  '${con.dmList[index][DirectMessage.CONTENT]}'),
                              Text(
                                  'Sent: ${DateTime.fromMillisecondsSinceEpoch(con.dmList[index][DirectMessage.TIMESENT].millisecondsSinceEpoch)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              decoration: BoxDecoration(
                color: Colors.black45,
                border: Border.all(color: Colors.white30),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: con.saveNewPost,
                      controller: con.textController,
                      validator: con.validatePostContent,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          hintText: 'Type your message here!'),
                    ),
                    ElevatedButton(
                      onPressed: con.sendMessage,
                      child: const Text('Send'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Controller {
  _DMState state;
  List<Map<String, dynamic>> dmList = [];
  DirectMessage? directMessageChain;
  final textController = TextEditingController();
  _Controller(this.state) {
    initUserNames();
    initDirectMessages();
  }

  // gets all of the usernames on the page and makes sure they are in the usercredlistcontroller object
  void initUserNames() async {
    await state.userCredListController.getDisplayName(state.widget.userDocId);
    await state.userCredListController
        .getDisplayName(state.widget.recipientDocId);
    state.render(() {});
  }

  // get and display direct messages if they are on the server
  void initDirectMessages() async {

    print('in initDirectMessages()');
    // get the direct message list, if it exists
    directMessageChain = await FirestoreController.getDirectMessage(
      state.widget.userDocId,
      state.widget.recipientDocId,
    );

    if (directMessageChain != null) {
      dmList = directMessageChain!.messages;
    }
    state.render(() {}); // refresh the screen
  }

  String? newPostContent;

  
  void saveNewPost(String? value) {
    if (value != null) newPostContent = value;
  }

  // called to make sure the dm fits our criteria
  String? validatePostContent(String? value) {
    if (value == null || value.length < 3) {
      return 'DM is too short.';
    } else {
      return null;
    }
  }

  // submits the message to firebase and then updates the screen
  void sendMessage() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();
    // if this is the first dm to be sent
    DateTime rightNow = DateTime.now();
    // if this is the first dm, we'll need to make a new DM object
    if (directMessageChain == null) {
      //initialize it with all of the data that can be gathered from here
      DirectMessage newDirectMessage = DirectMessage();
      String participant1;
      String participant2;
      if (state.widget.userDocId.compareTo(state.widget.recipientDocId) >= 0) {
        participant1 = state.widget.userDocId;
        participant2 = state.widget.recipientDocId;
      } else {
        participant1 = state.widget.recipientDocId;
        participant2 = state.widget.userDocId;
      }

      newDirectMessage.participant1 = participant1;
      newDirectMessage.participant2 = participant2;
      newDirectMessage.lastUpdated = rightNow;
      newDirectMessage.messages = [
        {
          DirectMessage.CONTENT: newPostContent,
          DirectMessage.MESSAGEAUTHOR: state.widget.userDocId,
          DirectMessage.TIMESENT: rightNow,
        }
      ];
      // send it to firestore
      await FirestoreController.createNewDirectMessage(
          directMessage: newDirectMessage);
    }
    //if this is a reply
    else {
      Map<String, dynamic> message = {
        DirectMessage.CONTENT: newPostContent,
        DirectMessage.MESSAGEAUTHOR: state.widget.userDocId,
        DirectMessage.TIMESENT: rightNow,
      };
      // send it to firestore
      await FirestoreController.replyToDirectMessage(
          directMessageId: directMessageChain!.docId!, message: message);
    }
    initDirectMessages(); // refresh the dm from what is on the server
    textController.clear(); // clear the textbox
    state.render(() {}); // refresh the screen
  }
}
