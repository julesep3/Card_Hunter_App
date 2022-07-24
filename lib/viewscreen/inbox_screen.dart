import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/directmessage.dart';
import 'package:demo_1/viewscreen/forumthread_screen.dart';
import 'package:demo_1/viewscreen/searchuser_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/thread.dart';
import '../model/usercred.dart';
import 'addthread_screen.dart';
import 'dm_viewscreen.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = '/InboxScreen';
  final User user;
  InboxScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return _InboxState();
  }
}

class _InboxState extends State<InboxScreen> {
  late _Controller con;
  late String profilePicture;
  List<Thread>? threadList;
  UserCredListController userCredListController = UserCredListController();
  @override
  void initState() {
    initForumThreads();
    super.initState();

    con = _Controller(this);
    profilePicture = widget.user.photoURL ?? 'No profile picture';
  }

  // initForumThreads() exists because you can't make initState async.
  void initForumThreads() async {
    threadList = await FirestoreController.getForumThreads();
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
            const Text('Inbox'),
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
        // centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addDMButton,
        child: const Icon(Icons.add),
      ),
      body: con.threadList == null || con.threadList?.length == 0
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
              child: const Text('No threads to show'),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              // put image as background
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/cherryBlossom.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: con.threadList!.length,
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
                      title: Text(con.recipientName(con.threadList![index])),
                      subtitle: Column(
                        children: [
                          Text(
                              'Last Updated: ${con.threadList![index].lastUpdated}'),
                        ],
                      ),
                      onTap: () {
                        con.openDirectMessage(con.threadList![index]);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _Controller {
  _InboxState state;
  _Controller(this.state) {
    initDMs();
  }
  late String? userDocId;

  List<DirectMessage>? threadList;
  void initDMs() async {
    List<UserCred> userCredList =
        await FirestoreController.getUserCred(state.widget.user.email);
    userDocId = userCredList[0].docId;
    if (userDocId == null) {
      print('no user with that email found');
      return;
    }
    threadList = await FirestoreController.getDMs(userDocId!);
    if (threadList != null) {
      for (var thread in threadList!) {
        String nonActiveUser = userDocId == thread.participant1
            ? thread.participant2
            : thread.participant1;
        await state.userCredListController.getDisplayName(nonActiveUser);
      }
    }
    state.render(() {});
  }

  void addDMButton() async {
    await Navigator.pushNamed(state.context, SearchUserScreen.routeName,
        arguments: {
          ArgKey.user: state.widget.user,
        });
    initDMs();
  }

  void onThreadTap(Thread thread) async {
    await Navigator.pushNamed(
      state.context,
      ForumThreadScreen.routeName,
      arguments: {ArgKey.user: state.widget.user, ArgKey.thread: thread},
    );
    initDMs();
  }

  String recipientName(DirectMessage directMessage) {
    if (userDocId == null) {
      return '';
    }

    String nonActiveUser = userDocId == directMessage.participant1
        ? directMessage.participant2
        : directMessage.participant1;

    return state.userCredListController.getDisplayNameNoAwait(nonActiveUser);
  }

  // open DMs with a user when tapping their name
  void openDirectMessage(DirectMessage dm) async {
    if (this.userDocId == null) {
      return;
    }
    String recipDocId =
        dm.participant1 == this.userDocId ? dm.participant2 : dm.participant1;
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
