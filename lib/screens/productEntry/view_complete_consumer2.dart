import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/productEntry/add_products.dart';

class ViewCompleteConsumerData extends StatefulWidget {
  final String consumerDocId;
  final String consumerName;
  final String phoneNumber;
  final String place;
  final String date;
  final int openingBalance;
  final int totalPaidAmount;
  final int totalBalanceAmount;
  const ViewCompleteConsumerData({
    Key? key,
    required this.consumerDocId,
    required this.consumerName,
    required this.phoneNumber,
    required this.place,
    required this.date,
    // required this.productName,
    required this.openingBalance,
    required this.totalPaidAmount,
    required this.totalBalanceAmount,
  }) : super(key: key);

  @override
  State<ViewCompleteConsumerData> createState() =>
      _ViewCompleteConsumerDataState();
}

class _ViewCompleteConsumerDataState extends State<ViewCompleteConsumerData> {
  bool isObscurePassword = true;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumer Details"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/1177/1177568.png"),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", widget.consumerName, false),
              // buildTextField("Consumer id", widget.consumerDocId, false),
              buildTextField("Phone Number", widget.phoneNumber, false),
              buildTextField("Place", widget.place, false),
              // buildTextField("Date", widget.date, false),
              buildTextField(
                  "Opening Balance", widget.openingBalance.toString(), false),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProducts(
                                    consumerDocId: widget.consumerDocId,
                                    consumerName: widget.consumerName,
                                    totalCostAmount: widget.openingBalance,
                                    totalPaidAmount: widget.totalPaidAmount,
                                    totalBalanceAmount:
                                        widget.totalBalanceAmount,
                                  )));
                    },
                    child: Text(
                      "    Add Products    ",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        fixedSize: Size(300, 50),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPassWordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPassWordTextField ? isObscurePassword : false,
        readOnly: true,
        decoration: InputDecoration(
            suffixIcon: isPassWordTextField
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
