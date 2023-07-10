import 'package:agos/services/add_order.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/ticket_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../utils/colors.dart';
import 'button_widget.dart';

class OrderModalWidget extends StatefulWidget {
  const OrderModalWidget(
      {super.key,
      required this.address,
      required this.stationid,
      required this.myLat,
      required this.myLong,
      required this.name,
      required this.price,
      required this.number});
  final String address;
  final String price;
  final String name;
  final String number;
  final double myLat;
  final double myLong;
  final String stationid;

  @override
  State<OrderModalWidget> createState() => _OrderModalWidgetState();
}

class _OrderModalWidgetState extends State<OrderModalWidget> {
  @override
  void initState() {
    super.initState();
    getMyBookings();
  }

  bool hasLoaded = false;

  getMyBookings() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot querySnapshot) async {
      setState(() {
        myName = querySnapshot['name'];
        myNumber = querySnapshot['number'];
        myAddress = querySnapshot['address'];
        myprofile = querySnapshot['profilePicture'];

        hasLoaded = true;
      });
    });
  }

  String type = 'Large';
  String myName = '';
  String myNumber = '';
  String myAddress = '';
  String myprofile = '';
  int qty = 1;

  late String orderType = 'Refill';

  final List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      TextBold(
                        text: widget.name,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      const Divider(
                        color: primary,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextRegular(
                            text: widget.address,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.phone,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextRegular(
                            text: widget.number,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const Divider(
                        color: primary,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextRegular(
                        text: 'Gallon Type',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 125,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/galloon.png'),
                              ),
                            ),
                          ),
                          Container(
                            width: 125,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/container.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextRegular(
                                text: '   Quantity',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (qty != 1) {
                                          setState(
                                            () {
                                              qty--;
                                            },
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: primary,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 50,
                                        child: VerticalDivider(
                                          color: primary,
                                          thickness: 1,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextBold(
                                        text: qty.toString(),
                                        fontSize: 18,
                                        color: primary),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const SizedBox(
                                        height: 50,
                                        child: VerticalDivider(
                                          color: primary,
                                          thickness: 1,
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            qty++;
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 18,
                                        color: primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextRegular(
                                    text: '   Order Type',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ToggleButtons(
                                      borderRadius: BorderRadius.circular(5),
                                      splashColor: Colors.grey,
                                      color: Colors.black,
                                      selectedColor: Colors.blue,
                                      onPressed: (int newIndex) {
                                        setState(() {
                                          for (int index = 0;
                                              index < _isSelected.length;
                                              index++) {
                                            if (index == newIndex) {
                                              _isSelected[index] = true;
                                              if (_isSelected[0] == true) {
                                                orderType = 'Refill';
                                              } else {
                                                orderType = 'Restock';
                                              }
                                            } else {
                                              _isSelected[index] = false;
                                            }
                                          }
                                        });
                                      },
                                      isSelected: _isSelected,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextRegular(
                                            text: 'Refill',
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextRegular(
                                            text: 'Restock',
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: primary,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ButtonWidget(
                          radius: 100,
                          labelColor: Colors.white,
                          color: primary,
                          label: 'ORDER',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Order Confirmation',
                                        style: TextStyle(
                                            fontFamily: 'QBold',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                        'Are you sure you want to place this order?',
                                        style:
                                            TextStyle(fontFamily: 'QRegular'),
                                      ),
                                      actions: <Widget>[
                                        MaterialButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(
                                                fontFamily: 'QRegular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            addOrder(
                                                myName,
                                                myNumber,
                                                myAddress,
                                                widget.myLat,
                                                widget.myLong,
                                                widget.stationid,
                                                double.parse(widget.price) *
                                                    qty,
                                                type,
                                                qty,
                                                myprofile,
                                                orderType);

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: TicketWidget(
                                                      width: 600,
                                                      height: 500,
                                                      isCornerRounded: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: TicketData(
                                                          stationName:
                                                              widget.name,
                                                          stationNumber:
                                                              widget.number,
                                                          passenger: myName,
                                                          customerNumber:
                                                              myNumber,
                                                          customerLocation:
                                                              myAddress,
                                                          fare:
                                                              '${double.parse(widget.price) * qty}'),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                                fontFamily: 'QRegular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ));
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
                          color: Colors.red,
                          label: 'CANCEL',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
        : const SpinKitPulse(
            color: primary,
          );
  }
}
