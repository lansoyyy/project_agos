import 'dart:async';

import 'package:agos/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MerchantMapScreen extends StatefulWidget {
  const MerchantMapScreen({super.key});

  @override
  State<MerchantMapScreen> createState() => MerchantMapScreenState();
}

class MerchantMapScreenState extends State<MerchantMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
    return Scaffold(
      appBar: AppbarWidget('Customer Name'),
      backgroundColor: Colors.white,
      body: GoogleMap(
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
    );
  }
}
