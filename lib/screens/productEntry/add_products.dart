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

class AddProducts extends StatefulWidget {
  final String consumerDocId;
  final String consumerName;
  final int totalCostAmount;
  final int totalPaidAmount;
  final int totalBalanceAmount;

  const AddProducts({
    Key? key,
    required this.consumerDocId,
    required this.consumerName,
    required this.totalCostAmount,
    required this.totalPaidAmount,
    required this.totalBalanceAmount,
  }) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('consumers').snapshots();
  Stream collectionStream =
      FirebaseFirestore.instance.collection('consumers').snapshots();

  // Stream documentStream =
  //     FirebaseFirestore.instance.collection('consumers').doc('ABC123').snapshots();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  // final consumer =
  //     FirebaseFirestore.instance.collection('consumers').snapshots();

  // DateTime date = DateTime(2022, 04, 11);
  //gonna give total height nd width of device

  // string for displaying the error Message
  String? errorMessage;

  //editing Controollers

  // final consumerController = TextEditingController();
  final productNameController = TextEditingController();
  final productCostController = TextEditingController();
  final dateController = TextEditingController();

  @override
  clearText() {
    // consumerController.clear();
    productCostController.clear();
    dateController.clear();
    productNameController.clear();

    // paidamountController.clear();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Intro = Text(
      "Add Products",
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

    //Product Name field

    final productNameField = TextFormField(
      autofocus: false,
      controller: productNameController,
      keyboardType: TextInputType.name,
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
          return ("Product Name Field cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        productNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.computer),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Product Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //total cost price
    final instalmentField = TextFormField(
      autofocus: false,
      controller: productCostController,
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
          return ("Product Cost Field cannot be Empty");
        }

        // if (int.parse(value) >= widget.totalCostAmount) {
        //   return ("Instalment amount Should be less than total cost");
        // }
        return null;
      },
      onSaved: (value) {
        productCostController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.price_change_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Product Cost Amount",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final dateField = TextFormField(
      controller: dateController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Date cannot be Empty");
        }
        return null;
      },
      // textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // icon: Icon(Icons.calendar_today),

        hintText: 'Enter Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        prefixIcon: Icon(Icons.calendar_today),
      ),

      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now());
        // lastDate: DateTime(2101));
        if (pickedDate != null) {
          print(pickedDate);
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(formattedDate);

          setState(() {
            dateController.text = formattedDate;
          });
        } else {
          print("Date is not Selected");
        }
      },
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
            // addProductItem(); for test
            addledger();
            //prouct+openigbalance
            updateTotalProductCostAmount();
            // updateBalanceAmount();

            updateTotalBalanceAmount();
            // updateAllProducts();

            // Fluttertoast.showToast(msg: "Data Added Successful");
            // updateTotalCostAmount();
            // clearText();
          },
          child: Text(
            "Save Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //view Tranasactions
    final viewTranscationsDetails = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            ledgerBalance();
          },
          child: Text(
            "View Transactions Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //view blance
    final ViewBalance = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BalanceScreen(
                          totalCostAmount: widget.totalCostAmount,
                          consumerDocId: widget.consumerDocId,
                          consumerName: widget.consumerName,
                          totalPaidAmount: widget.totalPaidAmount,
                          toalBalanceAmount: widget.totalBalanceAmount,
                        )));
          },
          child: Text(
            "View Balance Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //button End
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
      ),
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
            padding: const EdgeInsets.only(top: 80),
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
                            productNameField,
                            const SizedBox(height: 20),
                            instalmentField,
                            const SizedBox(height: 20),
                            dateField,
                            const SizedBox(height: 20),

                            const SizedBox(height: 20),
                            saveDetails,
                            const SizedBox(height: 250),
                            // viewTranscationsDetails,
                            // const SizedBox(height: 20),
                            // ViewBalance,

                            // const SizedBox(height: 20),
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

  // Future<void> addProductItem() async {
  //   if (_formKey.currentState!.validate()) {
  //     final snackBar = SnackBar(
  //       content: Text('Product Added successfully'),
  //       duration: Duration(seconds: 2, milliseconds: 500),
  //       backgroundColor: Colors.green,
  //     );
  //     // Call the user's CollectionReference to add a new user
  //     return transactions
  //         .doc(user.uid)
  //         .collection("consumers")
  //         .doc(widget.consumerDocId)
  //         .collection("products")
  //         .add({
  //           "uid": user.uid,
  //           "productName": productNameController.text,
  //           "productCost": int.parse(productCostController.text),
  //           "date": dateController.text,

  //           // "totalCostAmount": widget.totalCostAmount,
  //         })
  //         .whenComplete(
  //             () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
  //         .then((value) => print("Transaction Added"))
  //         .catchError((error) => print("Failed to add Transaction: $error"));
  //   }
  // }

  //upate total cost amount

  // CollectionReference consumers =
  //     FirebaseFirestore.instance.collection('users');

  // Future<void> updateTotalCostAmount() async {
  //   if (_formKey.currentState!.validate()) {
  //     dynamic totalAmount = await sumInstalments();
  //     // Call the user's CollectionReference to add a new user
  //     return consumers
  //         .doc(user.uid)
  //         .collection("consumers")
  //         .doc(widget.consumerDocId)
  //         .update({'TotalPaidAmount': totalAmount})
  //         .then((value) => print("Total Cost Amount Updated"))
  //         .catchError((error) => print("Failed to update Amount: $error"));
  //   }
  // }

// //to sum all instalments
//   Future sumInstalments() async {
//     return transactions
//         .doc(user.uid)
//         .collection("consumers")
//         .doc(widget.consumerDocId)
//         .collection("transaction")
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       int sum = 0;
//       querySnapshot.docs.forEach((transactions) {
//         int value = transactions["instalment"];
//         sum = sum + value;
//       });
//       return (sum);
//     });
//   }

  // Future<void> showtotalSum() async {
  //   dynamic totalAmount = await sumInstalments();
  //   print(totalAmount);
  // }

  //to calculate and update Balance
  //balance AMount Calculator
  // Future balanceAmount() async {
  //   final totalCostAmount = widget.totalCostAmount;

  //   return consumers
  //       .doc(user.uid)
  //       .collection("consumers")
  //       .doc(widget.consumerDocId)
  //       .collection("transaction")
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     int sum = 0;
  //     int balance = 0;
  //     querySnapshot.docs.forEach((transactions) {
  //       int value = transactions["instalment"];
  //       sum = sum + value;
  //       balance = totalCostAmount - sum;
  //     });
  //     if (balance <= 0) {
  //       return (0);
  //     } else {
  //       return (balance);
  //     }
  //     // return Text(balance.toString());
  //     // return (balance.toString());
  //   });
  // }

  // //update Balance
  // Future<void> updateBalanceAmount() async {
  //   if (_formKey.currentState!.validate()) {
  //     dynamic totalBalanceAmount = await balanceAmount();
  //     // Call the user's CollectionReference to add a new user
  //     return consumers
  //         .doc(user.uid)
  //         .collection("consumers")
  //         .doc(widget.consumerDocId)
  //         .update({'TotalBalanceAmount': totalBalanceAmount})
  //         .then((value) => print("Total Balance Amount Updated"))
  //         .catchError(
  //             (error) => print("Failed to update Balance Amount: $error"));
  //   }
  // }

  // sum of products(including opening Balance)
  Future sumProducts() async {
    return transactions
        .doc(user.uid)
        .collection("consumers")
        .doc(widget.consumerDocId)
        .collection("ledger")
        .where('subtype', isEqualTo: 'Product')
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

  CollectionReference consumers =
      FirebaseFirestore.instance.collection('users');

  //update total product cost in db
  Future<void> updateTotalProductCostAmount() async {
    if (_formKey.currentState!.validate()) {
      dynamic totalAmount = await sumProducts();
      // Call the user's CollectionReference to add a new user
      return consumers
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .update({'TotalAmountofProducts': totalAmount})
          .then((value) => print("Total Cost Amount Updated"))
          .catchError((error) => print("Failed to update Amount: $error"));
    }
  }

  //update balance Amount
  //update total product cost in db
  Future<void> updateTotalBalanceAmount() async {
    if (_formKey.currentState!.validate()) {
      dynamic totalBalance = await ledgerBalance();
      // Call the user's CollectionReference to add a new user
      return consumers
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .update({'TotalBalanceAmount': totalBalance})
          .then((value) => print("Total Cost Amount Updated"))
          .catchError((error) => print("Failed to update Amount: $error"));
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
            "description": productNameController.text,
            "type": 'Product',
            "subtype": 'Product',
            "Amount": int.parse(productCostController.text),

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
        // print(sum1);
      });
      // print(sum1);
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
