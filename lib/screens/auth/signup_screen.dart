import 'package:agos/screens/auth/login_screen.dart';
import 'package:agos/screens/home_screen.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/textfield_widget.dart';
import 'package:agos/widgets/toast_widget.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactnumberController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: primary,
          image: DecorationImage(
              opacity: 100,
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
                  height: 125,
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
                      text: 'SIGNUP',
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
                  hint: 'Name',
                  label: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
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
                    } else if (value.length != 11 || !value.startsWith('09')) {
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
                    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                    final hasLowercase = value.contains(RegExp(r'[a-z]'));
                    final hasNumber = value.contains(RegExp(r'[0-9]'));
                    if (!hasUppercase || !hasLowercase || !hasNumber) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
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
                      showToast('Account created succesfully!');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
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
                        fontSize: 12,
                        color: Colors.white),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: TextBold(
                          text: 'Login', fontSize: 14, color: Colors.white),
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
    );
  }
}
