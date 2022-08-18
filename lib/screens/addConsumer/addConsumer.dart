import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/addConsumer/viewConsumer0.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/login/fincorplogin.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

class AddConsumer extends StatefulWidget {
  const AddConsumer({
    Key? key,
  }) : super(key: key);

  @override
  State<AddConsumer> createState() => _AddConsumerState();
}

class _AddConsumerState extends State<AddConsumer> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // DateTime date = DateTime(2022, 04, 11);
  //gonna give total height nd width of device

  // string for displaying the error Message
  String? errorMessage;

  //editing Controollers

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  final dateController = TextEditingController();
  final productController = TextEditingController();
  final initialcostAmountController = TextEditingController();

  @override
  clearText() {
    nameController.clear();
    phoneController.clear();
    placeController.clear();
    dateController.clear();
    productController.clear();
    initialcostAmountController.clear();

    // paidamountController.clear();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Intro = Text(
      "Add Consumer",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );
    // name Field
    final NameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 4 Character)");
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // phone number field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Phone Number cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid number(Min. 10 Character)");
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // PlaceField
    final placeField = TextFormField(
      autofocus: false,
      controller: placeController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Place cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid place(Min. 4 Character)");
        }
        return null;
      },
      onSaved: (value) {
        placeController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.place),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Place",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // // DateField
    // final dateField = TextFormField(
    //   autofocus: false,
    //   controller: dateController,
    //   keyboardType: TextInputType.datetime,
    //   validator: (value) {
    //     RegExp regex = RegExp(r'^.{3,}$');
    //     if (value!.isEmpty) {
    //       return ("Date cannot be Empty");
    //     }
    //     if (!regex.hasMatch(value)) {
    //       return ("Enter Valid Date");
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     dateController.text = value!;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(Icons.date_range),
    //     contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //     hintText: "Date",
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // );

    // DateField
    final dateField = TextFormField(
      controller: dateController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Date cannot be Empty");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // icon: Icon(Icons.calendar_today),
        // labelText: "Enter Date",
        hintText: 'Date',
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

    // // Product Field
    // final productField = TextFormField(
    //   autofocus: false,
    //   controller: productController,
    //   keyboardType: TextInputType.name,
    //   validator: (value) {
    //     RegExp regex = RegExp(r'^.{2,}$');
    //     if (value!.isEmpty) {
    //       return ("Product Name cannot be Empty");
    //     }
    //     if (!regex.hasMatch(value)) {
    //       return ("Enter Valid Product(Min. 2 Character)");
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     productController.text = value!;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(Icons.account_circle),
    //     contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //     hintText: "Product Name",
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // );

    //  Opening Balance
    final initialcostAmountField = TextFormField(
      // onChanged: (value) {},
      autofocus: false,
      controller: initialcostAmountController,
      keyboardType: TextInputType.number,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{0,}$');
        if (value!.isEmpty) {
          initialcostAmountController.text = '0';
        }
        return null;
      },
      onSaved: (value) {
        initialcostAmountController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Opening Balance",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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
            addConsumer();
          },
          child: Text(
            "Save Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    final updateConsumer = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 161, 178, 187),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewConsumer0()));
          },
          child: Text(
            "Update Consumer",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Consumer'),
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
          Container(
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
                          const SizedBox(height: 45),
                          NameField,
                          const SizedBox(height: 20),
                          phoneNumberField,
                          const SizedBox(height: 20),
                          placeField,
                          const SizedBox(height: 20),
                          dateField,
                          const SizedBox(height: 20),
                          initialcostAmountField,
                          const SizedBox(height: 20),
                          saveDetails,
                          const SizedBox(height: 20),
                          updateConsumer,
                          const SizedBox(height: 90),
                        ],
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

  CollectionReference consumers =
      FirebaseFirestore.instance.collection('users');

  Future<void> addConsumer() async {
    if (_formKey.currentState!.validate()) {
      final snackBar = SnackBar(
        content: Text('Consumer Added successfully'),
        duration: Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      return users
          .doc(user.uid)
          .collection("consumers")
          .add({
            "uid": user.uid,
            "fullName": nameController.text,
            "phoneNumber": phoneController.text,
            "place": placeController.text,
            "date": dateController.text,
            "ObUpdateDocId": '',
            "openingBalance": int.parse(initialcostAmountController.text),
            "TotalPaidAmount": int.parse('0'),
            "TotalBalanceAmount": int.parse('0'),
            "TotalAmountofProducts": int.parse('0'),
          })
          .then((value) {
            print("Sucessfully Added Consumer ${value.id}");
            addledger(value.id.toString());
          })
          .whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
          .whenComplete(() => Navigator.of(context).pop())
          .catchError((error) => print("Failed to add Consumer: $error"));
    }
  }

  CollectionReference transactions =
      FirebaseFirestore.instance.collection('users');

  Future<void> addledger(String? consumerId) async {
    // if (_formKey.currentState!.validate()) {
    // final snackBar = SnackBar(
    //   content: Text('ledger Added successfully'),
    //   duration: Duration(seconds: 2, milliseconds: 500),
    //   backgroundColor: Colors.green,
    // );
    // Call the user's CollectionReference to add a new user
    return transactions
        .doc(user.uid)
        .collection("consumers")
        .doc(consumerId)
        .collection("ledger")
        .add({
      "uid": user.uid,
      "date": dateController.text,
      "description": 'OB',
      "type": 'Product',
      "Amount": int.parse(initialcostAmountController.text),

      // "totalCostAmount": widget.totalCostAmount,
    })
        // .whenComplete(
        //     () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
        .then((value) {
      print("ledger Added ${value.id}");
      ledgerObUpdate(consumerId.toString(), value.id.toString());
    }).catchError((error) => print("Failed to add ledger: $error"));
    // }
  }

  //to get ob
  Future<void> ledgerObUpdate(String? consumerId, String? ledgerDocId) async {
    return consumers
        .doc(user.uid)
        .collection("consumers")
        .doc(consumerId)
        .update({'ObUpdateDocId': ledgerDocId})
        .then((value) => print("ledgerDoc id Updated"))
        .catchError((error) => print("Failed to update ledgerId: $error"));
  }
}
