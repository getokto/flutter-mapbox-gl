// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:concurrent_queue/concurrent_queue.dart';

import 'main.dart';
import 'page.dart';

class UserLocationPage extends ExamplePage {
  UserLocationPage() : super(const Icon(Icons.map), 'User location');

  @override
  Widget build(BuildContext context) {
    return const _UserLocation();
  }
}

class _UserLocation extends StatefulWidget {
  const _UserLocation();
  @override
  State createState() => _UserLocationPageState();
}

class _UserLocationPageState extends State<_UserLocation> {

  _UserLocationPageState() {
    _userLocationRequestQueue = ConcurrentQueue(
      autoStart: true,
      concurrency: 1,
    )..on(QueueEventAction.idle, _handleUserLocationComplete);
  }

  late MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _handleUserLocationComplete(value){
    _previousPosition = null;
  }

  CameraPosition? _previousPosition;
  UserLocation? _previousUserLocation;
  late ConcurrentQueue _userLocationRequestQueue;


  Future<void> _onUserLocationUpdated(UserLocation location) async {
    if (location == _previousUserLocation) {
      return;
    }
    final prevPosition = _previousPosition ??= mapController.cameraPosition;
    final action = mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        prevPosition?.copyWith(
          target: location.position,
        ) ?? CameraPosition(target: location.position),
      ),
    );
    _userLocationRequestQueue.add(() => action);
    _previousUserLocation = location;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: MapboxMap(
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              onCameraIdle: () => print("onCameraIdle"),
              onUserLocationUpdated: _onUserLocationUpdated,
              trackCameraPosition: true,
              myLocationTrackingMode: MyLocationTrackingMode.Tracking,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.878781, -87.622088),
                pitch: 30,
                zoom: 14,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          bearing: 270.0,
                          target: LatLng(51.5160895, -0.1294527),
                          pitch: 30.0,
                          zoom: 17.0,
                        ),
                      ),
                    );
                  },
                  child: const Text('newCameraPosition'),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(
                      CameraUpdate.zoomBy(
                        -0.5,
                        const Offset(30.0, 20.0),
                      ),
                    );
                  },
                  child: const Text('zoomBy with focus'),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
