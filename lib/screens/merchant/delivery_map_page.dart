import 'dart:async';

import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../plugin/location.dart';
import '../../utils/keys.dart';

class DeliveryMapScreen extends StatefulWidget {
  final String stationName;

  final dynamic orders;

  const DeliveryMapScreen({
    super.key,
    required this.orders,
    required this.stationName,
  });

  @override
  State<DeliveryMapScreen> createState() => DeliveryMapScreenState();
}

class DeliveryMapScreenState extends State<DeliveryMapScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
    addMarker();

    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        hasloaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });

    Timer.periodic(const Duration(seconds: 5), (timer) {
      for (int i = 0; i < widget.orders.length; i++) {
        addRoute(widget.orders[i]['location']['lat'],
            widget.orders[i]['location']['long']);
      }
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool hasloaded = false;
  GoogleMapController? mapController;

  double lat = 0;
  double long = 0;

  Set<Marker> markers = {};
  final Set<Polyline> _poly = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return Scaffold(
      appBar: AppbarWidget(widget.stationName),
      backgroundColor: Colors.white,
      body: hasloaded
          ? Stack(
              children: [
                GoogleMap(
                  polylines: _poly,
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
                    mapController = controller;
                    _controller.complete(controller);
                  },
                ),
              ],
            )
          : const SpinKitPulse(
              color: primary,
            ),
    );
  }

  addMarker() async {
    for (int i = 0; i < widget.orders.length; i++) {
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(widget.orders[i]['username']),
          position: LatLng(widget.orders[i]['location']['lat'],
              widget.orders[i]['location']['long']),
          infoWindow: InfoWindow(
            title: widget.orders[i]['username'],
          ),
        ),
      );
    }
  }

  addRoute(double orderLat, double orderLong) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        PointLatLng(lat, long),
        PointLatLng(orderLat, orderLong));
    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    setState(() {
      _poly.add(Polyline(
          color: Colors.red,
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          width: 4));
    });
    mapController!
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 18.0));

    // Accommodate the two locations within the
    // camera view of the map
  }
}
