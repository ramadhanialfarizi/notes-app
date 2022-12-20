import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/model/note_model.dart';

class DetailPages extends StatefulWidget {
  const DetailPages({super.key});

  @override
  State<DetailPages> createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final parameter = ModalRoute.of(context)!.settings.arguments as NoteModel;
    String id = parameter.id as String;
    String title = parameter.title as String;
    String desc = parameter.description as String;
    String img = parameter.image as String;
    imagePath = img;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desc),
                const SizedBox(
                  height: 60,
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
                        height: 60,
                      ),
              ],
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
        onPressed: () {
          // try {
          //   Navigator.of(context).pushNamed('/edit_notes', arguments: id);
          // } catch (e) {
          //   print(e);
          // }
          Navigator.of(context).pushNamed('/edit_notes', arguments: id);
        },
        icon: const Icon(Icons.edit),
        label: const Text('edit notes'),
        backgroundColor: Colors.orange[700],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
