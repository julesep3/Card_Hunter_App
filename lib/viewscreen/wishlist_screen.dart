import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/price_list.dart';
import 'package:demo_1/model/scryfall_1.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/card_results_screen.dart';
import 'package:demo_1/viewscreen/confirmation_screen.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'results.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class WishlistScreen extends StatefulWidget {
  static const routeName = '/WishlistScreen';

  const WishlistScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _WishlistState();
  }
}

class _WishlistState extends State<WishlistScreen> {
  late _Controller con;
  late String profilePicture;
  Future<Scryfall>? searchCard;
  List<PriceList>? priceList;
  double? total;
  final TextEditingController _controller = TextEditingController();

  void initWishlist({required String email}) async {
    priceList = await FirestoreController.getPrices(email);
  }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[400],
        onPressed: () => con.searchDialog(),
        child: const Icon(Icons.search),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              // put image as background
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/keebler.jpg'),
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
                        const Text('Wish List'),
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                    color: Colors.black38,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.black45,
                          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              // ignore: prefer_const_constructors
                              Expanded(
                                // ignore: prefer_const_constructors
                                flex: 2,
                                child: const Text(
                                  'Item Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              // ignore: prefer_const_constructors
                              Expanded(
                                // ignore: prefer_const_constructors
                                child: Text(
                                  'Quantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              // ignore: prefer_const_constructors
                              Expanded(
                                child: const Text(
                                  'Price',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: con.getWishlist(),
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        Container(
                          color: Colors.black38,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const SizedBox(width: 16),
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: total != null
                                    ? Text(
                                        total!.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Text('0.00'),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(70, 10, 70, 0),
                    child: Material(
                      child: MaterialButton(
                        onPressed: () {
                          setState(
                            () {
                              con.confirmationScreen(); //call function that navigates to confirmation screen
                            },
                          );
                        },
                        color: Colors.cyan,
                        // height: 50.0,
                        minWidth: double.infinity,
                        child: const Text(
                          "CHECKOUT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //  ),
                ],
              ),
            ),
            // const SizedBox(height: 18.0),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _WishlistState state;

  _Controller(this.state) {
    initWishlist();
    user = state.widget.user;
  }

  late User _user;
  User get user => _user;

  set user(User user) {
    _user = user;
  }

  void initWishlist() async {
    state.priceList = await FirestoreController.getPrices(
        state.widget.user.email); //find the pricelist identified by user email
    var total = 0.0;
    if (state.priceList != null) {
      //if there is anything in pricelist, parse to currency format set by default var
      for (var element in state.priceList!) {
        if (!element.purchased) {
          total += double.parse(element.price) * element.numOwned;
        }
      }
    }
    state.total = total;
    state.render(() {});
  }

  void confirmationScreen() async {
    if (state.priceList != null && state.priceList!.isNotEmpty) {
      for (var x in state.priceList!) {
        if (!x.purchased) {
          await FirestoreController.updatePriceInfo(
              docId: x.docId.toString(),
              updateInfo: {PriceList.PURCHASED: true});
        }
      }
    }
    await Navigator.pushNamed(
      state.context,
      ConfirmationScreen.routeName, //navigate to confirmation screen
      arguments: {
        ArgKey.user: user,
      },
    );
    state.render(() {});
  }

  List<Widget> getWishlist() {
    int count = 0;
    if (state.priceList == null) return [Container()];
    return state.priceList!.map((e) {
      count++;

      if (!e.purchased) {
        num calcPrice = double.parse(e.price) * e.numOwned;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      e.name,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    // width: 60,
                    child: Text(
                      e.numOwned.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      calcPrice.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      } else {
        return const SizedBox(
          height: .1,
        );
      }
    }).toList();
  }

  Future? searchDialog() {
    return showDialog(
      context: state.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Search'),
        content: Container(
          height: 180,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Search for a card:'),
              TextField(
                controller: state._controller,
                decoration: const InputDecoration(hintText: 'Enter Title'),
              ),
              OutlinedButton(
                onPressed: () {
                  state.setState(
                    () {
                      state.searchCard =
                          getCard(state._controller.text.replaceAll(' ', '+'));
                      Navigator.pushNamed(
                        state.context,
                        CardResultsScreen.routeName,
                        arguments: {
                          ArgKey.user: state.widget.user,
                          ArgKey.cardArg: state.searchCard,
                        },
                      );
                    },
                  );
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
