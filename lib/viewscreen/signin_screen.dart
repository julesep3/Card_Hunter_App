import 'package:demo_1/controller/auth_controller.dart';
import 'package:demo_1/viewscreen/home_screen.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/viewscreen/createaccount_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Initial screen of the app
class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  const SignInScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  late _Controller con;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // put image as background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/signIn.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // put Appbar on top of body image
            AppBar(
              title: const Text('Sign In'),
              backgroundColor: Colors.black12,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                // Below: Sign-in Form
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Card Hunter',
                        style: TextStyle(
                          fontFamily: 'Average',
                          fontSize: 55,
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: con.validateEmail,
                        onSaved: con.saveEmail,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        autocorrect: false,
                        validator: con.validatePassword,
                        onSaved: con.savePassword,
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                          onPressed: con.signIn,
                          child: const Text(
                            'Sign In',
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.withOpacity(0.45),
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: con.createAccount,
                        child: Text(
                          'Create New Account',
                          style: Theme.of(context).textTheme.button,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.4),
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
    );
  }
}

class _Controller {
  _SignInState state;
  _Controller(this.state);
  String? email;
  String? password;

  // function to navigate to 'Create New Account' page
  void createAccount() {
    Navigator.pushNamed(state.context, CreateAccountScreen.routeName);
  }

  // function to sign-in user
  void signIn() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    User? user;
    try {
      if (email == null || password == null) {
        throw 'Email or Password is null';
      }
      user = await AuthController.signIn(email: email!, password: password!);
      Navigator.pushNamed(
        state.context,
        HomeScreen.routeName,
        arguments: {
          ArgKey.user: user,
        },
      );
    } catch (e) {
      if (Constant.devMode) print('===========Sign In Error: $e');
      showSnackBar(context: state.context, message: 'Sign In Error: $e');
    }
  }

  // function to validate email
  String? validateEmail(String? value) {
    if (value == null) {
      return 'No email was provided.';
    } else if (!(value.contains('@') && value.contains('.'))) {
      return 'Invalid email.\nMust contain \'.\' and \'@\'.\n(example: janedoe@email.com)';
    } else {
      return null;
    }
  }

  // function to save email (post validation)
  void saveEmail(String? value) {
    if (value != null) {
      email = value;
    }
  }

  // function to validate password
  String? validatePassword(String? value) {
    if (value == null) {
      return 'Password was not provided.';
    } else if (value.length < 6) {
      return 'Password is too short.\nMinimum 6 characters in length.';
    } else {
      return null;
    }
  }

  // function to save password (post validation)
  void savePassword(String? value) {
    if (value != null) {
      password = value;
    }
  }
}
