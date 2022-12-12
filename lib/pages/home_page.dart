import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/pages/widget/file_load_error.dart';
import 'package:note_app/pages/widget/sidebar.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final currentUsers = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('note_data')
        .doc(currentUsers.currentUser!.email)
        .collection('user_notes')
        //.orderBy('name')
        // .where('uid', isEqualTo: currentUsers.currentUser!.uid)
        .snapshots();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore
        .collection('note_data')
        .doc(currentUsers.currentUser!.email)
        .collection('user_notes');

    //DocumentReference notesId = userCollection.doc(document);

    return Scaffold(
      drawer: SideBarWidget(),
      appBar: AppBar(
        title: Text(
          'Your notes',
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
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const FailLoadScreen();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                } else {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      String title = data['title'];
                      String description = data['description'];

                      return ListTile(
                        title: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20.0,
                                color: Colors.brown[900],
                              ),
                              onPressed: () {
                                // delete Favorite From cloud firestore
                                collection.doc(document.id).delete();
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/detail',
                            arguments: NoteModel(
                              id: collection.doc(document.id) as String,
                              title: title,
                              description: description,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
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
        onPressed: () {
          Navigator.of(context).pushNamed('/add_notes');
        },
        icon: Icon(Icons.add),
        label: Text('add new notes'),
        backgroundColor: Colors.orange[700],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/*

  ListView(
              shrinkWrap: true,
              children: [
                listNotes(),
                listNotes(),
                listNotes(),
              ],
            ),
 */
