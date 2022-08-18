import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/cashEntry/addtransaction.dart';

class ViewConsumer2 extends StatefulWidget {
  const ViewConsumer2({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewConsumer2> createState() => _ViewConsumer2State();
}

class _ViewConsumer2State extends State<ViewConsumer2> {
  final user = FirebaseAuth.instance.currentUser!;
  String name = "";
  int balance = 0;

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
                                  builder: (context) => AddTranscation(
                                        consumerDocId: consumer.id,
                                        consumerName: consumer['fullName'],
                                        openingBalance:
                                            consumer['openingBalance'],
                                        totalPaidAmount:
                                            (consumer['TotalPaidAmount']),
                                        totalBalanceAmount:
                                            consumer['TotalBalanceAmount'],
                                        totalAmountofProducts:
                                            consumer['TotalAmountofProducts'],
                                      )));
                        },
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
