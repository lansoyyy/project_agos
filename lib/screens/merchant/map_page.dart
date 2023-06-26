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

class MerchantMapScreen extends StatefulWidget {
  final String stationName;
  final double stationLat;
  final double stationLong;
  final dynamic merchantdata;

  const MerchantMapScreen(
      {super.key,
      required this.stationName,
      required this.merchantdata,
      required this.stationLat,
      required this.stationLong});

  @override
  State<MerchantMapScreen> createState() => MerchantMapScreenState();
}

class MerchantMapScreenState extends State<MerchantMapScreen> {
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
      addRoute();
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool hasloaded = false;
  GoogleMapController? mapController;

  double lat = 0;
  double long = 0;

  Set<Marker> markers = {};
  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

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
                  polylines: {_poly},
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
    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId(widget.stationName),
        position: LatLng(widget.stationLat, widget.stationLong),
        infoWindow: InfoWindow(
          title: widget.stationName,
        ),
      ),
    );
  }

  addRoute() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        PointLatLng(lat, long),
        PointLatLng(widget.stationLat, widget.stationLong));
    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    setState(() {
      _poly = Polyline(
          color: Colors.red,
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          width: 4);
    });
    mapController!
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 18.0));

    double miny = (lat <= widget.stationLat) ? lat : widget.stationLat;
    double minx = (long <= widget.stationLong) ? long : widget.stationLong;
    double maxy = (lat <= widget.stationLat) ? widget.stationLat : lat;
    double maxx = (long <= widget.stationLong) ? widget.stationLong : long;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    // Accommodate the two locations within the
    // camera view of the map
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            northEastLatitude,
            northEastLongitude,
          ),
          southwest: LatLng(
            southWestLatitude,
            southWestLongitude,
          ),
        ),
        100.0,
      ),
    );
  }
}
