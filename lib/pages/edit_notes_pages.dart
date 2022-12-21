//import 'dart:html';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/handler/upload_handler.dart';
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
  final UploadHandler storage = UploadHandler();
  String? imagePath;
  String? imageUpdate;

  @override
  void dispose() {
    // TODO: implement dispose
    title_controller.dispose();
    description_controller.dispose();
    super.dispose();
  }

  dynamic getImage() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png", "jpg"],
      allowMultiple: false,
    );

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('no selected file'),
          duration: Duration(milliseconds: 800),
        ),
      );
      return null;
    }

    final path = file.files.single.path!;
    final fileName = file.files.single.name;

    storage.uploadImage(path, fileName);
    imageUpdate = await storage.getURLImage(fileName);

    print(imageUpdate);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final idParameter = ModalRoute.of(context)!.settings.arguments as String;
    //String id = parameter.id as String;

    // print(idParameter);
    // print(currentUsers.currentUser!.email);

    CollectionReference collection = FirebaseFirestore.instance
        .collection('note_data')
        .doc(currentUsers.currentUser!.uid)
        .collection('user_notes');
    DocumentReference updateCollection = collection.doc(idParameter);

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
                  imagePath = data['image'];
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
                        const SizedBox(
                          height: 30,
                        ),
                        if (imagePath == 'no have photo' &&
                            imageUpdate == null) ...[
                          SizedBox(
                            height: 0,
                          )
                        ] else if (imageUpdate != null) ...[
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUpdate!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                        // (imagePath == "no have photo")
                        //     ? SizedBox(
                        //         height: 0,
                        //       )
                        //     : Container(
                        //         width: double.infinity,
                        //         height: 200,
                        //         decoration: BoxDecoration(
                        //           image: DecorationImage(
                        //             image: NetworkImage(imagePath!),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'upload image',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                child: const Text(
                                  'upload',
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.orange[700], // Text Color
                                ),
                                onPressed: () async {
                                  getImage();
                                },
                              ),
                            ),
                          ],
                        )
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
              'image': imageUpdate ?? "no have photo",
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('catatan berhasil ditambahkan'),
                duration: Duration(milliseconds: 800),
              ),
            );
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
