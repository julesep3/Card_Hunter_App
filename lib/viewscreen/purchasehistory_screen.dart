import 'package:demo_1/controller/firestore_controller.dart';
import 'package:demo_1/model/constant.dart';
import 'package:demo_1/model/price_list.dart';
import 'package:demo_1/model/usercred.dart';
import 'package:demo_1/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//creation of purchase history page
class PurchaseHistoryScreen extends StatefulWidget {
  static const routeName = '/PurchaseHistoryScreen';

  const PurchaseHistoryScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _PurchaseHistoryState();
  }
}

class _PurchaseHistoryState extends State<PurchaseHistoryScreen> {
  //declared variables
  late _Controller con;
  late String profilePicture;
  List<PriceList>? priceList;
  double? total; //price variable

  void initWishlist({required String email}) async {
    priceList = await FirestoreController.getPrices(
        email); //prices identified by email of current user
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          // put image as background
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/commerce.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 0),
                    const Text('Purchase History'),
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
              const SizedBox(height: 18.0),
              Container(
                color: Colors.black45,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      color: Colors.black38,
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
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Qty",
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
                    const SizedBox(height: 18.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: con.getWishlist(),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                  ],
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
  _PurchaseHistoryState state;

  _Controller(this.state) {
    initWishlist();
  }

  void initWishlist() async {
    state.priceList = await FirestoreController.getPrices(
      state.widget.user.email,
    );
    var total =
        0.0; //if there is anything in price list, parse the element into currency format
    if (state.priceList != null) {
      for (var element in state.priceList!) {
        if (element.purchased) {
          total += double.parse(element.price) * element.numOwned;
        }
      }
    }
    state.total = total;
    state.render(() {});
  }

  List<Widget> getWishlist() {
    int count = 0;
    if (state.priceList == null) return [Container()];
    return state.priceList!.map((e) {
      count++;
      if (e.purchased) {
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
}
