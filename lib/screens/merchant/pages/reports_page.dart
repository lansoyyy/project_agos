import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/appbar_widget.dart';
import '../../../widgets/merchant_drawer_widget.dart';
import '../../../widgets/text_widget.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    getTotalFare();
    super.initState();
  }

  List fares = [];

  bool hasLoaded = false;

  double total = 0;
  double today = 0;
  double average = 0;

  double monday = 0;
  double tuesday = 0;
  double wednesday = 0;
  double thursday = 0;
  double friday = 0;
  double saturday = 0;
  double sunday = 0;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Mon', monday),
      ChartData('Tue', tuesday),
      ChartData('Wed', wednesday),
      ChartData('Thu', thursday),
      ChartData('Fri', friday),
      ChartData('Sat', saturday),
      ChartData('Sun', sunday),
    ];
    return Scaffold(
        drawer: const DrawerwIDGET(),
        appBar: AppbarWidget('Earnings report'),
        body: hasLoaded
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF363636),
                            Color(0xFF363636),
                            Color(0xFF363636),
                          ],
                          stops: [0.0, 0.848, 0.6],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextRegular(
                              text: 'Total:',
                              fontSize: 14,
                              color: Colors.white),
                          const SizedBox(
                            width: 10,
                          ),
                          TextBold(
                              text:
                                  '₱${NumberFormat('#,##0.00', 'en_US').format(total)}',
                              fontSize: 42,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: TextRegular(
                        text:
                            'Today: ₱${NumberFormat('#,##0.00', 'en_US').format(today)}',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                    child: Column(
                      children: [
                        TextRegular(
                            text: 'Number of orders per week',
                            fontSize: 18,
                            color: Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            series: <ChartSeries<ChartData, String>>[
                              // Renders column chart
                              ColumnSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y)
                            ]),
                      ],
                    ),
                  )
                ],
              ))
            : const Center(child: CircularProgressIndicator()));
  }

  getTotalFare() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('stationid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'Completed')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        DateTime dateTime = doc['dateTime'].toDate();

        setState(() {
          if (dateTime.year == DateTime.now().year &&
              dateTime.month == DateTime.now().month &&
              dateTime.day == DateTime.now().day) {
            today += doc['payment'].toDouble();
          }

          if (dateTime.weekday == DateTime.monday) {
            monday += 1;
          } else if (dateTime.weekday == DateTime.tuesday) {
            tuesday += 1;
          } else if (dateTime.weekday == DateTime.wednesday) {
            wednesday += 1;
          } else if (dateTime.weekday == DateTime.thursday) {
            thursday += 1;
          } else if (dateTime.weekday == DateTime.friday) {
            friday += 1;
          } else if (dateTime.weekday == DateTime.saturday) {
            saturday += 1;
          } else if (dateTime.weekday == DateTime.sunday) {
            sunday += 1;
          }
          total += doc['payment'].toDouble();
        });
      }
    });

    setState(() {
      hasLoaded = true;
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class ChartData1 {
  ChartData1(this.x, this.y);
  final String x;
  final double? y;
}
