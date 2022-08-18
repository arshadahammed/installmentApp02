import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/login/fincorplogin.dart';

import 'package:flutter_myinstalment_application/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalEmail;
String? finalKey;

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      _navigatetohome();
    });
    super.initState();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    if (finalEmail == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => finalEmail == null
                  ? const LoginScreen()
                  : const HomeScreen()));
    }
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    // var obtainedKey = sharedPreferences.getString('Key');
    setState(() {
      finalEmail = obtainedEmail;
      // finalKey = obtainedKey;
    });
    if (kDebugMode) {
      print(finalEmail);
      print(finalKey);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/image4.png',
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
