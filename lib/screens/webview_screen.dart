import 'dart:async';

import 'package:agos/screens/pages/messages/chat_page.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../plugin/location.dart';
import '../utils/colors.dart';
import '../widgets/button_widget.dart';
import '../widgets/order_modal_widget.dart';

class MapviewScreen extends StatefulWidget {
  const MapviewScreen({super.key});

  @override
  State<MapviewScreen> createState() => MapviewScreenState();
}

class MapviewScreenState extends State<MapviewScreen> {
  double lat = 0;
  double long = 0;
  bool hasloaded = false;
  @override
  void initState() {
    super.initState();
    determinePosition();
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
    getAllStations();
  }

  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  getAllStations() {
    FirebaseFirestore.instance
        .collection('Merchant')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        markers.add(
          Marker(
            onTap: () {
              setState(() {
                merchantdata = doc;
              });
              showModalBottomSheet(
                  enableDrag: true,
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                              text: doc['name'],
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
                                  text: doc['address'],
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
                                  text: doc['number'],
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          driverId: doc.id,
                                          driverName: doc['name'])));
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
                                          price: doc['price'],
                                          myLat: lat,
                                          myLong: long,
                                          stationid: doc.id,
                                          address: doc['address'],
                                          name: doc['name'],
                                          number: doc['number'],
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
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId(doc['name']),
            position: LatLng(doc['location']['lat'], doc['location']['long']),
            infoWindow: InfoWindow(
              title: doc['name'],
            ),
          ),
        );

        setState(() {
          hasloaded = true;
        });
      }
    });
  }

  dynamic merchantdata = {};

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: hasloaded
          ? SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: primary,
                          ),
                        );
                      }),
                      TextBold(
                        text: 'Map View',
                        fontSize: 24,
                        color: primary,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      child: GoogleMap(
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        buildingsEnabled: true,
                        compassEnabled: true,
                        markers: markers,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          merchantdata['name'] != null
              ? FloatingActionButton(
                  backgroundColor: primary,
                  onPressed: () {
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
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                      driverId: merchantdata.id,
                                                      driverName:
                                                          merchantdata['name'],
                                                    )));
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
                                                myLat: lat,
                                                myLong: long,
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
                  child: const Icon(
                    Icons.local_mall_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
