import 'package:agos/screens/merchant/map_page.dart';
import 'package:agos/screens/merchant/messages/chat_page.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';

class TodayList extends StatefulWidget {
  final String filter;
  const TodayList({super.key, required this.filter, required this.query});

  final query;

  @override
  State<TodayList> createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String driverContactNumber = '';

  String userName = '';
  String myAddress = '';

  String userProfile = '';

  bool hasLoaded = false;

  getUserData() {
    FirebaseFirestore.instance
        .collection('Merchant')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          userName = doc['name'];
          userProfile = doc['stationImage'];
          myAddress = doc['address'];
          hasLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? StreamBuilder<QuerySnapshot>(
            stream: widget.query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              }

              final data = snapshot.requireData;

              return ListView.separated(
                itemCount: data.docs.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: primary,
                  );
                },
                itemBuilder: (context, index) {
                  final dateTime =
                      (data.docs[index]['dateTime'] as Timestamp).toDate();
                  final now = DateTime.now();
                  final difference = now.difference(dateTime);

                  String timeAgo;

                  if (difference.inSeconds < 60) {
                    timeAgo = '${difference.inSeconds} seconds ago';
                  } else if (difference.inMinutes < 60) {
                    timeAgo = '${difference.inMinutes} minutes ago';
                  } else if (difference.inHours < 24) {
                    timeAgo = '${difference.inHours} hours ago';
                  } else if (difference.inDays < 30) {
                    final days = difference.inDays;
                    timeAgo = '$days day${days > 1 ? 's' : ''} ago';
                  } else {
                    final months = difference.inDays ~/ 30;
                    timeAgo = '$months month${months > 1 ? 's' : ''} ago';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 125,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    data.docs[index]['userprofile'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: primary,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: TextBold(
                                text: timeAgo,
                                fontSize: 14,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextBold(
                                        text: data.docs[index]['username'],
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      data.docs[index]['status'] != 'Completed'
                                          ? ButtonWidget(
                                              radius: 100,
                                              width: 65,
                                              height: 30,
                                              label: 'Done',
                                              labelColor: Colors.white,
                                              fontSize: 11,
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                'Completed Confirmation',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'QBold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              content:
                                                                  const Text(
                                                                'Complete this order?',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'QRegular'),
                                                              ),
                                                              actions: <Widget>[
                                                                MaterialButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true),
                                                                  child:
                                                                      const Text(
                                                                    'Close',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'QRegular',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                MaterialButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Orders')
                                                                        .doc(data
                                                                            .docs[
                                                                                index]
                                                                            .id)
                                                                        .update({
                                                                      'status':
                                                                          'Completed'
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(data.docs[index]
                                                                            [
                                                                            'userId'])
                                                                        .update({
                                                                      'history':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        {
                                                                          'qty':
                                                                              data.docs[index]['qty'],
                                                                          'destination':
                                                                              data.docs[index]['useraddress'],
                                                                          'fare':
                                                                              data.docs[index]['payment'],
                                                                          'date':
                                                                              DateTime.now(),
                                                                          'userName':
                                                                              data.docs[index]['username'],
                                                                          'stationName':
                                                                              userName,
                                                                          'stationsAddress':
                                                                              myAddress,
                                                                        }
                                                                      ]),
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Merchant')
                                                                        .doc(FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                        .update({
                                                                      'history':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        {
                                                                          'qty':
                                                                              data.docs[index]['qty'],
                                                                          'destination':
                                                                              data.docs[index]['useraddress'],
                                                                          'fare':
                                                                              data.docs[index]['payment'],
                                                                          'date':
                                                                              DateTime.now(),
                                                                          'userName':
                                                                              data.docs[index]['username'],
                                                                          'stationName':
                                                                              userName,
                                                                          'stationsAddress':
                                                                              myAddress,
                                                                        }
                                                                      ]),
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Continue',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'QRegular',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ));
                                              },
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: TextRegular(
                                      text: data.docs[index]['useraddress'],
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextRegular(
                                    text:
                                        'Total: ₱${data.docs[index]['payment'].toInt()}.00',
                                    fontSize: 15,
                                    color: primary,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextRegular(
                                    text:
                                        'Quantity: ${data.docs[index]['qty']}pcs',
                                    fontSize: 15,
                                    color: primary,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextRegular(
                                    text: 'Size: ${data.docs[index]['size']}',
                                    fontSize: 15,
                                    color: primary,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MerchantMapScreen(
                                                      merchantdata:
                                                          data.docs[index],
                                                      stationLat: data
                                                              .docs[index]
                                                          ['location']['lat'],
                                                      stationLong: data
                                                              .docs[index]
                                                          ['location']['long'],
                                                      stationName:
                                                          data.docs[index]
                                                              ['username'],
                                                    )));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: primary,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.directions_outlined,
                                                color: primary,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                          TextRegular(
                                            text: 'Directions',
                                            fontSize: 12,
                                            color: primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    MaterialButton(
                                      elevation: 2,
                                      minWidth: 60,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      color: primary,
                                      onPressed: (() async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MerchantChatPage(
                                                      driverId: data.docs[index]
                                                          ['userId'],
                                                      driverName:
                                                          data.docs[index]
                                                              ['username'],
                                                    )));
                                      }),
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            })
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
