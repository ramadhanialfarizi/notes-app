import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddListPage extends StatefulWidget {
  const AddListPage({super.key});

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  var title_controller = TextEditingController();
  var description_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final currentUsers = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    title_controller.dispose();
    description_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore
        .collection('note_data')
        .doc(currentUsers.currentUser!.email)
        .collection('user_notes');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'add notes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: title_controller,
                    decoration: InputDecoration(
                      hintText: 'Judul',
                      //filled: true,
                    ),
                    validator: (title) {
                      if (title == null || title.isEmpty) {
                        return '* Silahkan masukan judul catatan';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: description_controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Deskripsi Catatan',
                    ),
                    validator: (description) {
                      if (description == null || description.isEmpty) {
                        return '* Silahkan masukan deskripsi catatan';
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: SizedBox(
          height: 60,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: Text('Save notes'),
        backgroundColor: Colors.orange[700],
        onPressed: () {
          var isValidForm = formKey.currentState!.validate();

          if (isValidForm) {
            collection.add({
              'title': title_controller.text,
              'description': description_controller.text,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('catatan berhasil ditambahkan'),
                duration: Duration(milliseconds: 800),
              ),
            );
            Navigator.pop(context);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
