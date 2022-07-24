import 'package:demo_1/controller/auth_controller.dart';
import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/adminusercred.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = './createAccountScreen';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends State<CreateAccountScreen> {
  var formKey = GlobalKey<FormState>();
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
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
              image: AssetImage('images/createAccount.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // App Bar
              AppBar(
                centerTitle: true,
                title: const Text('Create New Account'),
                backgroundColor: Colors.black12,
              ),
              // Create account form (padding)
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 0.0),
                child: Form(
                  key: formKey,
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
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: const Text(
                            'Please enter your information below:',
                            style: TextStyle(
                              fontFamily: 'Average',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: con.validateEmail,
                          onSaved: con.saveEmail,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter password',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          validator: con.validatePassword,
                          onSaved: con.savePassword,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Confirm password',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          validator: con.validatePassword,
                          onSaved: con.saveConfirmedPassword,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: OutlinedButton(
                            onPressed: con.createAccount,
                            child: Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.button,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
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
  _CreateAccountState state;
  _Controller(this.state);
  String? email;
  String? password;
  String? confirmedPassword;
  UserCred newUser = UserCred();
  AdminUserCred adminUserCred = AdminUserCred();

  // function to create the account
  void createAccount() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (password != confirmedPassword) {
      showSnackBar(
        context: state.context,
        seconds: 10,
        message:
            'Password and confirmation password submitted do not match.\nPlease review your password submissions, and submit again.',
      );
      return;
    }

    User? user;
    circularProgressStart(state.context);
    try {
      await AuthController.createAccount(
        email: email!,
        password: password!,
      );
      // get default username from email
      String defaultUsername = email!.split('@')[0];
      user = await AuthController.signIn(
        email: email!,
        password: password!,
      );
      // assign default username to user
      if (user != null) {
        await AuthController.updateDisplayName(
          displayName: defaultUsername,
          user: user,
        );
      }
      // assign info to newUser
      newUser.username = defaultUsername;
      newUser.email = email!;
      newUser.timestamp = DateTime.now();
      // add newUser to Firebase - users_files collection
      String docId = await FirestoreController.addUserCred(userCred: newUser);
      newUser.docId = docId;

      // assign info to adminUserCred
      adminUserCred.email = email!;
      adminUserCred.password = password!;
      // add adminUserCred to Firebase - admin_users_files collection
      await FirestoreController.adminAddUserCred(adminUserCred: adminUserCred);

      // sign out the created user
      await AuthController.signOut();
      showSnackBar(
        context: state.context,
        seconds: 10,
        message:
            'Your account has been successfully created!\nPlease sign in to use the app.',
      );
      circularProgressStop(state.context);
      // pop from CreateAccount_Screen
      Navigator.of(state.context).pop();
    } catch (e) {
      circularProgressStop(state.context);
      if (Constant.devMode) print('============ create account failed: $e');
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Cannot create account: $e',
      );
    }
  }

  // function to validate email
  String? validateEmail(String? value) {
    if (value == null || !(value.contains('@') && value.contains('.'))) {
      return 'Invalid email.\nMust contain \'.\' and \'@\'.\n(example: janedoe@email.com)';
    } else {
      return null;
    }
  }

  // function to save email (post validation)
  void saveEmail(String? value) {
    email = value;
  }

  // function to validate password
  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password is too short.\nMinimum 6 characters in length.';
    } else {
      return null;
    }
  }

  // function to save password (post validation)
  void savePassword(String? value) {
    password = value;
  }

  // function to save confirmationPassword (post validation)
  void saveConfirmedPassword(String? value) {
    confirmedPassword = value;
  }
}
