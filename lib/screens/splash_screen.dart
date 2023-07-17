import 'dart:async';

import 'package:agos/screens/get_started_screen.dart';
import 'package:agos/screens/home_screen.dart';
import 'package:agos/screens/merchant/home_screen.dart';
import 'package:agos/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  late bool accExist = false;
  String usertype = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot querySnapshot) async {
        setState(() {
          accExist = querySnapshot.exists;
          usertype = 'User';
        });
      });

      if (accExist == false) {
        FirebaseFirestore.instance
            .collection('Merchant')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot querySnapshot) async {
          setState(() {
            accExist = querySnapshot.exists;
            usertype = 'Merchant';
          });
        });
      }
    }

    Timer(const Duration(seconds: 5), () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return accExist
                    ? usertype == 'User'
                        ? const HomeScreen()
                        : const MerchantHomeScreen()
                    : const GetStartedScreen();
              } else {
                return const GetStartedScreen();
              }
            }),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: primary,
            image: DecorationImage(
                opacity: 150,
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/text.png',
                width: 250,
              ),
              const SizedBox(
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: LinearProgressIndicator(
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
