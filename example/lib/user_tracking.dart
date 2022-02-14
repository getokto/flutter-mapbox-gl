import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

class UserTrackingPage extends ExamplePage {
  UserTrackingPage() : super(const Icon(Icons.map), 'User tracking');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _handleCameraTrackingChanged(MyLocationTrackingMode trackingMode) {
   print(trackingMode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapboxMap(
      accessToken: MapsDemo.ACCESS_TOKEN,
      onMapCreated: _onMapCreated,
      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
      myLocationEnabled: true,
      onCameraTrackingChanged: _handleCameraTrackingChanged,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      onStyleLoadedCallback: onStyleLoadedCallback,
    ));
  }

  void onStyleLoadedCallback() {}
}
