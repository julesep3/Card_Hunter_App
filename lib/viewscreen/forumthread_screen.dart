import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/thread.dart';
import 'package:demo_1/viewscreen/dm_viewscreen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/usercred.dart';

class ForumThreadScreen extends StatefulWidget {
  static const routeName = '/forumThreadScreen';

  final User user;
  final Thread thread;

  ForumThreadScreen({required this.user, required this.thread});

  @override
  State<StatefulWidget> createState() {
    return _ForumThreadState();
  }
}

class _ForumThreadState extends State<ForumThreadScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  UserCredListController userCredListController = UserCredListController();

  late _Controller con;
  late String profilePicture;

  @override
  void initState() {
    super.initState();
    for (var post in widget.thread.posts) {
      print(post[Thread.CONTENT]);
      print(post[Thread.POSTAUTHOR]);
      print(post[Thread.TIMEPOSTED]);
    }
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
            const Text('Viewing Thread'),
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/lava.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.thread.posts.length,
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
                    title: InkWell(
                      child: Text(userCredListController.getDisplayNameNoAwait(
                          widget.thread.posts[index][Thread.POSTAUTHOR])),
                      onTap: () {
                        /*print(widget.thread.posts[index][Thread.POSTAUTHOR]*/
                        con.openDirectMessage(
                            widget.thread.posts[index][Thread.POSTAUTHOR]);
                      },
                    ),
                    subtitle: Column(
                      children: [
                        Text('${widget.thread.posts[index][Thread.CONTENT]}'),
                        Text(
                            'Posted at: ${DateTime.fromMillisecondsSinceEpoch(widget.thread.posts[index][Thread.TIMEPOSTED].millisecondsSinceEpoch)}'),
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
                      validator: con.validatePostContent,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          hintText: 'Type your reply here!'),
                    ),
                    ElevatedButton(
                      onPressed: con.submitPost,
                      child: const Text('Make Post'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white.withOpacity(0.15),
                      ),
                    )
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
  _ForumThreadState state;
  _Controller(this.state) {
    initUserNames();
  }

  // use the user doc ids to get their names and
  // add them to the usercredlist so we can use them
  // without being asynchronous later.
  void initUserNames() async {
    for (var post in state.widget.thread.posts) {
      await state.userCredListController
          .getDisplayName(post[Thread.POSTAUTHOR]);
    }
    state.render(() {});
  }

  String? newPostContent;

  void saveNewPost(String? value) {
    if (value != null) newPostContent = value;
  }

  // check the post content to see if it is long enough
  String? validatePostContent(String? value) {
    if (value == null || value.length < 3) {
      return 'Post is too short.';
    } else {
      return null;
    }
  }

  // open DMs with a user when tapping their name
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

  // submits the post and updates the thread in firestore
  void submitPost() async {
    List<UserCred> userCredList =
        await FirestoreController.getUserCred(state.widget.user.email);
    String? userDocId = userCredList[0].docId;
    if (userDocId == null) {
      showSnackBar(context: state.context, message: 'User Doc ID is null');
      return;
    }
    print('In submitPost()');
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    // take the post and turn it into a map that we can send to Firestore
    Map<String, dynamic> newPost = {
      Thread.CONTENT: newPostContent!,
      Thread.POSTAUTHOR: userDocId,
      Thread.TIMEPOSTED: DateTime.now(),
    };

    print(state.widget.thread.docId);
    print(newPost);

    // send it to firestore
    await FirestoreController.replyToThread(
        threadId: state.widget.thread.docId!, post: newPost);
    // return to the previous screen
    Navigator.pop(state.context);
  }
}
