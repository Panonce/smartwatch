import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/login.dart';



class ProfileUpdate extends StatefulWidget {
  ProfileUpdate(this.updateFn);

  final void Function(
      String email,
      String password,
      String name,
      bool isLogIn,
      Role role,
      BuildContext ctx,
      String hr,
      ) updateFn;


  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  final databaseReference = FirebaseAuth.instance.currentUser!;
  final double profileHeight = 144;
  final nameController = TextEditingController();
  // final emailController = TextEditingController();
  //final passwordController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final hrController = TextEditingController();
  String displayText = "";


  void updateData() async {


    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.update({
      'name': nameController.text,
      // 'email': emailController.text,
      'number': numberController.text,
      'address': addressController.text,
      'profilePhoto' : _image,
      'hr' : hrController.text
      //'role': _role
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Edit Profile" ),
        centerTitle: true,
        backgroundColor: Colors.brown[300],
        elevation: 15,
        leading: IconButton(
          onPressed: () {
            if (nameController.text.isNotEmpty ||
                numberController.text.isNotEmpty ||
                addressController.text.isNotEmpty ||
                hrController.text.isNotEmpty ||
                _image != null) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Discard Changes?'),
                  content: Text('You have made changes. Are you sure to discard these changes?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('Discard'),
                    ),
                  ],
                ),
              ).then((shouldDiscard) {
                if (shouldDiscard) {
                  Navigator.pop(context);
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.chevron_left),
          color: Colors.black54,
        ),

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              /// -- PROFILE PICTURE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: buildProfileImage(),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      child:

                      /// -- NAME INPUT
                      TextFormField(
                        controller: nameController,
                        key: ValueKey('name'),
                        validator: (value){
                          if(value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },

                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              color: Colors.brown[600],
                              Icons.person,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(width: 2, color: Colors.deepOrange),
                            ),
                          label: const Text('Enter name'),
                            // hintText: 'Name'
                        ),
                        onSaved: (value) {
                          //   _userName = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// -- PHONE NUMBER INPUT

                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      child: TextFormField(
                        // initialValue: "123",
                        maxLength: 11,
                        key: ValueKey('number'),
                        keyboardType: TextInputType.number,
                        controller: numberController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              color: Colors.brown[600],
                              Icons.phone_android_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(width: 2, color: Colors.deepOrange),
                            ),
                            label: const Text('Enter number'),
                            // hintText: 'Phone Number'
                        ),
                        onSaved: (value) {
                          //  _userNum = value!;
                        },
                      ),
                    ),

                    /// -- HOME ADDRESS INPUT
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      child: TextFormField(
                        key: ValueKey('address'),
                        validator: (value){
                          if (value != null && value.isNotEmpty && (value.length < 11 || value.length > 11)) {
                            return 'Incorrect number';
                          }
                          return null;
                        },
                        controller: addressController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              color: Colors.brown[600],
                              Icons.home_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(width: 2, color: Colors.deepOrange),
                            ),
                            labelText: 'Enter Address',
                            hintText: 'Address'
                        ),
                        onSaved: (value) {
                          //  _userAdd = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 40, left: 40, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 257,
                                child: TextFormField(
                                  key: ValueKey('hr'),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length > 3 || value.length < 2) {
                                      return 'Invalid heart rate value';
                                    }
                                    return null;
                                  },
                                  controller: hrController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.monitor_heart_outlined, color: Colors.brown[600],),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(width: 2, color: Colors.deepOrange),
                                    ),
                                    labelText: 'Enter Normal Heart Rate',
                                    hintText: 'Normal Heart Rate',
                                  ),
                                  onSaved: (value) {
                                  },
                                ),
                              ),
                              SizedBox(width: 20,),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Note: Heart Rate must be verified by a professional'),
                                    ),
                                  );
                                },
                                child: Icon(Icons.help_outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    SizedBox (width: 200, height: 50,

                      child: ElevatedButton(onPressed: ()
                       {
                         updateData();
                         Navigator.pop(context); /// balik previous screen
                         },
                        child: Text("Save Changes"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[300],
                            shape: StadiumBorder()
                        ),
                      ),
                    ),

                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Picture Properties
  Widget buildProfileImage() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: profileHeight / 2,
          backgroundImage: _image != null ? FileImage(_image!) as ImageProvider<Object>? : NetworkImage(FirebaseAuth.instance.currentUser!.photoURL ??
              'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
        ),
        Positioned(
          bottom: 5,
          right: 15,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => changephoto()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey,
              size: 28.0,),
          ),
        ),
      ]),
    );
  }


  File? _image = null;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {  // <-- Add null check here
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// CHANGE PROFILE PICTURE
  Widget changephoto() {
    return Column(
      children: <Widget>[
        Text(
          "Choose Profile Photo",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                _getImage(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ],
        ),
        _image != null
            ? Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(_image!),
            ),
          ),
        )
            : Container(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Submit'),
        )
      ],
    );
  }

}