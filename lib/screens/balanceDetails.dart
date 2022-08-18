import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  final int totalCostAmount;
  final int totalPaidAmount;
  final String consumerDocId;
  final int toalBalanceAmount;
  // final int totalNofTransaction;
  final String consumerName;
  const BalanceScreen(
      {Key? key,
      required this.totalCostAmount,
      required this.totalPaidAmount,
      // required this.totalNofTransaction,
      required this.consumerName,
      required this.consumerDocId,
      required this.toalBalanceAmount})
      : super(key: key);

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: balanceAmount(),
          builder: (ctx, snapshot) {
            final balance = snapshot.data.toString();
            return Scaffold(
                appBar: AppBar(
                  title: Text("View Balance Details"),
                ),
                body: Center(
                  child: Container(
                    height: 350,
                    child: Card(
                      color: Color.fromARGB(255, 202, 202, 161),
                      elevation: 50,
                      child: Center(
                          child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            'consumer Name : ${widget.consumerName}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.brown),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            'Total Cost Amount : Rs ${widget.totalCostAmount}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.brown),
                          ),
                        ),
                        //total number of instalments
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: StreamBuilder(
                              // future: totalnumberOfInstalments(),
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('consumers')
                                  .doc(widget.consumerDocId)
                                  .collection('transaction')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  List myDocCount = snapshot.data!.docs;
                                  var totalNoInstalment =
                                      myDocCount.length.toString();

                                  // return Text(totalNoInstalment.toString());
                                  return Text(
                                    'Total Number of Instalments : ${totalNoInstalment.toString()}   ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.brown),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            'Balance Amount : Rs $balance',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.brown),
                          ),
                        ),
                      ])),
                    ),
                  ),
                ));
          }),
    );
  }

  CollectionReference consumers =
      FirebaseFirestore.instance.collection('users');

  Future balanceAmount() async {
    final totalCostAmount = widget.totalCostAmount;

    return consumers
        .doc(user.uid)
        .collection("consumers")
        .doc(widget.consumerDocId)
        .collection("transaction")
        .get()
        .then((QuerySnapshot querySnapshot) {
      int sum = 0;
      int balance = 0;
      querySnapshot.docs.forEach((transactions) {
        int value = transactions["instalment"];
        sum = sum + value;
        balance = totalCostAmount - sum;
      });
      if (balance <= 0) {
        print("you sucessfully Completely the instlament");
        return (0);
      } else {
        return (balance);
      }

      // return (balance);
    });
  }

//totlalinstlalments
  Future totalnumberOfInstalments() async {
    StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('consumers')
          .doc(widget.consumerDocId)
          .collection('transaction')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List myDocCount = snapshot.data!.docs;
          var totalNoInstalment = myDocCount.length.toString();

          print('totalNoInstalment');
          return Text(totalNoInstalment.toString());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
