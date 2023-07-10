import 'package:agos/plugin/location.dart';
import 'package:agos/screens/merchant/messages/messages_screen.dart';
import 'package:agos/screens/tabs/order_list_tab.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/merchant_drawer_widget.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:badges/badges.dart' as b;

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
    Geolocator.getCurrentPosition().then((position) {
      FirebaseFirestore.instance
          .collection('Merchant')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'location': {'lat': position.latitude, 'long': position.longitude},
      });
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        hasloaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  bool hasloaded = false;
  double lat = 0;
  double long = 0;

  final messageController = TextEditingController();

  String filter = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: const DrawerwIDGET(),
        backgroundColor: Colors.white,
        body: hasloaded
            ? SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 190,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu_rounded,
                                    color: primary,
                                  ),
                                );
                              }),
                              TextBold(
                                text: 'MERCHANT HOME',
                                fontSize: 24,
                                color: primary,
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)),
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontFamily: 'QBold',
                                    color: primary,
                                    fontSize: 14,
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: primary,
                                      ),
                                      suffixIcon: filter != ''
                                          ? IconButton(
                                              onPressed: (() {
                                                setState(() {
                                                  filter = '';
                                                  messageController.clear();
                                                });
                                              }),
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                color: primary,
                                              ),
                                            )
                                          : const SizedBox(),
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: primary),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: primary),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintText: 'Search Orders',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                        fontFamily: 'QRegular',
                                        color: primary,
                                        fontSize: 14,
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      filter = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Messages')
                                          .where('lastId',
                                              isNotEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .where('driverId',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .where('seen', isEqualTo: false)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print('error');
                                          return const Center(
                                              child: Text('Error'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }

                                        final data = snapshot.requireData;
                                        return b.Badge(
                                          showBadge: data.docs.isNotEmpty,
                                          badgeAnimation:
                                              const b.BadgeAnimation.fade(),
                                          badgeStyle: const b.BadgeStyle(
                                            badgeColor: Colors.red,
                                          ),
                                          badgeContent: TextRegular(
                                              text: data.docs.length.toString(),
                                              fontSize: 12,
                                              color: Colors.white),
                                          child: MaterialButton(
                                            elevation: 2,
                                            minWidth: 60,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            color: primary,
                                            onPressed: (() {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MerchantMessagesScreen()));
                                            }),
                                            child: const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        );
                                      }),
                                  TextBold(
                                    text: 'Messages',
                                    fontSize: 12,
                                    color: primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const TabBar(
                            labelPadding: EdgeInsets.all(0),
                            indicatorPadding: EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 1,
                            labelStyle: TextStyle(
                              fontFamily: 'QRegular',
                              color: primary,
                              fontSize: 14,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontFamily: 'QRegular',
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            labelColor: primary,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                text: 'Today',
                              ),
                              Tab(
                                text: 'To Deliver',
                              ),
                              Tab(
                                text: 'To Pickup',
                              ),
                              Tab(
                                text: 'Done',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: TabBarView(
                          children: [
                            TodayList(
                              filter: filter,
                              query: FirebaseFirestore.instance
                                  .collection('Orders')
                                  .where('stationid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where('username',
                                      isGreaterThanOrEqualTo:
                                          toBeginningOfSentenceCase(filter))
                                  .where('username',
                                      isLessThan:
                                          '${toBeginningOfSentenceCase(filter)}z')
                                  .where('status', isEqualTo: 'Pending')
                                  .snapshots(),
                            ),
                            TodayList(
                              filter: filter,
                              query: FirebaseFirestore.instance
                                  .collection('Orders')
                                  .where('stationid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where('username',
                                      isGreaterThanOrEqualTo:
                                          toBeginningOfSentenceCase(filter))
                                  .where('username',
                                      isLessThan:
                                          '${toBeginningOfSentenceCase(filter)}z')
                                  .where('mode', isEqualTo: 'To Deliver')
                                  .where('status', isEqualTo: 'Pending')
                                  .snapshots(),
                            ),
                            TodayList(
                              filter: filter,
                              query: FirebaseFirestore.instance
                                  .collection('Orders')
                                  .where('stationid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where('username',
                                      isGreaterThanOrEqualTo:
                                          toBeginningOfSentenceCase(filter))
                                  .where('username',
                                      isLessThan:
                                          '${toBeginningOfSentenceCase(filter)}z')
                                  .where('mode', isEqualTo: 'To Pickup')
                                  .where('status', isEqualTo: 'Pending')
                                  .snapshots(),
                            ),
                            TodayList(
                              filter: filter,
                              query: FirebaseFirestore.instance
                                  .collection('Orders')
                                  .where('stationid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where('status', isEqualTo: 'Completed')
                                  .where('username',
                                      isGreaterThanOrEqualTo:
                                          toBeginningOfSentenceCase(filter))
                                  .where('username',
                                      isLessThan:
                                          '${toBeginningOfSentenceCase(filter)}z')
                                  .snapshots(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SpinKitPulse(
                color: primary,
              ),
      ),
    );
  }
}
