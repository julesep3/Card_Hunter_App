import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'forum_screen.dart';
import 'inbox_screen.dart';

class CommunityHomeScreen extends StatefulWidget {
  static const routeName = '/CommunityHomeScreen';
  final User user;
  CommunityHomeScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return _CommunityHomeState();
  }
}

class _CommunityHomeState extends State<CommunityHomeScreen> {
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
      body: Container(
        // put image as background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/CommunityHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 0,
                  ),
                  const Text('Community Home'),
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
              centerTitle: true,
            ),
            const SizedBox(
              height: 150,
            ),
            ElevatedButton(
              onPressed: con.goToForum,
              child: const Text(
                'Enter The Forum',
                style: TextStyle(
                  fontFamily: 'average',
                  fontSize: 24,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black38,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: con.goToInbox,
              child: const Text(
                'View Your Inbox',
                style: TextStyle(
                  fontFamily: 'average',
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _CommunityHomeState state;
  _Controller(this.state);
  List<UserCred> userCredList = [];
  // navigate to the forum
  void goToForum() async {
    await Navigator.pushNamed(
      state.context,
      ForumScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
      },
    );
  }
  // navigate to the inbox
  void goToInbox() async {
    await Navigator.pushNamed(
      state.context,
      InboxScreen.routeName,
      arguments: {
        ArgKey.user: state.widget.user,
      },
    );
  }
}
