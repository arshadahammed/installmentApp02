import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/addConsumer/addConsumer.dart';
import 'package:flutter_myinstalment_application/screens/cashEntry/viewconsumer2.dart';
import 'package:flutter_myinstalment_application/screens/cashEntry/addtransaction.dart';
import 'package:flutter_myinstalment_application/screens/productEntry/view_complete_consumer2.dart';
import 'package:flutter_myinstalment_application/screens/productEntry/viewconsumer1.dart';
import 'package:flutter_myinstalment_application/screens/reports/reports_table.dart';
import 'package:flutter_myinstalment_application/screens/reports/viewconsumer3.dart';
import 'package:flutter_myinstalment_application/screens/view_tranasactions.dart';
import 'package:flutter_myinstalment_application/screens/sidebar/navbar.dart';
import 'package:flutter_myinstalment_application/screens/productEntry/viewconsumer1.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // User? user = FirebaseAuth.instance.currentUser;
  // UserModel loggedInUser = UserModel();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? displayName;
  Future userDetails() async {
    final user = await FirebaseAuth.instance.currentUser!;
    setState(() {
      displayName = user.displayName;
    });
  }

  DateTime pre_backpress = DateTime.now();

  // int _currentSelectedIndex = 0;
  // final _pages = [
  //   HomeScreen(),
  //   AddConsumer(),
  //   InvokeEntry(),
  // ];

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   setState(() {});
    // });
    userDetails();
  }

  Widget build(BuildContext context) {
    //gonna give total height nd width of device
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        print('$timegap');
        final canExit = timegap >= Duration(seconds: 2);

        pre_backpress = DateTime.now();
        if (canExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('FINCORP'),
        ),

        //bottom navigaation
        // body: _pages[_currentSelectedIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _currentSelectedIndex,
        //   onTap: (newIndex) {
        //     setState(() {
        //       _currentSelectedIndex = newIndex;
        //     });
        //   },
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        //   ],
        // ),
        body: Stack(
          children: <Widget>[
            Container(
              //here the height of the container is  45% of  our total height
              height: size.height * .45,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Align(
                        // alignment: Alignment.topLeft,
                        // child: Container(
                        //   alignment: Alignment.center,
                        //   height: 52,
                        //   width: 52,
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFF2BEA1),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: SvgPicture.asset("assets/icons/menu.svg"),
                        // ),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text(
                      'Welcome ${displayName ?? ""}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.blueGrey,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 30),
                    //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(29.5),
                    //   ),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //         hintText: "Search",
                    //         icon: SvgPicture.asset("assets/icons/search.svg"),
                    //         border: InputBorder.none),
                    //   ),
                    // ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: .95,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: <Widget>[
                          //Add Consumer
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 212, 216, 218),
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: -23,
                                    color: Colors.orangeAccent,
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddConsumer()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Image.asset(
                                          "assets/icons/addcunsumer.png",
                                          height: 80,
                                          width: 90,
                                        ),
                                        Spacer(),
                                        Text(
                                          "Add Consumer",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //view consumer/invoice entry
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 212, 216, 218),
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: -23,
                                    color: Colors.orangeAccent,
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewConsumer11(),
                                            settings: RouteSettings(
                                                name: "/viewConsumerList")));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Image.asset(
                                          "assets/icons/invoiceproduct.png",
                                          height: 80,
                                          width: 90,
                                        ),
                                        Spacer(),
                                        Text(
                                          "Invoice Product",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //invoke entry
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(13),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(13),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           offset: Offset(0, 17),
                          //           blurRadius: 17,
                          //           spreadRadius: -23,
                          //           color: Colors.orangeAccent,
                          //         )
                          //       ],
                          //     ),
                          //     child: Material(
                          //       color: Colors.transparent,
                          //       child: InkWell(
                          //         onTap: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => InvokeEntry()));
                          //         },
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(20.0),
                          //           child: Column(
                          //             children: <Widget>[
                          //               Spacer(),
                          //               SvgPicture.asset(
                          //                   "assets/icons/Settings.svg"),
                          //               Spacer(),
                          //               Text(
                          //                 "Product Details",
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 20,
                          //                     fontWeight: FontWeight.w700),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          //Transactions

                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 212, 216, 218),
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: -23,
                                    color: Colors.orangeAccent,
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewConsumer2()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Image.asset(
                                          "assets/icons/cashentry.png",
                                          height: 80,
                                          width: 90,
                                        ),
                                        Spacer(),
                                        Text(
                                          "Cash Entry",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //Reports

                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 212, 216, 218),
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: -23,
                                    color: Colors.orangeAccent,
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewConsumer3()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Image.asset(
                                          "assets/icons/report.png",
                                          height: 80,
                                          width: 90,
                                        ),
                                        Spacer(),
                                        Text(
                                          "Report",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
