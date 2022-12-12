import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/pages/add_notes_page.dart';
import 'package:note_app/pages/detail_page.dart';
import 'package:note_app/pages/edit_notes_pages.dart';
import 'package:note_app/pages/home_page.dart';
import 'package:note_app/pages/login_page.dart';
import 'package:note_app/pages/widget/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(
                builder: (_) => const SplashScreen(), settings: settings);
          case '/login':
            return CupertinoPageRoute(
                builder: (_) => const LoginPages(), settings: settings);
          case '/home':
            return CupertinoPageRoute(
                builder: (_) => const HomePages(), settings: settings);
          case '/add_notes':
            return CupertinoPageRoute(
                builder: (_) => const AddListPage(), settings: settings);
          case '/detail':
            return CupertinoPageRoute(
                builder: (_) => const DetailPages(), settings: settings);
          case '/edit_notes':
            return CupertinoPageRoute(
                builder: (_) => const EditNotesPages(), settings: settings);
        }
        return null;
      },
    );
  }
}
