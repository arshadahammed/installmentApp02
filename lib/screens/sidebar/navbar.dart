import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/login/fincorplogin.dart';
import 'package:flutter_myinstalment_application/screens/login/login_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  // final String name;
  // final String email;
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName!),
              accountEmail: Text(user.email!),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1177/1177568.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ListTile(
            //   leading: Icon(Icons.person),
            //   title: Text('Users'),
            //   onTap: () => null,
            // ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () => null,
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications),
            //   title: Text('Request'),
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Terms Of Use'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Privacy Policy'),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate Us'),
              onTap: () => null,
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                final snackBar = SnackBar(
                  content: Text('Logout Successfully'),
                  duration: Duration(seconds: 2, milliseconds: 500),
                  backgroundColor: Colors.green,
                );
                logout(context);
                // Fluttertoast.showToast(msg: "Logout Successfully");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    // await FirebaseAuth.instance.signOut();
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LoginScreen()));
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    await SharedPreferences.getInstance();
    sharedPreferences.remove('Key');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FincorpLogin()));
  }
}
