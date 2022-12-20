//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:note_app/handler/upload_handler.dart';
import 'package:file_picker/file_picker.dart';

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
  final UploadHandler storage = UploadHandler();
  String? imagePath;

  @override
  void dispose() {
    // TODO: implement dispose
    title_controller.dispose();
    description_controller.dispose();
    super.dispose();
  }

  // Future<XFile?> getImage() async {
  //   return await ImagePicker().pickImage(source: ImageSource.gallery);
  // }

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
    imagePath = await storage.getURLImage(fileName);

    setState(() {});
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
                  SizedBox(
                    height: 30,
                  ),
                  (imagePath != null)
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
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
                            foregroundColor: Colors.orange[700], // Text Color
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
              'image': imagePath,
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
