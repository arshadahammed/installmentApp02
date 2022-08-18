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
                    child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      'Balance Amount : $balance',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.brown),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      'Total Cost Amount : ${widget.totalCostAmount}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.brown),
                    ),
                  ),
                ])));
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
      // return (balance);
    });
  }
}
