import 'package:agos/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketData extends StatelessWidget {
  late String passenger = '';

  late String customerNumber = '';

  late String customerLocation = '';
  late String stationName = '';
  late String stationNumber = '';

  late String fare = '';

  TicketData({
    super.key,
    required this.passenger,
    required this.stationNumber,
    required this.stationName,
    required this.customerNumber,
    required this.customerLocation,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.0,
                height: 25.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(width: 1.0, color: Colors.green),
                ),
                child: const Center(
                  child: Text(
                    'E-Ticket',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Order Placed Succesfully!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ticketDetailsWidget('Customer', passenger, 'Date', cdate),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ticketDetailsWidget(
                      'Contact Number', customerNumber, '', ''),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ticketDetailsWidget(
                      'Customer Address', customerLocation, '', ''),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ticketDetailsWidget(
                      'Water Station Name', stationName, '', ''),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ticketDetailsWidget(
                      'Station Contact Number', stationNumber, '', ''),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ticketDetailsWidget('Payment', '${fare}php', '', ''),
                ),
              ],
            ),
          ),
          const Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                  child: Center(
                      child: Text(
                    'AGOS - CDO',
                    style: TextStyle(
                        fontSize: 16, color: primary, fontFamily: 'QBold'),
                  )))),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.0, left: 75.0, right: 75.0),
              child: Text(
                '+639639530422',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'QRegular', fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
