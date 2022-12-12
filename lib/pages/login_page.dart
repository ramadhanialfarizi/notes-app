import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  late SharedPreferences loginUser;
  late bool newUser;

  void checkLogin() async {
    loginUser = await SharedPreferences.getInstance();
    newUser = loginUser.getBool('login') ?? false;

    if (newUser == true) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
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
                scale: 4,
                // 4
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Welcome to Notes app',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 45,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.account_circle_outlined, size: 30),
                  label: const Text(
                    ' Login with your Google account',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 171, 2)),
                  ),
                  onPressed: () async {
                    if (FirebaseAuth.instance.currentUser == null) {
                      GoogleSignInAccount? account =
                          await GoogleSignIn().signIn();

                      if (account != null) {
                        GoogleSignInAuthentication auth =
                            await account.authentication;
                        OAuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: auth.accessToken,
                          idToken: auth.idToken,
                        );
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        loginUser.setBool('login', true);
                        // loginUser.setString(
                        //     'username', account.authentication);
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
