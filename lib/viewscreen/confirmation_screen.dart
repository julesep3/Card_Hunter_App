import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/home_screen.dart';
import 'package:demo_1/viewscreen/purchasehistory_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'forum_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  static const routeName = '/ConfirmationScreen';
  const ConfirmationScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _ConfirmationState();
  }
}

class _ConfirmationState extends State<ConfirmationScreen> {
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/checkout.jpg'),
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
                    const Text('Order Confirmation'),
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
              const SizedBox(
                height: 25,
              ),
              const Text(
                  "Your purchase was successfully completed. You may now exit this page."),
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      con.goToHome();
                    },
                  );
                },
                color: Colors.cyan,
                height: 30.0,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Text(
                  "RETURN HOME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      con.goToPurchaseHistory();
                    },
                  );
                },
                color: Colors.cyan,
                height: 30.0,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Text(
                  "PURCHASE HISTORY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
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
  _ConfirmationState state;
  _Controller(this.state) {
    user = state.widget.user;
  }
  late User _user;

  User get user => _user;

  set user(User user) {
    _user = user;
  }

  void goToHome() async {
    // await Navigator.pushNamed(
    //   state.context,
    //   HomeScreen.routeName,
    //   arguments: {
    //     ArgKey.user: user,
    //   },
    // );
    // state.render(() {});

    // code added by Julian below
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
  }

  void goToPurchaseHistory() async {
    // code added by Julian below
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();

    // original code below
    await Navigator.pushNamed(
      state.context,
      PurchaseHistoryScreen.routeName,
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }
}
