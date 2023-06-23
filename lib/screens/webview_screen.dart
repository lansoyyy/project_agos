import 'dart:async';

import 'package:agos/screens/home_screen.dart';
import 'package:agos/screens/pages/messages/messages_screen.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../plugin/location.dart';
import '../utils/colors.dart';
import '../widgets/drawer_widget.dart';

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
        hasloaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return Scaffold(
      drawer: const DrawerWidget(),
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
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: primary,
                          ),
                        );
                      }),
                      TextBold(
                        text: 'HOME',
                        fontSize: 24,
                        color: primary,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        icon: const Icon(
                          Icons.list_alt_rounded,
                          color: primary,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      child: GoogleMap(
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        buildingsEnabled: true,
                        compassEnabled: true,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MessagesScreen()));
        },
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}
