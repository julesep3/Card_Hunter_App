// import 'package:demo_1/get_project.dart';
import 'package:demo_1/model/thread.dart';
import 'package:demo_1/viewscreen/adminsettings_screen.dart';
import 'package:demo_1/viewscreen/adminusersettings_screen.dart';
import 'package:demo_1/viewscreen/card_results_screen.dart';
import 'package:demo_1/viewscreen/confirmation_screen.dart';
import 'package:demo_1/viewscreen/dm_viewscreen.dart';
import 'package:demo_1/viewscreen/forumthread_screen.dart';
import 'package:demo_1/viewscreen/gameplay_screen.dart';
import 'package:demo_1/viewscreen/gameplaytools_screen.dart';
import 'package:demo_1/viewscreen/home_screen.dart';
// import 'package:demo_1/run_project.dart';
import 'package:demo_1/viewscreen/addthread_screen.dart';
import 'package:demo_1/viewscreen/communityhome_screen.dart';
import 'package:demo_1/viewscreen/createaccount_screen.dart';
import 'package:demo_1/viewscreen/error_screen.dart';
import 'package:demo_1/viewscreen/forum_screen.dart';
import 'package:demo_1/viewscreen/inbox_screen.dart';
import 'package:demo_1/viewscreen/inventory_screen.dart';
import 'package:demo_1/viewscreen/list_results_screen.dart';
import 'package:demo_1/viewscreen/purchasehistory_screen.dart';
import 'package:demo_1/viewscreen/results.dart';
import 'package:demo_1/viewscreen/searchuser_screen.dart';
import 'package:demo_1/viewscreen/set_results_screen.dart';
import 'package:demo_1/viewscreen/signIn_screen.dart';
import 'package:demo_1/viewscreen/usersettings_screen.dart';
import 'package:demo_1/viewscreen/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/constant.dart';
import 'viewscreen/deck_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: '',
    options: const FirebaseOptions(
      apiKey: "",
      appId: "",
      messagingSenderId: "",
      projectId: "",
    ),
  );
  // await Firebase.initializeApp();
  runApp(const CardHunter());
}

class CardHunter extends StatelessWidget {
  const CardHunter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Average',
            fontSize: 20,
          ),
        ),
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for HomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return HomeScreen(user: user);
          }
        },
        CommunityHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to Community Page');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return CommunityHomeScreen(user: user);
          }
        },
        ForumScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to Forum');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return ForumScreen(user: user);
          }
        },
        InboxScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to inbox');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return InboxScreen(user: user);
          }
        },
        SearchUserScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to search user screen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return SearchUserScreen(user: user);
          }
        },
        AddThreadScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to add thread');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return AddThreadScreen(user: user);
          }
        },
        DMScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no user passed to add thread');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var dmRecipientId = argument[ArgKey.dmRecipientId];
            var dmUserId = argument[ArgKey.dmUserId];
            return DMScreen(
              user: user,
              userDocId: dmUserId,
              recipientDocId: dmRecipientId,
            );
          }
        },
        ForumThreadScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('no args passed to forum thread');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var thread = argument[ArgKey.thread];
            return ForumThreadScreen(user: user, thread: thread);
          }
        },
        CardResultsScreen.routeName: (context) => const CardResultsScreen(),
        SetScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for HomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return SetScreen(user: user);
          }
        },
        ListSetScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for HomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return ListSetScreen(user: user);
          }
        },
        // RunProjectScreen.routeName: (context) => const RunProjectScreen(),
        SignInScreen.routeName: (context) => const SignInScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        DeckScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for DeckScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return DeckScreen(user: user);
          }
        },
        UserSettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserSettingsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return UserSettingsScreen(user: user);
          }
        },
        InventoryScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for InventoryScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return InventoryScreen(user: user);
          }
        },
        WishlistScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for WishlistScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return WishlistScreen(user: user);
          }
        },
        ConfirmationScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for ConfirmationScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return ConfirmationScreen(user: user);
          }
        },
        PurchaseHistoryScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for PurchaseHistoryScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return PurchaseHistoryScreen(user: user);
          }
        },
        AdminSettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for AdminSettingsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return AdminSettingsScreen(user: user);
          }
        },
        AdminUserSettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen(
                'args is null for AdminUserSettingsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var userToBeModified = argument[ArgKey.userToBeModified];
            return AdminUserSettingsScreen(
              user: user,
              userToBeModified: userToBeModified,
            );
          }
        },
        GamePlayToolsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for GamePlayToolsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return GamePlayToolsScreen(user: user);
          }
        },
        GamePlayScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for GamePlayToolsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var gamePlaySetup = argument[ArgKey.gamePlaySetup];
            return GamePlayScreen(
              user: user,
              gamePlaySetup: gamePlaySetup,
            );
          }
        },
      },
    );
  }
}

        // textTheme: TextTheme(
        //   bodyLarge: const TextStyle(),
        //   bodyMedium: const TextStyle(),
        //   bodySmall: const TextStyle(),
        //   bodyText1: const TextStyle(),
        //   bodyText2: const TextStyle(),
        // button: const TextStyle(
        //   fontFamily: 'Average',
        // ),
        //   caption: const TextStyle(),
        //   displayLarge: const TextStyle(),
        //   displayMedium: const TextStyle(),
        //   displaySmall: const TextStyle(),
        //   headline1: const TextStyle(),
        //   headline2: const TextStyle(),
        //   headline3: const TextStyle(),
        //   headline4: const TextStyle(),
        //   headline5: const TextStyle(),
        //   headline6: const TextStyle(),
        //   headlineLarge: const TextStyle(),
        //   headlineMedium: const TextStyle(),
        //   headlineSmall: const TextStyle(),
        //   labelLarge: const TextStyle(),
        //   labelMedium: const TextStyle(),
        //   labelSmall: const TextStyle(),
        //   overline: const TextStyle(),
        //   subtitle1: const TextStyle(),
        //   subtitle2: const TextStyle(),
        // *** titleLarge reserved for app-signIn
        // titleLarge: const TextStyle(
        //   fontFamily: 'Average',
        //   fontSize: 55,
        // ),
        //   titleMedium: const TextStyle(),
        //   titleSmall: const TextStyle(),
        // ),