import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  late SharedPreferences loginUser;
  final currentUsers = FirebaseAuth.instance;

  void logout() async {
    loginUser = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          userAccount(),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: button(context),
          ),
        ],
      ),
    );
  }

  Widget userAccount() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        'Welcome',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      accountEmail: Text(
        currentUsers.currentUser?.email ?? 'My email',
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      // currentAccountPicture: Container(
      //   margin: const EdgeInsets.only(bottom: 10),
      //   child: CircleAvatar(
      //     child: ClipOval(),
      //   ),
      // ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 171, 2),
      ),
    );
  }

  Widget button(context) {
    return SizedBox(
      width: double.infinity,
      height: 55.0,
      child: ElevatedButton.icon(
        onPressed: () {
          //Navigator.of(context).pushNamed('/cover');
          GoogleSignIn().signOut();
          FirebaseAuth.instance.signOut();
          loginUser.setBool('login', false);
          Navigator.of(context).pushReplacementNamed('/login');
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 255, 54, 54)),
        ),
        icon: const Icon(Icons.account_circle_outlined, size: 30),
        label: Text(
          'logout',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
