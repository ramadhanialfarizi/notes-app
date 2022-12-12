import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/pages/widget/file_load_error.dart';

import '../model/note_model.dart';

class EditNotesPages extends StatefulWidget {
  const EditNotesPages({super.key});

  @override
  State<EditNotesPages> createState() => _EditNotesPagesState();
}

class _EditNotesPagesState extends State<EditNotesPages> {
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
    final parameter = ModalRoute.of(context)!.settings.arguments as NoteModel;
    String id = parameter.id as String;

    CollectionReference collection = FirebaseFirestore.instance
        .collection('note_data')
        .doc(currentUsers.currentUser!.email)
        .collection('user_notes');
    DocumentReference updateCollection = collection.doc(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit notes',
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
            child: FutureBuilder<DocumentSnapshot>(
              future: updateCollection.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return FailLoadScreen();
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  title_controller.text = data['title'];
                  description_controller.text = data['description'];
                  return Form(
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
                  );
                }
                return Text("loading");
              },
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
            updateCollection.update({
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
