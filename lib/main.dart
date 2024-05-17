//import 'package:code1/101_HardwareAndro/icon_learn.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'TobbyDo/completed_page.dart';
import 'TobbyDo/to_do_app.dart';
import 'TobbyDo/to_do_items.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(ToDoItemsAdapter());
  final box = await Hive.openBox("save_box");
  //await box.clear();
  //await box.close();

  runApp(const MyApp()); //Ali DAYI
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TobbyDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: AnimatedSplashScreen(
        splash: "assets/tobbyDoLogoIcon.png",
        nextScreen: const ToDoApp(),
        //animationDuration: const Duration(milliseconds: 100),
        //splashTransition: SplashTransition.slideTransition,
      ),
      routes: {
        '/todo': (context) => const ToDoApp(),
        '/done': (context) => const Done(), // Define route for 'Done' page
      },
    );
  }
}
