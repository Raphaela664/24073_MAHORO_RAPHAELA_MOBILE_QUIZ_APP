// import 'package:assignment_3/pages/authentication/auth_page.dart';
// import 'package:assignment_3/provider/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:get/get.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform
//   );
  
//  return  runApp(ChangeNotifierProvider(
//   child: MyApp(),
//   create: (BuildContext context)=>ThemeProvider(isDarkMode: true),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child){
//        return MaterialApp(
//         theme: themeProvider.getTheme,
//         debugShowCheckedModeBanner: false,
      
//         home: AuthPage(), // Set Homepage as the home screen
//       );
//       },
//     );
//   }
// }

import 'package:assignment_3/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'pages/authentication/auth_page.dart';
import 'provider/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize DatabaseHelper
  await DatabaseHelper.instance.database;

  // Run the app
  runApp(
    ChangeNotifierProvider(
      child: MyApp(),
      create: (BuildContext context) => ThemeProvider(isDarkMode: true),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          home: AuthPage(), // Set Homepage as the home screen
        );
      },
    );
  }
}
