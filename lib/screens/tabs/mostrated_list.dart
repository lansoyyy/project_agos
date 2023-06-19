import 'package:agos/screens/pages/map_page.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:agos/widgets/order_modal_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../services/distance_calculations.dart';
import '../../widgets/build_stars.dart';
import '../../widgets/text_widget.dart';

class MostRatedStationList extends StatelessWidget {
  const MostRatedStationList(
      {super.key,
      required this.myLat,
      required this.myLong,
      required this.filter});

  final double myLat;
  final double myLong;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Merchant')
            .where('name',
                isGreaterThanOrEqualTo: toBeginningOfSentenceCase(filter))
            .where('name', isLessThan: '${toBeginningOfSentenceCase(filter)}z')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          final sortedData = List<QueryDocumentSnapshot>.from(data.docs);

          // Sort the data by 'price' field
          sortedData.sort((a, b) {
            final double priceA = a['stars'].toDouble();
            final double priceB = b['stars'].toDouble();

            return priceB.compareTo(priceA);
          });

          return ListView.separated(
            itemCount: sortedData.length,
            separatorBuilder: (context, index) {
              return const Divider(
                color: primary,
              );
            },
            itemBuilder: (context, index) {
              final merchantdata = sortedData[index];
              return Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 500,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                    text: merchantdata['name'],
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
                                        text: merchantdata['address'],
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
                                        text: merchantdata['number'],
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ],
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
                                      color: secondary,
                                      label: 'CONTACT',
                                      onPressed: () {
                                        // Navigate to chat page
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
                                      color: primary,
                                      label: 'ORDER',
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return OrderModalWidget(
                                                price: merchantdata['price'],
                                                myLat: myLat,
                                                myLong: myLong,
                                                stationid: merchantdata.id,
                                                address:
                                                    merchantdata['address'],
                                                name: merchantdata['name'],
                                                number: merchantdata['number'],
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 175,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  merchantdata['stationImage'],
                                ),
                                fit: BoxFit.cover,
                              ),
                              color: primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildRatingStars(
                                    merchantdata['stars'].toDouble()),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextBold(
                                  text: merchantdata['stars'].toString(),
                                  fontSize: 15,
                                  color: primary,
                                ),
                              ],
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
                                TextBold(
                                  text: merchantdata['name'],
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: TextRegular(
                                    text: merchantdata['address'],
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: TextRegular(
                                    text:
                                        'Business Hours: ${merchantdata['businessHours']}',
                                    fontSize: 14,
                                    color: primary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextRegular(
                                  text: '₱${merchantdata['price']}/gallon',
                                  fontSize: 15,
                                  color: primary,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextBold(
                                  text:
                                      '${calculateDistance(myLat, myLong, merchantdata['location']['lat'], merchantdata['location']['long']).toStringAsFixed(2)}km away',
                                  fontSize: 16,
                                  color: primary,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
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
                                                  const MapScreen()));
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
                                    onPressed: (() async {}),
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
                ),
              );
            },
          );
        });
  }
}
