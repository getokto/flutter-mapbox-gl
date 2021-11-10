import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  Future<void> _onStyleLoadedCallback() async {

    await addImageFromAsset("assett-image", "assets/symbols/custom-icon.png");

    await _mapController.addGeoJsonSource('test', FeatureCollection(features: [
      Feature(
        geometry: PointGeometry(
          coordinates: LatLng(37.75787368720645, -122.45176792144774),
        ),
        properties: {
          'id': '9760fb9f-53f9-4de2-b301-377d3259198b',
          'color': '#00FF00',
        }
      ),
      Feature(
        geometry: PointGeometry(
          coordinates: LatLng(37.75186799197793, -122.44288444519043),
        ),
        properties: {
          'id': 'a7a22035-7257-4a4d-98d8-a398441ffacd',
          'color': '#FF0000',
        },
      ),
    ]),{});

    await _mapController.addSymbolLayer(SymbolLayer(
      id: 'terrain-data-symbols',
      source: 'test',
        options: SymbolLayerOptions(
          iconImage: ImageLayerProperty('assett-image'),
          iconColor: RawLayerProperty(["get", "color"]),
        ),
    ), tappable: true);


    // await _mapController.addSymbolLayer(SymbolLayer(
    //   id: 'terrain-data-symbols2',
    //   source: 'test',
    //     options: SymbolLayerOptions(
    //       textSize: const ConstantLayerProperty(30.0),
    //       textField: 'X',
    //       textColor: RawLayerProperty(["get", "color"])
    //     ),
    // ), tappable: true);
  }

  void _onLayerTap(String layerId, Point<double> point, LatLng coordinates, Map<String, dynamic> data) {

    _mapController.setSymbolLayerProperties('terrain-data-symbols', SymbolLayerOptions(
      textColor: RawLayerProperty([
        "case",
          ['==', ['get', 'id'], data['id']],
          'green',
          ["get", "color"],
      ])
    ));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {


    ImageConfiguration configuration = ImageConfiguration(
      devicePixelRatio: window.devicePixelRatio,
      platform: defaultTargetPlatform,
    );
    AssetImage assetImage = AssetImage(assetName);

    final imageKey = await assetImage.obtainKey(configuration);


    final ByteData bytes = await rootBundle.load(imageKey.name);
    final Uint8List list = bytes.buffer.asUint8List();

    await _mapController.addImage(name, list, true);
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

