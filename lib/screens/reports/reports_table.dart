import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportsTable extends StatefulWidget {
  final String consumerDocId;
  final String totalPaidAmount;
  final String totalBalanceAmount;

  const ReportsTable({
    Key? key,
    required this.consumerDocId,
    required this.totalPaidAmount,
    required this.totalBalanceAmount,
  }) : super(key: key);

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  final user = FirebaseAuth.instance.currentUser!;
  // final Stream<QuerySnapshot> consumerStream =
  //      FirebaseFirestore.instance.collection('consumers').snapshots();
  int balance = 0;
  String balanceCal(int bal, bool isAdd) {
    if (isAdd) {
      balance += bal;
    } else {
      balance -= bal;
    }
    return balance.toString();
  }

  String dateFormat(String date) {
    // log(date);
    String dateF =
        date.substring(8) + date.substring(4, 8) + date.substring(0, 4);
    return dateF;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('consumers')
                .doc(widget.consumerDocId)
                .collection('ledger')
                .orderBy("date")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print("Something Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List storedocs = [];
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a['id'] = document.id;
              }).toList();

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.transparent,
                    ),
                    columnWidths: {
                      0: FlexColumnWidth(1.1),
                      1: FlexColumnWidth(.9),
                      2: FlexColumnWidth(.8),
                      3: FlexColumnWidth(1.2),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Container(
                            color: Colors.yellowAccent,
                            child: const Center(
                                child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          )),
                          TableCell(
                              child: Container(
                            color: Colors.greenAccent,
                            child: const Center(
                                child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          )),
                          TableCell(
                              child: Container(
                            color: Colors.greenAccent,
                            child: const Center(
                                child: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          )),
                          TableCell(
                              child: Container(
                            color: Colors.greenAccent,
                            child: const Center(
                                child: Text(
                              'Balance',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          )),
                        ],
                      ),
                      for (var i = 0; i < storedocs.length; i++) ...[
                        TableRow(children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Text(
                                dateFormat(storedocs[i]['date']),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Text(
                                storedocs[i]['description'].toString(),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Text(
                                storedocs[i]['Amount'].toString(),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: storedocs[i]['type'] == "Product"
                                  ? Text(
                                      balanceCal(storedocs[i]['Amount'], true),
                                      style: TextStyle(fontSize: 14.0),
                                    )
                                  : Text(
                                      balanceCal(storedocs[i]['Amount'], false),
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                            ),
                          )),
                        ]),
                      ]
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
