import 'package:agos/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/button_widget.dart';
import '../widgets/dialogs/normal_dialog.dart';
import '../widgets/text_widget.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                opacity: 100,
                image: AssetImage('assets/images/new.jpg'),
                fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Text(
                  'Embrace a Refreshing Lifestyle with AGOS!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'QBold',
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextRegular(
                    text:
                        "Discover the Easiest Way to Stay Hydrated and Embrace a Sustainable Lifestyle with AGOS: Way of Life – Your Ultimate Water Ordering and Refilling Companion.",
                    fontSize: 14,
                    color: Colors.white),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ButtonWidget(
                    labelColor: Colors.white,
                    radius: 100,
                    color: Colors.blue,
                    label: 'Get Started',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NormalDialog(
                                label:
                                    "AGOS collects location data to enable user tracking for the transaction of ride to be proccessed even when the app is closed or not in use.",
                                buttonColor: Colors.red,
                                buttonText: 'I understand',
                                icon: Icons.warning,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                iconColor: Colors.red);
                          });
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
