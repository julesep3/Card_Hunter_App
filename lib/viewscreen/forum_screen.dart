import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/controller/usercredlist_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/viewscreen/forumthread_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/thread.dart';
import 'addthread_screen.dart';

class ForumScreen extends StatefulWidget {
  static const routeName = '/ForumScreen';
  final User user;
  ForumScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return _CommunityHomeState();
  }
}

class _CommunityHomeState extends State<ForumScreen> {
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
            const Text('Forum'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: con.addThreadButton,
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
                      title: Text(con.threadList![index].title),
                      subtitle: Column(
                        children: [
                          Text(
                              'Posted by: ${userCredListController.getDisplayNameNoAwait(con.threadList![index].threadAuthor)}'),
                          Text(
                              'First Posted: ${con.threadList![index].firstPosted}'),
                          Text(
                              'Last Updated: ${con.threadList![index].lastUpdated}'),
                        ],
                      ),
                      onTap: () {
                        con.onThreadTap(con.threadList![index]);
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
  _CommunityHomeState state;
  _Controller(this.state) {
    initForumThreads();
  }

  List<Thread>? threadList;
  // get the forum threads from firestore so that way we can display them
  //  can also be used to refresh the forum threads after a page load,
  //  like after submitting a new thread
  void initForumThreads() async {
    threadList = await FirestoreController.getForumThreads();
    if (threadList != null) {
      for (var thread in threadList!) {
        await state.userCredListController.getDisplayName(thread.threadAuthor);
      }
    }
    state.render(() {});
  }

  // Takes us to the page where we can make a new thread
  void addThreadButton() async {
    await Navigator.pushNamed(
      state.context,
      AddThreadScreen.routeName,
      arguments: {ArgKey.user: state.widget.user},
    );
    initForumThreads(); // refreshes the threads so a user's new thread appears
  }

  // open the thread when tapped.
  void onThreadTap(Thread thread) async {
    await Navigator.pushNamed(
      state.context,
      ForumThreadScreen.routeName,
      arguments: {ArgKey.user: state.widget.user, ArgKey.thread: thread},
    );
    initForumThreads(); // refreshes the threads so a user's newly update version of the thread appears
  }
}
