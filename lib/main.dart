import 'package:assignment_3/database/database_service.dart';
import 'package:assignment_3/services/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'pages/authentication/auth_page.dart';
import 'provider/theme.dart';



Future _firebaseBackgroundMessage(RemoteMessage message) async{
  if(message.notification!=null){
    print('Some notification received');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await initNotifications();
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  await DatabaseHelper.instance.database;
  // showWelcomeNotification();

  // @override
  // void initState(){
  //   showWelcomeNotification();
  //   // super.initstate();
  // }
  

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

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> initNotifications() async {
//   final AndroidInitializationSettings initializationSettingsAndroid =
//       const AndroidInitializationSettings('classme');

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onSelectNotification: (String? payload) async {
//       // Handle notification tap
//     },
//   );
// }

// Future<void> showWelcomeNotification() async {
//     // Define the notification details
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'quiz_channel', // ID for the notification channel
//       'Quiz Notifications', // Name of the notification channel
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       'Welcome back!', // Notification title
//       'New Quizzes available', // Notification body
//       platformChannelSpecifics,
//       payload: 'quiz_notification', // Optional payload
//     );
//   }