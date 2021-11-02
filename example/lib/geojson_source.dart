import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

const randomMarkerNum = 100;

class GeoJsonExamplePage extends ExamplePage {
  GeoJsonExamplePage() : super(const Icon(Icons.place), 'Geo Json source');

  @override
  Widget build(BuildContext context) {
    return GeoJsonSourceExample();
  }
}

class GeoJsonSourceExample extends StatefulWidget {
  const GeoJsonSourceExample();

  @override
  State createState() => GeoJsonSourceExampleState();
}

class GeoJsonSourceExampleState extends State<GeoJsonSourceExample> {

  late MapboxMapController _mapController;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    try {
      await _mapController.addGeoJsonSource('test', FeatureCollection(features: [
        Feature(
          geometry: PointGeometry(
            coordinates: LatLng(37.75787368720645, -122.45176792144774),
          ),
          properties: {
            'id': '9760fb9f-53f9-4de2-b301-377d3259198b',
          }
        ),
        Feature(
          geometry: PointGeometry(
            coordinates: LatLng(37.75186799197793, -122.44288444519043),
          ),
          properties: {
            'id': 'a7a22035-7257-4a4d-98d8-a398441ffacd',
          },
        ),
      ]),{});

      await _mapController.addLineLayer(LineLayer(
        id: 'terrain-data-lines',
        source: 'test',
        options: LineLayerOptions(
          lineJoin: ConstantLayerProperty(LineJoin.Round),
          lineCap: ConstantLayerProperty(LineCap.Round),
          lineColor: ConstantLayerProperty(Color(0x00ff69b4)),
          lineWidth: ConstantLayerProperty(1),
        )
      ), tapable: false);

      await _mapController.addSymbolLayer(SymbolLayer(
        id: 'terrain-data-symbols',
        source: 'test',
          options: SymbolLayerOptions(
            textSize: const ConstantLayerProperty(30.0),
            textField: 'X',
          ),
      ), tapable: true);

    } catch(_) {}

  }

  void _onStyleLoadedCallback() {
    print('onStyleLoadedCallback');
  }

  void _onLayerTap(String layerId, Point<double> point, LatLng coordinates, Map<String, dynamic> data) {
        int a =1;
      }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
          children: [
            MapboxMap(
              accessToken: MapsDemo.ACCESS_TOKEN,
              styleString: "mapbox://styles/mapbox/light-v10",
              trackCameraPosition: true,
              onMapCreated: _onMapCreated,
              onLayerTap: _onLayerTap,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.753574, -122.447303),
                zoom: 13,
              ),
            ),
          ]
      ),
    );
  }


}

