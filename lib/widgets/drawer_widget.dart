import 'dart:io';

import 'package:agos/screens/pages/history_screen.dart';
import 'package:agos/screens/pages/messages/messages_screen.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/pages/aboutus_page.dart';
import '../screens/pages/contactus_page.dart';

class DrawerWidget extends StatefulWidget {
  final GlobalKey? key6;

  const DrawerWidget({super.key, this.key6});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    // getBadgeCount();
  }

  final numberController = TextEditingController();
  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profilePicture': imageURL});

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  int messageBadge = 0;

  // getBadgeCount() {
  //   FirebaseFirestore.instance
  //       .collection('Messages')
  //       .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .where('seen', isEqualTo: false)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) async {
  //     setState(() {
  //       messageBadge = querySnapshot.docs.length;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          dynamic data = snapshot.data;
          return SizedBox(
            child: Drawer(
              key: widget.key6,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 0),
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            accountEmail: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: primary,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextRegular(
                                          text: data['number'],
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  final formKey =
                                                      GlobalKey<FormState>();
                                                  return AlertDialog(
                                                    backgroundColor: primary,
                                                    title: TextRegular(
                                                        text:
                                                            'New contact number',
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                    content: Form(
                                                      key: formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFieldWidget(
                                                            icon: Icons.phone,
                                                            hint: '09XXXXXXXXX',
                                                            inputType:
                                                                TextInputType
                                                                    .number,
                                                            label:
                                                                'Mobile Number',
                                                            controller:
                                                                numberController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter a mobile number';
                                                              } else if (value
                                                                          .length !=
                                                                      11 ||
                                                                  !value.startsWith(
                                                                      '09')) {
                                                                return 'Please enter a valid mobile number';
                                                              }

                                                              return null;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: (() {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                            child: TextRegular(
                                                                text: 'Close',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                (() async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .doc(data[
                                                                        'id'])
                                                                    .update({
                                                                  'number':
                                                                      numberController
                                                                          .text
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            }),
                                                            child: TextBold(
                                                                text: 'Update',
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }));
                                          },
                                          child: const Icon(
                                            Icons.edit_outlined,
                                            color: primary,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: primary,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextRegular(
                                      text: data['email'],
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            accountName: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextBold(
                                text: data['name'],
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            currentAccountPicture: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                              child: CircleAvatar(
                                minRadius: 75,
                                maxRadius: 75,
                                backgroundImage: NetworkImage(
                                  data['profilePicture'],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, left: 30),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      onPressed: () {
                                        // Image picker
                                        uploadPicture('gallery');
                                      },
                                      icon: const Icon(Icons.camera_alt,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.home,
                              color: primary,
                            ),
                            title: TextRegular(
                              text: 'Home',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.message,
                              color: primary,
                            ),
                            title: TextRegular(
                              text: 'Messages',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MessagesScreen()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.my_library_books_outlined,
                              color: primary,
                            ),
                            title: TextRegular(
                              text: 'History',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.manage_accounts_outlined,
                              color: primary,
                            ),
                            title: TextRegular(
                              text: 'Contact us',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ContactusPage()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.info_outline_rounded,
                              color: primary,
                            ),
                            title: TextRegular(
                              text: 'About us',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AboutusPage()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout, color: primary),
                            title: TextRegular(
                              text: 'Logout',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Logout Confirmation',
                                          style: TextStyle(
                                              fontFamily: 'QBold',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to Logout?',
                                          style:
                                              TextStyle(fontFamily: 'QRegular'),
                                        ),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                  fontFamily: 'QRegular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            },
                                            child: const Text(
                                              'Continue',
                                              style: TextStyle(
                                                  fontFamily: 'QRegular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
