import 'dart:async';

import 'package:agos/screens/home_screen.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/colors.dart';
import '../widgets/drawer_widget.dart';

class MapviewScreen extends StatefulWidget {
  const MapviewScreen({super.key});

  @override
  State<MapviewScreen> createState() => MapviewScreenState();
}

class MapviewScreenState extends State<MapviewScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: Colors.white,
      body: Column(
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
                icon: const Icon(
                  Icons.list_alt_rounded,
                  color: primary,
                ),
              )
            ],
          ),
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}
