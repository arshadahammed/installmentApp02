import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/cashEntry/addtransaction.dart';
import 'package:flutter_myinstalment_application/screens/productEntry/view_complete_consumer2.dart';

class ViewConsumer11 extends StatefulWidget {
  const ViewConsumer11({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewConsumer11> createState() => _ViewConsumer11State();
}

class _ViewConsumer11State extends State<ViewConsumer11> {
  String name = "";
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search Consumer',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.person_search)),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder(
            stream: (name != "" && name != null)
                ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('consumers')
                    .where("fullName", isEqualTo: name)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('consumers')
                    // .where("clientKey", isEqualTo: )
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
                      '  Something Went Wrong  ',
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
                      '  There are no Consumers Added  ',
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
                    DocumentSnapshot consumer = snapshot.data!.docs[index];
                    final int totalAmountofProducts =
                        consumer['TotalAmountofProducts'];
                    final int openingBalance = consumer['openingBalance'];
                    final int totalPaidAmount = consumer['TotalPaidAmount'];
                    int value1 = totalAmountofProducts + openingBalance;
                    final int balance = value1 - totalPaidAmount;
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/1177/1177568.png'),
                        ),
                        // title: Text(consumer['fullName']),
                        title: Row(
                          children: [
                            Expanded(child: Text(consumer['fullName'])),

                            //side il closing balance
                            Expanded(
                                child: Text(
                              'Balance :${balance}',
                              textAlign: TextAlign.end,
                            ))
                          ],
                        ),
                        subtitle: Text(consumer['place']),
                        isThreeLine: true,
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => AddTranscation(
                          //             consumerDocId: consumer.id,
                          //             consumerName: consumer['fullName'])));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewCompleteConsumerData(
                                  consumerDocId: consumer.id,
                                  consumerName: consumer['fullName'],
                                  phoneNumber: consumer['phoneNumber'],
                                  place: consumer['place'],
                                  date: consumer['date'],
                                  openingBalance: consumer['openingBalance'],
                                  totalPaidAmount:
                                      (consumer['TotalPaidAmount']),
                                  totalBalanceAmount:
                                      consumer['TotalBalanceAmount'],
                                ),
                              ));
                        },
                      ),
                    );
                  });
            }),
      ),
    );
  }
}