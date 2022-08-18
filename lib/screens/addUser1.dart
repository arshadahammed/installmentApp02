import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime(2022, 04, 11);
  var name = "";
  var phone = "";
  var place = "";
  // var paidamount = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();

  // final paidamountController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    placeController.dispose();
    // paidamountController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    phoneController.clear();
    placeController.clear();
    // paidamountController.clear();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    labelText: 'Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Phone Number',
                    labelText: 'Phone Number: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Place',
                    labelText: 'Place: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: placeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Place';
                    }
                    return null;
                  },
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 10.0),
              //   child: TextFormField(
              //     autofocus: false,
              //     decoration: InputDecoration(
              //       hintText: 'Enter Paid Instalment Amount',
              //       labelText: 'Paid Amount: ',
              //       labelStyle: TextStyle(fontSize: 20.0),
              //       border: OutlineInputBorder(),
              //       errorStyle:
              //           TextStyle(color: Colors.redAccent, fontSize: 15),
              //     ),
              //     controller: paidamountController,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Enter Total instalment Amount';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        // if 'cancel' => null
                        if (newDate == null) return;
                        //if 'ok' => date time
                        setState(() => date = newDate);
                      },
                      icon: const Icon(Icons.date_range),
                      label: const Text('Select Date'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = nameController.text;
                            phone = phoneController.text;
                            place = placeController.text;
                            // paidamount = paidamountController.text;
                            // addUser();
                            clearText();
                          });
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => viewDetails()));
                      },
                      child: Text(
                        'Save Details',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {clearText()},
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
