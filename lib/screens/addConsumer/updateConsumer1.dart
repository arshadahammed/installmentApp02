import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';

import 'package:flutter_myinstalment_application/screens/productEntry/viewconsumer1.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

class UpdateConsumer1 extends StatefulWidget {
  final String consumerDocId;
  final String consumerName;
  final String phoneNumber;
  final String place;
  final String date;
  final int openingBalance;
  final String obUpdateDocId;
  // final int totalCostAmount;

  const UpdateConsumer1({
    Key? key,
    required this.consumerDocId,
    required this.consumerName,
    required this.phoneNumber,
    required this.place,
    required this.date,
    required this.openingBalance,
    required this.obUpdateDocId,

    // required this.productName,
    // required this.totalCostAmount,
  }) : super(key: key);

  @override
  State<UpdateConsumer1> createState() => _UpdateConsumer1State();
}

class _UpdateConsumer1State extends State<UpdateConsumer1> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // DateTime date = DateTime(2022, 04, 11);
  //gonna give total height nd width of device

  // string for displaying the error Message
  String? errorMessage;

  //editing Controollers

  final updatenameController = TextEditingController();
  final updatephoneController = TextEditingController();
  final updateplaceController = TextEditingController();
  final updatedateController = TextEditingController();
  final updateOpeningBalanceController = TextEditingController();
  final updatecostAmountController = TextEditingController();

  @override
  clearText() {
    updatenameController.clear();
    updatephoneController.clear();
    updateplaceController.clear();
    updatedateController.clear();
    updateOpeningBalanceController.clear();
    updatecostAmountController.clear();

    // paidamountController.clear();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Intro = const Text(
      "Update Consumer",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );
    // name Field
    final NameField = TextFormField(
      autofocus: false,
      controller: updatenameController,
      // initialValue: widget.consumerName,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          updatenameController.text = widget.consumerName;
        }

        return null;
      },
      onSaved: (value) {
        updatenameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_add),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name : ${widget.consumerName}",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // phone number field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: updatephoneController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{0,}$');
        if (value!.isEmpty) {
          updatephoneController.text = widget.phoneNumber;
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid number(Min. 10 Character)");
        }
        return null;
      },
      onSaved: (value) {
        updatenameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Phone : ${widget.phoneNumber}",
        // label: Text('Phone Number'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // PlaceField
    final placeField = TextFormField(
      autofocus: false,
      controller: updateplaceController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{0,}$');
        if (value!.isEmpty) {
          updateplaceController.text = widget.place;
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid place(Min. 2 Character)");
        }
        return null;
      },
      onSaved: (value) {
        updateplaceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.place),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Place : ${widget.place}",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // DateField
    final dateField = TextFormField(
      controller: updatedateController,
      validator: (value) {
        if (value!.isEmpty) {
          updatedateController.text = widget.date;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // icon: Icon(Icons.calendar_today),
        // labelText: "Enter Date",

        hintText: "Date : ${widget.date}",
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
            lastDate: DateTime(2101));
        //lastDate: DateTime.now());
        if (pickedDate != null) {
          print(pickedDate);
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(formattedDate);

          setState(() {
            updatedateController.text = formattedDate;
          });
        } else {
          print("Date is not Selected");
        }
      },
    );

    // Opening Balance Field
    final openingBalanceField = TextFormField(
      autofocus: false,
      controller: updateOpeningBalanceController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{0,}$');
        if (value!.isEmpty) {
          updateOpeningBalanceController.text =
              widget.openingBalance.toString();
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid Product(Min. 2 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        updateOpeningBalanceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.price_check_sharp),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Opening Balance : ${widget.openingBalance.toString()}",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Cost Amount Field
    final costAmountField = TextFormField(
      // onChanged: (value) {},
      autofocus: false,
      controller: updatecostAmountController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Amount cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Amount");
        }
        return null;
      },
      onSaved: (value) {
        updatecostAmountController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.currency_exchange),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        // hintText: widget.totalCostAmount.toString(),
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
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            updateConsumer();
            updateOpeningBalanceInLedger();
          },
          child: const Text(
            "Update Details",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    final clearDetails = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            clearText();
          },
          child: const Text(
            "Clear Details",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Consumer'),
      ),
      body: Stack(
        children: [
          Container(
            //here the height of the container is  45% of  our total height
            height: size.height * .45,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
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
                            openingBalanceField,
                            // const SizedBox(height: 20),
                            // costAmountField,

                            const SizedBox(height: 20),
                            saveDetails,
                            const SizedBox(height: 240),
                            // clearDetails,
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

  CollectionReference consumers =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateConsumer() async {
    if (_formKey.currentState!.validate()) {
      var collection = FirebaseFirestore.instance.collection('users');
      var querySnapshot =
          await collection.where('description', isEqualTo: 'OB').get();
      final snackBar = const SnackBar(
        content: const Text('Consumer Updated Successfully'),
        duration: const Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      return users
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .update({
            // "uid": user.uid,
            "fullName": updatenameController.text,
            "phoneNumber": updatephoneController.text,
            "place": updateplaceController.text,
            "date": updatedateController.text,
            "openingBalance": int.parse(updateOpeningBalanceController.text),
            // "totalCost": int.parse(updatecostAmountController.text),
            // "TotalPaidAmount": int.parse('0'),
          })
          .whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
          .whenComplete(() => Navigator.of(context).pop())
          // Navigator.popUntil(
          //     context, (route) => route.settings.name == "/viewConsumerList")

          // .whenComplete(() => Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => ViewConsumer11(),
          //       ),
          //     ))
          .then((value) => print("Sucessfully Updated Consumer"))
          .catchError((error) => print("Failed to Update Consumer: $error"));
    }
  }

  //update opening balance in ledger
  CollectionReference ledger = FirebaseFirestore.instance.collection('users');
  Future<void> updateOpeningBalanceInLedger() async {
    if (_formKey.currentState!.validate()) {
      final snackBar = const SnackBar(
        content: const Text('Consumer Updated Successfully'),
        duration: const Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      return ledger
          .doc(user.uid)
          .collection("consumers")
          .doc(widget.consumerDocId)
          .collection("ledger")
          .doc(widget.obUpdateDocId)
          .update({
            "Amount": int.parse(updateOpeningBalanceController.text),
            // "totalCost": int.parse(updatecostAmountController.text),
            // "TotalPaidAmount": int.parse('0'),
          })
          .whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
          // .whenComplete(() => Navigator.of(context).pop())
          // .whenComplete(() => Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => ViewConsumer11(),
          //       ),
          //     ))
          .then((value) => print("Sucessfully Updated ledger Opening Balance"))
          .catchError((error) => print("Failed to Update Consumer: $error"));
    }
  }
}
