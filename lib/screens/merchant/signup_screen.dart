import 'dart:io';

import 'package:agos/screens/merchant/home_screen.dart';
import 'package:agos/screens/merchant/login_screen.dart';
import 'package:agos/services/add_merchant.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/textfield_widget.dart';
import 'package:agos/widgets/toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../plugin/location.dart';

class MerchantSignupScreen extends StatefulWidget {
  const MerchantSignupScreen({super.key});

  @override
  State<MerchantSignupScreen> createState() => _MerchantSignupScreenState();
}

class _MerchantSignupScreenState extends State<MerchantSignupScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final contactnumberController = TextEditingController();

  final businesshoursController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final priceController = TextEditingController();

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  List<bool> isSelected = [true, false];

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

        setState(() {});

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: primary,
            image: DecorationImage(
                opacity: 150,
                image: AssetImage(
                  'assets/images/background.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/text.png',
                      width: 175,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          color: Colors.white,
                          thickness: 3,
                        ),
                      ),
                      TextRegular(
                        text: 'SIGNING UP AS MERCHANT',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    icon: Icons.person,
                    textCapitalization: TextCapitalization.words,
                    hint: 'Name of the Station',
                    label: 'Name of the Station',
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a station name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextRegular(
                          text: 'Station picture',
                          fontSize: 12,
                          color: Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      const SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ButtonWidget(
                        height: 35,
                        width: 125,
                        radius: 100,
                        labelColor: Colors.white,
                        fontSize: 12,
                        label:
                            imageURL == '' ? 'Upload image' : 'Reupload image',
                        onPressed: () {
                          uploadPicture('camera');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.green,
                    title: TextRegular(
                      text: 'Delivery',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    value: isSelected[0],
                    onChanged: (value) {
                      setState(() {
                        isSelected[0] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    activeColor: Colors.green,
                    title: TextRegular(
                      text: 'Pickup',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    value: isSelected[1],
                    onChanged: (value) {
                      setState(() {
                        isSelected[1] = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    icon: Icons.phone,
                    textCapitalization: TextCapitalization.none,
                    inputType: TextInputType.number,
                    hint: 'Contact Number',
                    label: 'Contact Number',
                    controller: contactnumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact number';
                      } else if (value.length != 11 ||
                          !value.startsWith('09')) {
                        return 'Please enter a valid contact number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    icon: Icons.location_on,
                    textCapitalization: TextCapitalization.words,
                    hint: 'Address',
                    label: 'Address',
                    controller: addressController,
                    inputType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    icon: Icons.access_time_rounded,
                    hint: 'Business Hours (ex.8am - 4pm)',
                    label: 'Business Hours (ex. 8am - 4pm)',
                    controller: businesshoursController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business hours';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    icon: Icons.price_change_outlined,
                    inputType: TextInputType.number,
                    hint: 'Price per Gallon (ex. 12)',
                    label: 'Price per Gallon (ex. 12)',
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your price rate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    icon: Icons.email,
                    textCapitalization: TextCapitalization.none,
                    hint: 'Email',
                    label: 'Email',
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.none,
                    showEye: true,
                    isObscure: true,
                    icon: Icons.lock,
                    hint: 'Password',
                    label: 'Password',
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.none,
                    showEye: true,
                    isObscure: true,
                    icon: Icons.lock,
                    hint: 'Confirm Password',
                    label: 'Confirm Password',
                    controller: confirmpasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (value != passwordController.text) {
                        return 'Password do not match';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ButtonWidget(
                      radius: 100,
                      color: Colors.white,
                      label: 'SIGNUP',
                      onPressed: () {
                        if (imageURL == '') {
                          showToast('Please upload a picture to your station');
                        } else {
                          if (_formKey.currentState!.validate()) {
                            register(context);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextRegular(
                          text: 'Already have an account?',
                          fontSize: 14,
                          color: Colors.white),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MerchantLoginScreen()));
                        },
                        child: TextBold(
                            text: 'Login', fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      addMerchant(
        nameController.text,
        contactnumberController.text,
        addressController.text,
        emailController.text,
        businesshoursController.text,
        priceController.text,
        imageURL,
        isSelected[0] == true && isSelected[1] == true
            ? ['Delivery', 'Pickup']
            : isSelected[0] == true
                ? ['Delivery']
                : isSelected[1] == true
                    ? ['Pickup']
                    : [],
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      showToast('Account created succesfully!');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MerchantHomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
