import 'package:agos/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../services/add_messages.dart';
import '../../../widgets/text_widget.dart';

class MerchantChatPage extends StatefulWidget {
  final String driverId;
  final String driverName;

  const MerchantChatPage({
    super.key,
    required this.driverId,
    required this.driverName,
  });
  @override
  State<MerchantChatPage> createState() => _MerchantChatPageState();
}

class _MerchantChatPageState extends State<MerchantChatPage> {
  @override
  void initState() {
    super.initState();
    getUserData();
    getDriverData();
  }

  final messageController = TextEditingController();

  String message = '';

  final ScrollController _scrollController = ScrollController();

  bool executed = true;

  String driverContactNumber = '';
  String userName = '';
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
        });
      }
    });
  }

  String driverProfile = '';

  getDriverData() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: widget.driverId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          driverContactNumber = doc['number'];
          driverProfile = doc['profilePicture'];
          hasLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> chatData = FirebaseFirestore.instance
        .collection('Messages')
        .doc(widget.driverId + FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          foregroundColor: primary,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                minRadius: 22,
                maxRadius: 22,
                backgroundImage: NetworkImage(driverProfile),
              ),
              const SizedBox(
                width: 10,
              ),
              TextRegular(
                  text: widget.driverName, fontSize: 18, color: primary),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                var text = 'tel:$driverContactNumber';
                if (await canLaunch(text)) {
                  await launch(text);
                }
              },
              icon: const Icon(
                Icons.call,
                color: primary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: hasLoaded
            ? SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: chatData,
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading'));
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: SizedBox(
                                    child: CircularProgressIndicator()));
                          }

                          try {
                            dynamic data = snapshot.data;
                            List messages = data['messages'] ?? [];
                            return Expanded(
                              child: SizedBox(
                                child: ListView.builder(
                                    itemCount: messages.isNotEmpty
                                        ? messages.length
                                        : 0,
                                    controller: _scrollController,
                                    itemBuilder: ((context, index) {
                                      if (executed) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);

                                          setState(() {
                                            executed = false;
                                          });
                                        });
                                      }
                                      return Row(
                                        mainAxisAlignment: messages[index]
                                                    ['sender'] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          messages[index]['sender'] !=
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: CircleAvatar(
                                                    minRadius: 15,
                                                    maxRadius: 15,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            driverProfile),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Column(
                                            crossAxisAlignment: messages[index]
                                                        ['sender'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 15.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0),
                                                    bottomLeft: messages[index]
                                                                ['sender'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? const Radius.circular(
                                                            20.0)
                                                        : const Radius.circular(
                                                            0.0),
                                                    bottomRight: messages[index]
                                                                ['sender'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? const Radius.circular(
                                                            0.0)
                                                        : const Radius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  messages[index]['message'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontFamily: 'QRegular'),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  DateFormat.jm().format(
                                                      messages[index]
                                                              ['dateTime']
                                                          .toDate()),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.0,
                                                      fontFamily: 'QRegular'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          messages[index]['sender'] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: CircleAvatar(
                                                    minRadius: 15,
                                                    maxRadius: 15,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      userProfile,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      );
                                    })),
                              ),
                            );
                          } catch (e) {
                            return const Expanded(child: SizedBox());
                          }
                        }),
                    const Divider(
                      color: primary,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 45,
                              width: 240,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              child: TextFormField(
                                style: const TextStyle(
                                  fontFamily: 'QBold',
                                  color: primary,
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: messageController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: primary),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: primary),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  hintText: 'Type a message',
                                  hintStyle: const TextStyle(
                                      fontSize: 12,
                                      color: primary,
                                      fontFamily: 'QRegular'),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  message = value;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              minWidth: 75,
                              height: 45,
                              color: primary,
                              onPressed: (() async {
                                if (message != '') {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('Messages')
                                        .doc(widget.driverId +
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .update({
                                      'lastMessage': messageController.text,
                                      'dateTime': DateTime.now(),
                                      'seen': false,
                                      'messages': FieldValue.arrayUnion([
                                        {
                                          'message': messageController.text,
                                          'dateTime': DateTime.now(),
                                          'sender': FirebaseAuth
                                              .instance.currentUser!.uid
                                        },
                                      ]),
                                    });
                                  } catch (e) {
                                    addMessage(
                                        widget.driverId,
                                        messageController.text,
                                        widget.driverName,
                                        userName,
                                        driverProfile,
                                        userProfile);
                                  }
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOut);
                                  messageController.clear();
                                  message = '';
                                }
                              }),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit this conversation?'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: TextRegular(text: 'No', fontSize: 12, color: primary),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: TextBold(text: 'Yes', fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }
}
