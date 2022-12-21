import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenStart();
  }

  splashScreenStart() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.of(context).pushReplacementNamed('/login');
      //Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splashScreen.png',
                scale: 3,
                // 4
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              // const Text(
              //   'Your Notes',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
