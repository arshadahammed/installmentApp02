import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myinstalment_application/screens/login/fincorplogin.dart';
import 'package:flutter_myinstalment_application/screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,
      appBarTheme: AppBarTheme(
          color: Colors.blue,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: 17, letterSpacing: 1.5, color: Colors.white),
        ),),
      // home: const ScreenSplash(),
      home: const ScreenSplash(),
    );
  }
}



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Instalment App"),
//       ),
//       body: const Center(
//         child: Text("Calculate Your Pending Instalment Amount"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AddUser(),
//               ));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
