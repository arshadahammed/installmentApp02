import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/login/Methods.dart';
import 'package:flutter_myinstalment_application/screens/login/create_account.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    height: size.height / 10,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   width: size.width / 0.5,
                  //   child: IconButton(
                  //       icon: Icon(Icons.arrow_back_ios), onPressed: () {
                  //         Navigator.pop(context);
                  //       }),
                  // ),
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
                      "Sign In to Contiue!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "email", Icons.account_box, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "password", Icons.lock, _password),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CreateAccount())),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            final snackBar1 = SnackBar(
              content: Text('Login Successfull'),
              duration: Duration(seconds: 2, milliseconds: 500),
              backgroundColor: Colors.green,
            );
            if (user != null) {
              // Fluttertoast.showToast(msg: "Login Successfull");
              ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              print("Login Successfull");

              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              final snackBar2 = SnackBar(
                content: Text('Login Failed, Invalid UserName Or Password'),
                duration: Duration(seconds: 2, milliseconds: 500),
                backgroundColor: Colors.green,
              );
              // Fluttertoast.showToast(msg: "Login Failed");
              print("Login Failed");
              ScaffoldMessenger.of(context).showSnackBar(snackBar2);

              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          final snackBar3 = SnackBar(
            content: Text('Please fill form correctly'),
            duration: Duration(seconds: 2, milliseconds: 500),
            backgroundColor: Colors.green,
          );
          // Fluttertoast.showToast(msg: "Please fill form correctly");
          print("Please fill form correctly");
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
            "Login",
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
