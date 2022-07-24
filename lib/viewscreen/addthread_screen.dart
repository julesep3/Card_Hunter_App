import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/thread.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/usercred.dart';

class AddThreadScreen extends StatefulWidget {
  static const routeName = '/AddThreadScreen';
  final User user;
  AddThreadScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return _CommunityHomeState();
  }
}

class _CommunityHomeState extends State<AddThreadScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();
  UserCredListController userCredListController = UserCredListController();
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Thread'),
        backgroundColor: Colors.black12,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: con.makeNewThread,
            icon: const Icon(Icons.check),
          ),
        ],
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
          child: Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: Colors.white30),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 200),
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.white10),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      autocorrect: true,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: Thread.validateTitle,
                      onSaved: con.saveTitle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.white10),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      autocorrect: true,
                      decoration: const InputDecoration(
                          hintText: 'Post Thread Content Here'),
                      keyboardType: TextInputType.multiline,
                      validator: Thread.validatePostContent,
                      maxLines: 12,
                      onSaved: con.saveContent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _CommunityHomeState state;
  _Controller(this.state);

  String? threadTitle;
  String? threadContent;

  //
  void makeNewThread() async {
    print('attempting new thread with following user email');
    print(state.widget.user.email);
    List<UserCred> userCredList =
        await FirestoreController.getUserCred(state.widget.user.email);
    String? userDocId = userCredList[0].docId!;
    if (userDocId == null) {
      showSnackBar(context: state.context, message: 'User Doc ID is null');
      return;
    }
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();

    // validate data
    DateTime rightNow = DateTime.now();
    print('one');
    if (threadTitle == null) return;
    print('two');
    if (threadContent == null) return;
    print('three');
    // make a new Thread
    Thread forumThread = Thread();
    forumThread.title = threadTitle!;
    forumThread.firstPosted = rightNow;
    forumThread.lastUpdated = rightNow;
    forumThread.threadAuthor = userDocId;

    // make a post
    Map<String, dynamic> post = {
      Thread.CONTENT: threadContent!,
      Thread.POSTAUTHOR: userDocId,
      Thread.TIMEPOSTED: rightNow,
    };
    // add the post to the thread
    forumThread.posts.add(post);

    // send the thread to firebase
    try {
      await FirestoreController.createNewThread(thread: forumThread);
    } catch (e) {
      print('=== thread creation failed: $e');
    }
    Navigator.pop(state.context);
  }
  
  void saveTitle(String? value) {
    if (value != null) threadTitle = value;
  }

  void saveContent(String? value) {
    if (value != null) threadContent = value;
  }
}
