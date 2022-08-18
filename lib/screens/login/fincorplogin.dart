import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FincorpLogin extends StatefulWidget {
  const FincorpLogin({Key? key}) : super(key: key);

  @override
  State<FincorpLogin> createState() => _FincorpLoginState();
}

class _FincorpLoginState extends State<FincorpLogin> {
  final _formKey = GlobalKey<FormState>();
  final clientNameController = TextEditingController();
  final keyController = TextEditingController();
  bool isLooding = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _intro = Text(
      "Validate Your Key",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );

    // client name Field
    final NameField = TextFormField(
      autofocus: false,
      controller: clientNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Client Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid client name(Min. 2 Character)");
        }
        return null;
      },
      onSaved: (value) {
        clientNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Client Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //key field

    final KeyField = TextFormField(
      autofocus: false,
      controller: keyController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Key cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Client Key(Min. 2 Character)");
        }
        return null;
      },
      onSaved: (value) {
        keyController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key_rounded),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Key",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //buttons
    //buttons

    final checkDetails = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        height: 30,
        onPressed: () {
          // if (_formKey.currentState!.validate()) {
          //   FirebaseFirestore.instance.collection("consumers").add({
          //     "fullName": nameController.text,
          //     "phoneNumber": phoneController.text,
          //     "place": placeController.text,
          //     "date": dateController.text,
          //   });
          // }
          // addConsumer();
          // clearText();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ScreenSplash()));
          // validateKey();
          validate2();
        },
        child: isLooding
            ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Center(
                child: const LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Colors.white],
                  ),
              ),
            )
            :const Text(
                "Validate",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Verify Client'),
      // ),
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
                          SizedBox(
                            height: 200,
                            child: Image.asset(
                              "assets/images/image4.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 45),
                          _intro,
                          const SizedBox(height: 45),
                          NameField,
                          const SizedBox(height: 20),
                          KeyField,
                          const SizedBox(height: 20),
                          checkDetails,
                          const SizedBox(height: 20),
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

  //validate client name and key
  CollectionReference fincorp =
      FirebaseFirestore.instance.collection('fincorp');

  Future<void> validateKey() async {
    // if (_formKey.currentState!.validate()) {
    final snackBar = const SnackBar(
      content: const Text('Key Validated Successfully'),
      duration: const Duration(seconds: 2, milliseconds: 500),
      backgroundColor: Colors.green,
    );
    FirebaseFirestore.instance
        .collection('fincorp')
        .doc(clientNameController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      }
      if (documentSnapshot.exists) {
        print('${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<void> validate2() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLooding = true;
      });
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('Key', keyController.text);
      final snackBar1 = const SnackBar(
        content: Text('Wrong Key or wrong client Name'),
        duration: Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      final snackBar2 = const SnackBar(
        content: const Text('Validation Success'),
        duration: const Duration(seconds: 2, milliseconds: 500),
        backgroundColor: Colors.green,
      );
      var collection = FirebaseFirestore.instance.collection('fincorp');
      var docSnapshot = await collection.doc(clientNameController.text.trim()).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        // You can then retrieve the value from the Map like this:
        var name = data['clientName'];
        var key = data['clientKey'];
        print(name);
        print(key);
        if (key != keyController.text.trim()) {
          print("Wrong Key or wrong client Name");
          ScaffoldMessenger.of(context).showSnackBar(snackBar1);
        } else {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
          print("right Key and name ");
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }
      }
      setState(() {
        isLooding = false;
      });
    }
  }
}
