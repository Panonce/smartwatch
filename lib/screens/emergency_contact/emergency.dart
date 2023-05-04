import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_watch/screens/emergency_contact/hotline.dart';


class EmergencyContactList extends StatefulWidget {
  @override
  _EmergencyContactListState createState() => _EmergencyContactListState();
}

class _EmergencyContactListState extends State<EmergencyContactList> {

  String _selectedOption = 'Select a relationship';

  final CollectionReference _contacts = FirebaseFirestore.instance.collection('contacts');
  final currentUser = FirebaseAuth.instance;

  // text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedOption = 'Select a relationship';
  }

  /// ADD CONTACT
  Future<void> _addContact ([DocumentSnapshot? documentSnapshot]) async {
    final user = FirebaseAuth.instance.currentUser!;
    final querySnapshot = await _contacts.where("uid", isEqualTo: user.uid).get();
    final contacts = querySnapshot.docs;

    if (contacts.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only have up to 3 emergency contacts.'),
        ),
      );
      return;
    }
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _phoneController.text = documentSnapshot['phone'];
      _addressController.text = documentSnapshot['address'];
      _relationshipController.text = documentSnapshot['relationship'];
    }
    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Add Emergency Contact',
          style: TextStyle(
          color: Colors.red[800],
         )
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue!;
                });
              },
              items: <String>[
                'Select a relationship',
                'Parent',
                'Sibling',
                'Relative',
                'Guardian',
                'Friend',
                'Partner',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          TextButton(
              onPressed: () async {
                final String name = _nameController.text;
                final String phone = _phoneController.text;
                final String address = _addressController.text;
                final String relationship = _selectedOption;

                // Execute a query to get the number of documents in the collection
                final querySnapshot = await _contacts.get();
                final numContacts = querySnapshot.size;

                if (numContacts <= 4) {
                  final user = await FirebaseAuth.instance.currentUser!;
                  await _contacts.add({
                    "name": name,
                    "phone": phone,
                    "address": address,
                    "relationship": relationship,
                    "uid": user.uid,
                  });

                  // Clear the text fields
                  _nameController.text = '';
                  _phoneController.text = '';
                  _addressController.text = '';
                  _selectedOption = 'Select a relationship';

                  Navigator.of(context).pop();
                } else if(numContacts > 3) {
                  Fluttertoast.showToast(msg: 'You can only have up to 3 emergency contacts');
                }

              },
              child: Text(
                'ADD',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
        ],
      );
    });
  }

  /// UPDATE CONTACT
  Future<void> _updateContact([DocumentSnapshot? documentSnapshot]) async {

    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _phoneController.text = documentSnapshot['phone'];
      _addressController.text = documentSnapshot['address'];
      _relationshipController.text = documentSnapshot['relationship'];
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // prevent the soft keyboard from covering text fields
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Contact Number'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              /*TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(labelText: 'Relationship'),
              ),*/
              const SizedBox(height: 10),
              Text('Relationship:'),
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <String>[
                  'Select a relationship',
                  'Parent',
                  'Sibling',
                  'Relative',
                  'Guardian',
                  'Friend',
                  'Partner',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String phone = _phoneController.text;
                    final String address = _addressController.text;
                    final String relationship = _relationshipController.text;

                    if (_contacts != null) {
                      final user = await FirebaseAuth.instance.currentUser!;
                      await _contacts.doc(documentSnapshot!.id).update({
                        "name": name,
                        "phone": phone,
                        "address": address,
                        "relationship": relationship,
                        "uid": user.uid,
                      });

                      _nameController.text = '';
                      _phoneController.text = '';
                      _addressController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update emergency contact'),
              ),
            ],
          ),
        );
      });
  }

  /// DELETE CONTACT
  Future<void> _deleteContact(String contactId) async {
    await _contacts.doc(contactId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Emergency contact successfully deleted.')
    ));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Emergency Contacts',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.brown[300],
          bottom: TabBar(
            indicatorColor: Colors.brown[100],
            indicatorWeight: 5,
            tabs: [
              Tab(
                text: 'Contact List',
              ),
              Tab(
                text: 'Hotlines',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// -- STREAMBUILDER TAB
            StreamBuilder(
              stream: _contacts.where('uid', isEqualTo: currentUser.currentUser?.uid).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    // number of rows
                    itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(documentSnapshot['phone']),
                                Text(documentSnapshot['relationship']),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber(documentSnapshot['phone']);
                                    },
                                    icon: const Icon(Icons.call),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _updateContact(documentSnapshot);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Delete Contact'),
                                              content: Text('Are you sure you want to delete this emergency contact?'),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                        color: Colors.brown[300],
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      _deleteContact(documentSnapshot.id);
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'DELETE',
                                                      style: TextStyle(
                                                        color: Colors.deepOrange.shade200,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),

                            ),
                          ),
                        );
                      }
                  );
                }
                return const Center(
                  child: Text('You have no emergency contacts.'),
                );
              },
            ),
            EmergencyHotline(),
          ],
        ),

        // ADD NEW CONTACT
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addContact();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.brown[400],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
