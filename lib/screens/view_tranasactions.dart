import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/cashEntry/addtransaction.dart';
import 'package:flutter_myinstalment_application/screens/balanceDetails.dart';

class ViewTransactions extends StatefulWidget {
  final String consumerDocId;
  final int totalCostAmount;

  const ViewTransactions(
      {Key? key, required this.consumerDocId, required this.totalCostAmount})
      : super(key: key);

  @override
  State<ViewTransactions> createState() => _ViewTransactionsState();
}

class _ViewTransactionsState extends State<ViewTransactions> {
  // final paidAmount = transaction['instalment'];

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Transactions"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('consumers')
              .doc(widget.consumerDocId)
              .collection('transaction')
              .orderBy('date', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Container(
                height: 50,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 202, 202, 161),
                  elevation: 25,
                  margin: EdgeInsets.all(9),
                  child: Text(
                    '  Something went Wrong  ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown),
                  ),
                ),
              ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                height: 50,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 202, 202, 161),
                  elevation: 25,
                  margin: EdgeInsets.all(9),
                  child: Text(
                    '  Loading...  ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown),
                  ),
                ),
              ));
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Container(
                height: 50,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 202, 202, 161),
                  elevation: 25,
                  margin: EdgeInsets.all(9),
                  child: Text(
                    '  There is no Transaction Added  ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown),
                  ),
                ),
              ));
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot transaction = snapshot.data!.docs[index];
                  // List myDocCount = snapshot.data!.docs;
                  // var totalStudent = myDocCount.length.toString();
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.green.shade300,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png'),
                      ),
                      title: Text(
                          "The Amount You Transacted : ${transaction['instalment'].toString()}"),
                      subtitle: Text(" on the Date :  ${transaction['date']}"),
                      onTap: () {},
                    ),
                  );
                });
          }),
    );
  }
}
