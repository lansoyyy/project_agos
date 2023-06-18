import 'package:agos/widgets/text_widget.dart';
import 'package:agos/widgets/ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../utils/colors.dart';
import 'button_widget.dart';

class OrderModalWidget extends StatefulWidget {
  const OrderModalWidget(
      {super.key,
      required this.address,
      required this.name,
      required this.number});
  final String address;
  final String name;
  final String number;

  @override
  State<OrderModalWidget> createState() => _OrderModalWidgetState();
}

class _OrderModalWidgetState extends State<OrderModalWidget> {
  List types = [
    'Small',
    'Medium',
    'Large',
  ];

  String type = 'Large';
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRegular(
                          text: '   Size of Gallon',
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButton<String>(
                              value: type,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 18,
                              elevation: 12,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: const SizedBox(),
                              onChanged: (newValue) {
                                setState(() {
                                  type = newValue!;
                                });
                              },
                              items: <String>[
                                'Small',
                                'Medium',
                                'Large'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: TextRegular(
                                        text: value,
                                        fontSize: 14,
                                        color: primary),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  ],
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
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: TicketWidget(
                                width: 600,
                                height: 500,
                                isCornerRounded: true,
                                padding: const EdgeInsets.all(5),
                                child: TicketData(
                                    stationName: 'Station Name',
                                    stationNumber: 'Station Contact Number',
                                    passenger: 'Customer Name',
                                    customerNumber: 'Customer contact number',
                                    customerLocation: 'Customer Address',
                                    fare: 'Payment'),
                              ),
                            );
                          });
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
    });
  }
}
