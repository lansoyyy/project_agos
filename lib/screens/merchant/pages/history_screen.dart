import 'package:agos/widgets/appbar_widget.dart';
import 'package:agos/widgets/merchant_drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/colors.dart';
import '../../../widgets/text_widget.dart';

class MerchantHistoryScreen extends StatelessWidget {
  const MerchantHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerwIDGET(),
      appBar: AppbarWidget('RECENT ORDERS'),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Merchant')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;

            List history = data['history'];
            List newhistory = history.reversed.toList();
            return ListView.separated(
              itemCount: newhistory.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: primary,
                );
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                        child: Center(
                          child: TextBold(
                              text: newhistory[index]['userName'][0],
                              fontSize: 48,
                              color: Colors.white),
                        ),
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
                                TextBold(
                                  text: newhistory[index]['userName'],
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: TextRegular(
                                    text: newhistory[index]['destination'],
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextRegular(
                                  text:
                                      'Paid: ₱${newhistory[index]['fare'].toInt()}.00',
                                  fontSize: 15,
                                  color: primary,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextRegular(
                                  text:
                                      'Quantity: ${newhistory[index]['qty']}pcs',
                                  fontSize: 15,
                                  color: primary,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextBold(
                                        text: DateFormat.yMMMd()
                                            .add_jm()
                                            .format(newhistory[index]['date']
                                                .toDate()),
                                        fontSize: 16,
                                        color: primary,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('Merchant')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'history': FieldValue.arrayRemove(
                                                [newhistory[index]]),
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
