import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/login/Methods.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({
    Key? key,
  }) : super(key: key);
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 0.5,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios), onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Create Account to Contiue!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Name", Icons.account_box, _name),
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Email", Icons.email, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "password", Icons.lock, _password),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 18.0),
                  //   child: Container(
                  //     width: size.width,
                  //     alignment: Alignment.center,
                  //     child: field(
                  //         size, "Client Key", Icons.key_rounded, _clientKey),
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  customButton(size),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(
            _name.text,
            _email.text.trim(),
            _password.text,
          ).then((user) {
            final snackBar = SnackBar(
              content: Text('Account Created Sucessfully'),
              duration: Duration(seconds: 2, milliseconds: 500),
              backgroundColor: Colors.green,
            );
            final snackBar2 = SnackBar(
              content: Text('Login Failed!'),
              duration: Duration(seconds: 2, milliseconds: 500),
              backgroundColor: Colors.green,
            );

            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              print("Account Created Sucessfully");
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              //Fluttertoast.showToast(msg: "Account Created Sucessfully");
            } else {
              print("Login Failed");
              // ScaffoldMessenger.of(context).showSnackBar(snackBar2);
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          final snackBar3 = SnackBar(
            content: Text('Please enter Fields'),
            duration: Duration(seconds: 2, milliseconds: 500),
            backgroundColor: Colors.green,
          );
          print("Please enter Fields");
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
