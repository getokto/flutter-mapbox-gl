
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

const randomMarkerNum = 100;

class VectorSourceExamplePage extends ExamplePage {
  VectorSourceExamplePage() : super(const Icon(Icons.place), 'Vector source');

  @override
  Widget build(BuildContext context) {
    return VectorSourceExample();
  }
}

class VectorSourceExample extends StatefulWidget {
  const VectorSourceExample();

  @override
  State createState() => VectorSourceExampleState();
}

class VectorSourceExampleState extends State<VectorSourceExample> {

  late MapboxMapController _mapController;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
  }

  Future<void> _onStyleLoadedCallback() async {
    await addImageFromAsset("assett-image", "assets/symbols/custom-icon.png");

      await _mapController.addVectorSource('test', VectorSource(
        minZoom: 6,
        maxZoom: 14,
        // url: Uri.parse('https://gist.githubusercontent.com/bjartebore/1475e190114df1479ffdcba073892ce4/raw/25d88f9cafd888d1861735bcf5895bff2f81d245/tile.json'),
        tiles: [
          Uri.parse('https://oktoservices.azurewebsites.net/v1/GeneratePoints/mapbox/helleu/{z}/{x}/{y}.mvt'),
        ]
      ).toMap());


    await _mapController.addSymbolLayer(SymbolLayer(
      id: 'agp',
      // sourceLayer: "pointsOfInterest",
      sourceLayer: "agp",
      source: 'test',
        options: SymbolLayerOptions(
          iconImage: ImageLayerProperty('assett-image'),
          iconColor: ConstantLayerProperty(Colors.blue),
        ),
    ), tappable: true);


    //   await _mapController.addVectorSource('test2', VectorSource(
    //     minZoom: 6,
    //     maxZoom: 14,
    //     // url: Uri.parse('https://gist.githubusercontent.com/bjartebore/1475e190114df1479ffdcba073892ce4/raw/25d88f9cafd888d1861735bcf5895bff2f81d245/tile.json'),
    //     tiles: [
    //       Uri.parse('https://oktoservices.azurewebsites.net/v1/VectorTiles/{z}/{x}/{y}.mvt'),
    //     ]
    //   ).toMap());


    // await _mapController.addSymbolLayer(SymbolLayer(
    //   id: 'terrain-data-symbols2',
    //   sourceLayer: "pointsOfInterest",
    //   // sourceLayer: "agp",
    //   source: 'test2',
    //     options: SymbolLayerOptions(
    //       iconImage: ImageLayerProperty('assett-image'),
    //       iconColor: ConstantLayerProperty(Colors.red),
    //     ),
    // ), tappable: true);



    _mapController.streamVisibleFeatures('agp').listen(_handleDataStream);
  }

  void _handleDataStream (List<FeatureBase> event) {
    print(event.length);
    int a = 1;
  }
  Future<void> addImageFromAsset(String name, String assetName) async {


    ImageConfiguration configuration = ImageConfiguration(
      devicePixelRatio: window.devicePixelRatio,
      platform: defaultTargetPlatform,
    );
    AssetImage assetImage = AssetImage(assetName);

    final imageKey = await assetImage.obtainKey(configuration);


    final ByteData bytes = await rootBundle.load(assetName);
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
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: const CameraPosition(
                target: LatLng(58.9361559, 5.8019575),
                zoom: 11,
              ),
            ),
          ]
      ),
    );
  }

}

