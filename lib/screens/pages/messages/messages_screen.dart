import 'package:agos/widgets/appbar_widget.dart';
import 'package:agos/widgets/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../../utils/colors.dart';
import '../../../widgets/text_widget.dart';
import 'chat_page.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final messageController = TextEditingController();

  String filter = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('MESSAGES'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 275,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: TextFormField(
              style: const TextStyle(
                fontFamily: 'QBold',
                color: primary,
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
                    borderSide: const BorderSide(width: 1, color: primary),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: primary),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: 'Search Messages',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    fontFamily: 'QRegular',
                    color: primary,
                    fontSize: 12,
                  )),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: filter != ''
                  ? FirebaseFirestore.instance
                      .collection('Messages')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('name',
                          isGreaterThanOrEqualTo:
                              toBeginningOfSentenceCase(filter))
                      .where('name',
                          isLessThan: '${toBeginningOfSentenceCase(filter)}z')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Messages')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy('dateTime')
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('error');
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;
                return Expanded(
                  child: SizedBox(
                    child: ListView.separated(
                      itemCount: data.docs.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: primary,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          child: GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('Messages')
                                  .doc(data.docs[index].id)
                                  .update({'seen': true});
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        driverId: data.docs[index]['driverId'],
                                        driverName: data.docs[index]
                                            ['driverName'],
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data.docs[index]['driverProfile'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    color: primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          data.docs[index]['seen'] == true
                                              ? TextRegular(
                                                  text: data.docs[index]
                                                      ['driverName'],
                                                  fontSize: 15,
                                                  color: primary)
                                              : TextBold(
                                                  text: data.docs[index]
                                                      ['driverName'],
                                                  fontSize: 15,
                                                  color: Colors.black),
                                          SizedBox(
                                            width: 180,
                                            child: data.docs[index]['seen'] ==
                                                    true
                                                ? Text(
                                                    data.docs[index][
                                                                    'lastMessage']
                                                                .toString()
                                                                .length >
                                                            21
                                                        ? '${data.docs[index]['lastMessage'].toString().substring(0, 21)}...'
                                                        : data.docs[index]
                                                            ['lastMessage'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: primary,
                                                        fontFamily: 'QRegular'),
                                                  )
                                                : Text(
                                                    data.docs[index][
                                                                    'lastMessage']
                                                                .toString()
                                                                .length >
                                                            21
                                                        ? '${data.docs[index]['lastMessage'].toString().substring(0, 21)}...'
                                                        : data.docs[index]
                                                            ['lastMessage'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontFamily: 'QBold'),
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.55,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextBold(
                                                  text: '3 minutes ago',
                                                  fontSize: 16,
                                                  color: primary,
                                                ),
                                                const Expanded(
                                                  child: SizedBox(
                                                    width: 30,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
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
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
