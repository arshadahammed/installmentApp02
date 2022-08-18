import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/addConsumer/addConsumer.dart';
import 'package:flutter_myinstalment_application/screens/addUser1.dart';
import 'package:flutter_myinstalment_application/screens/balanceDetails.dart';

import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/view_tranasactions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddTranscation extends StatefulWidget {
  final String consumerDocId;
  final String consumerName;
  final int openingBalance;
  final int totalPaidAmount;
  final int totalAmountofProducts;
  final int totalBalanceAmount;

  const AddTranscation({
    Key? key,
    required this.consumerDocId,
    required this.consumerName,
    required this.totalPaidAmount,
    required this.totalBalanceAmount,
    required this.openingBalance,
    required this.totalAmountofProducts,
  }) : super(key: key);

  @override
  State<AddTranscation> createState() => _AddTranscationState();
}

class _AddTranscationState extends State<AddTranscation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('consumers').snapshots();
  Stream collectionStream =
      FirebaseFirestore.instance.collection('consumers').snapshots();

  // Stream documentStream =
  //     FirebaseFirestore.instance.collection('consumers').doc('ABC123').snapshots();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  // final consumer =
  //     FirebaseFirestore.instance.collection('consumers').snapshots();

  // DateTime date = DateTime(2022, 04, 11);
  //gonna give total height nd width of device

  // string for displaying the error Message
  String? errorMessage;

  //editing Controollers

  // final consumerController = TextEditingController();
  final instalmentController = TextEditingController();
  final dateController = TextEditingController();

  @override
  clearText() {
    // consumerController.clear();
    instalmentController.clear();
    dateController.clear();

    // paidamountController.clear();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Intro = Text(
      "Enter Transactions",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );

    final consumerDetails = Text(
      "Welcome ${widget.consumerName}",
      style: TextStyle(
        fontSize: 18,
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
    );

    // Selctbox
    // final dropdown = DropdownButtonFormField(
    //     hint: Text('Select Consumer'),
    //     onChanged: (value) {
    //       print(value);
    //     },
    //     items: _list.map((e) {
    //       return DropdownMenuItem(value: e, child: Text(e));
    //     }).toList());

    // // name Field
    // final productNameField = TextFormField(
    //   autofocus: false,
    //   controller: productController,
    //   keyboardType: TextInputType.name,
    //   validator: (value) {
    //     RegExp regex = RegExp(r'^.{3,}$');
    //     if (value!.isEmpty) {
    //       return ("Product Name cannot be Empty");
    //     }
    //     if (!regex.hasMatch(value)) {
    //       return ("Enter Valid name(Min. 4 Character)");
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     productController.text = value!;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(Icons.house),
    //     contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //     hintText: "Product Name",
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // );

    //total cost price
    final instalmentField = TextFormField(
      autofocus: false,
      controller: instalmentController,
      keyboardType: TextInputType.number,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{2,}$');
        // if (value!.isEmpty) {
        //   return ("Instalment Field cannot be Empty");
        // }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 4 Character)");
        // }
        // return null;
        if (value!.isEmpty) {
          return ("Instalment Field cannot be Empty");
        }

        if (int.parse(value) >
            widget.totalAmountofProducts + widget.openingBalance) {
          return ("amount Should be less than total cost of products");
        }
        final value1 = widget.openingBalance + widget.totalAmountofProducts;
        final value2 = value1 - widget.totalPaidAmount;

        if (value2 - int.parse(value) < 0) {
          return ("transfer amount exceeds balance");
        }

        // if (widget.totalAmountofProducts == 0) {
        //   return ("You should Add a Product first");
        // }
        final amount = widget.totalAmountofProducts + widget.openingBalance;
        if (amount - widget.totalPaidAmount == 0) {
          return ("You have completely Paid Your Instalment");
        }

        return null;
      },
      onSaved: (value) {
        instalmentController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.price_change_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "instalment Amount",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //date
    var now = DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    final dateField = TextFormField(
      controller: dateController,
      validator: (value) {
        if (value!.isEmpty) {
          dateController.text = formattedDate;
        }
        return null;
      },
      onSaved: (value) {
        dateController.text = value!;
      },
      // textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // icon: Icon(Icons.calendar_today),
        hintText: formattedDate,

        // hintText: 'Enter Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        prefixIcon: Icon(Icons.calendar_today),
      ),

      readOnly: true,
    );

    //buttons

    final saveDetails = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // addTransactionDetails();
            addledger();
            updateTotalCostAmount();
            updateBalanceAmount();

            // Fluttertoast.showToast(msg: "Data Added Successful");
            // updateTotalCostAmount();
          },
          child: Text(
            "Save Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //view Tranasactions
    final ViewTranscationsDetails = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewTransactions(
                          consumerDocId: widget.consumerDocId,
                          totalCostAmount: widget.openingBalance,
                        )));
          },
          child: Text(
            "View Transactions Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final checkBalance = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            ledgerBalance();
            // Fluttertoast.showToast(msg: "Data Added Successful");
            // updateTotalCostAmount();
          },
          child: Text(
            "Check Balance",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //button End
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transactions'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            //here the height of the container is  45% of  our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 85),
            child: Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(
                            //   height: 200,
                            //   child: Image.asset(
                            //     "assets/images/image1.png",
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            const SizedBox(height: 45),
                            Intro,
                            const SizedBox(height: 20),
                            consumerDetails,
                            // const SizedBox(height: 45),
                            // dropdown,
                            const SizedBox(height: 20),

                            const SizedBox(height: 20),
                            instalmentField,
                            const SizedBox(height: 20),
                            dateField,
                            const SizedBox(height: 20),

                            const SizedBox(height: 20),
                            saveDetails,
                            const SizedBox(height: 320),
                            // ViewTranscationsDetails,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DocumentReference test1 =
  //     FirebaseFirestore.instance.collection("users").doc(user.uid);
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('users');

  Future<void> addTransactionDetails() async {
    if (_formKey.currentState!.validate()) {
      //opening balance+totalpai amount assaign to a variable
      final amount = widget.totalAmountofProducts + widget.openingBalance;
      // dynamic balanceAmount = await balanceAmount() ;
      final snackBar = SnackBar(
        content: Text('Transaction Added successfully'),
        duration: Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      // Call the user's CollectionReference to add a new user
      return transactions
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .collection("transaction")
          .add({
            "uid": user.uid,
            "instalment": int.parse(instalmentController.text),
            "date": dateController.text,
            "totalPaidAmount":
                widget.totalPaidAmount + int.parse(instalmentController.text),
            "totalAmountofProducts": widget.totalAmountofProducts,
            // "balanceAmount": widget.totalBalanceAmount -
            //     int.parse(instalmentController.text),
            "balanceAmount": amount -
                (widget.totalPaidAmount + int.parse(instalmentController.text)),
          })
          .whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
          .then((value) => print("Transaction Added"))
          .catchError((error) => print("Failed to add Transaction: $error"));
    }
  }

  //upate total cost amount

  CollectionReference consumers =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateTotalCostAmount() async {
    if (_formKey.currentState!.validate()) {
      dynamic totalAmount = await sumInstalments();
      // Call the user's CollectionReference to add a new user
      return consumers
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .update({'TotalPaidAmount': totalAmount})
          .then((value) => print("Total Cost Amount Updated"))
          .catchError((error) => print("Failed to update Amount: $error"));
    }
  }

//to sum all instalments
  Future sumInstalments() async {
    return transactions
        .doc(user.uid)
        .collection("consumers")
        .doc(widget.consumerDocId)
        .collection("ledger")
        .where('type', isEqualTo: 'Payment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      int sum = 0;
      querySnapshot.docs.forEach((ledger) {
        int value = ledger["Amount"];
        sum = sum + value;
      });
      return (sum);
    });
  }

  // Future<void> showtotalSum() async {
  //   dynamic totalAmount = await sumInstalments();
  //   print(totalAmount);
  // }

  //to calculate and update Balance
  //balance AMount Calculator
  Future balanceAmount() async {
    //openingbalance + total amount of products
    final totalAmountofproducts =
        widget.totalAmountofProducts + widget.openingBalance;

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
        balance = totalAmountofproducts - sum;
      });
      if (balance <= 0) {
        return (0);
      } else {
        return (balance);
      }
      // return Text(balance.toString());
      // return (balance.toString());
    });
  }

  //update Balance
  Future<void> updateBalanceAmount() async {
    if (_formKey.currentState!.validate()) {
      dynamic totalBalanceAmount = await ledgerBalance();
      // Call the user's CollectionReference to add a new user
      return consumers
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .update({'TotalBalanceAmount': totalBalanceAmount})
          .then((value) => print("Total Balance Amount Updated"))
          .catchError(
              (error) => print("Failed to update Balance Amount: $error"));
    }
  }

  Future<void> addledger() async {
    if (_formKey.currentState!.validate()) {
      final snackBar = SnackBar(
        content: Text('ledger Added successfully'),
        duration: Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      // Call the user's CollectionReference to add a new user
      return transactions
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .collection("ledger")
          .add({
            "uid": user.uid,
            "date": dateController.text,
            "description": 'cash',
            "type": 'Payment',
            "Amount": int.parse(instalmentController.text),

            // "totalCostAmount": widget.totalCostAmount,
          })
          .whenComplete(() => Navigator.of(context).pop())
          .then((value) => print("ledger Added"))
          .catchError((error) => print("Failed to add ledger: $error"));
    }
  }

  Future ledgerBalance() async {
    //openingbalance + total amount of products

    return consumers
        .doc(user.uid)
        .collection("consumers")
        .doc(widget.consumerDocId)
        .collection("ledger")
        .where('type', isEqualTo: 'Product')
        .get()
        .then((QuerySnapshot querySnapshot) {
      int sum1 = 0;
      int balance = 0;
      querySnapshot.docs.forEach((ledger) {
        int value1 = ledger["Amount"];
        // int value2 = ledger["amount"].where('type' == 'cash');
        sum1 = sum1 + value1;
        calculation(sum1);
      });

      return calculation(sum1);
    });
  }

  Future calculation(int sum1) async {
    return consumers
        .doc(user.uid)
        .collection("consumers")
        .doc(widget.consumerDocId)
        .collection("ledger")
        .where('type', isEqualTo: 'Payment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      int sum2 = 0;
      int balance = 0;
      querySnapshot.docs.forEach((ledger) {
        int value2 = ledger["Amount"];
        sum2 = sum2 + value2;
        balance = sum1 - sum2;
        // int value2 = ledger["amount"].where('type' == 'cash');
      });
      // print(balance);
      return (balance);
    });
  }
}
