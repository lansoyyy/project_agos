import 'package:agos/screens/auth/login_screen.dart';
import 'package:agos/screens/merchant/home_screen.dart';
import 'package:agos/screens/merchant/signup_screen.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../plugin/location.dart';
import '../../utils/colors.dart';
import '../../widgets/toast_widget.dart';

class MerchantLoginScreen extends StatefulWidget {
  const MerchantLoginScreen({super.key});

  @override
  State<MerchantLoginScreen> createState() => _MerchantLoginScreenState();
}

class _MerchantLoginScreenState extends State<MerchantLoginScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

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
                        text: 'LOGGING IN AS MERCHANT',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: ((context) {
                                  final formKey = GlobalKey<FormState>();
                                  final TextEditingController emailController =
                                      TextEditingController();

                                  return AlertDialog(
                                    backgroundColor: primary,
                                    title: TextRegular(
                                      text: 'Forgot Password',
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    content: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFieldWidget(
                                            icon: Icons.email,
                                            hint: 'Email',
                                            textCapitalization:
                                                TextCapitalization.none,
                                            inputType:
                                                TextInputType.emailAddress,
                                            label: 'Email',
                                            controller: emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter an email address';
                                              }
                                              final emailRegex = RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                              if (!emailRegex.hasMatch(value)) {
                                                return 'Please enter a valid email address';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: (() {
                                          Navigator.pop(context);
                                        }),
                                        child: TextRegular(
                                          text: 'Cancel',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: (() async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            try {
                                              Navigator.pop(context);
                                              await FirebaseAuth.instance
                                                  .sendPasswordResetEmail(
                                                      email:
                                                          emailController.text);
                                              showToast(
                                                  'Password reset link sent to ${emailController.text}');
                                            } catch (e) {
                                              String errorMessage = '';

                                              if (e is FirebaseException) {
                                                switch (e.code) {
                                                  case 'invalid-email':
                                                    errorMessage =
                                                        'The email address is invalid.';
                                                    break;
                                                  case 'user-not-found':
                                                    errorMessage =
                                                        'The user associated with the email address is not found.';
                                                    break;
                                                  default:
                                                    errorMessage =
                                                        'An error occurred while resetting the password.';
                                                }
                                              } else {
                                                errorMessage =
                                                    'An error occurred while resetting the password.';
                                              }

                                              showToast(errorMessage);
                                              Navigator.pop(context);
                                            }
                                          }
                                        }),
                                        child: TextBold(
                                          text: 'Continue',
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            },
                            child: TextRegular(
                                text: 'Forgot Password?',
                                fontSize: 12,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ButtonWidget(
                      radius: 100,
                      color: Colors.white,
                      label: 'LOGIN',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ButtonWidget(
                      radius: 100,
                      labelColor: Colors.white,
                      label: 'SIGNUP',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                const MerchantSignupScreen()));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: TextBold(
                        text: 'Continue as Customer',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
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

  login(context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showToast('Logged in as merchant');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MerchantHomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No user found with that email.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        showToast("Invalid email provided.");
      } else if (e.code == 'user-disabled') {
        showToast("User account has been disabled.");
      } else {
        showToast("An error occurred: ${e.message}");
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
