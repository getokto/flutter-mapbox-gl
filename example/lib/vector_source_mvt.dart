import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

const randomMarkerNum = 100;

class VectorSourceMvtExamplePage extends ExamplePage {
  VectorSourceMvtExamplePage() : super(const Icon(Icons.place), 'Vector source mvt');

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

    //await addImageFromAsset("assett-image", "assets/symbols/custom-icon.png");

    await _mapController.addVectorSource('okto-v1', VectorSource(
      minZoom: 0,
      maxZoom: 22,
      // tiles: [
      //   // Uri.parse("https://api.mapbox.com/v4/mapbox.mapbox-streets-v8,mapbox.mapbox-terrain-v2/{z}/{x}/{y}.mvt?sku=1015sf5zIC7Hi&access_token=pk.eyJ1IjoiYmphcnRlYm9yZSIsImEiOiJja3VnaTV2N3QwcWh5MnVva21tNWJhZHZ5In0.MCrnbGAC3tKA1piTeqqrkw"),
      //   // Uri.parse('https://oktoservices.azurewebsites.net/v1/GeneratePoints/mapbox/helleu/{z}/{x}/{y}.mvt'),
      //   Uri.parse("https://tiles.mapillary.com/maps/vtp/mly1_public/2/{z}/{x}/{y}?access_token=MLY|4142433049200173|72206abe5035850d6743b23a49c41333")
      // ],
      url: Uri.parse('https://gist.githubusercontent.com/bjartebore/1475e190114df1479ffdcba073892ce4/raw/6fab1e4688192c59e94adcf4f34658b7aa089dd4/tile.json'),
    ).toMap());

    // await _mapController.addLineLayer(LineLayer(
    //   id: 'mapillary',
    //   sourceLayer: "Generated_Points",
    //   source: 'oktopoints',
    //     options: LineLayerOptions(
    //       // iconImage: ImageLayerProperty('assett-image'),
    //       // iconColor: RawLayerProperty(["get", "color"]),
    //       lineCap: ConstantLayerProperty(LineCap.Round),
    //       lineJoin: ConstantLayerProperty(LineJoin.Round),
    //       lineColor: ConstantLayerProperty(Colors.red),
    //       lineWidth: ConstantLayerProperty(2.0),
    //     ),
    // ), tappable: true);


    await _mapController.addSymbolLayer(SymbolLayer(
      id: 'oktopoints',
      sourceLayer: "pointsOfInterest",
      source: 'okto-v1',
        options: SymbolLayerOptions(
          textField: 'hola',
          textColor: ConstantLayerProperty(Colors.red),
          // iconImage: ImageLayerProperty('assett-image'),
          // iconColor: RawLayerProperty(["get", "color"]),
          // lineCap: ConstantLayerProperty(LineCap.Round),
          // lineJoin: ConstantLayerProperty(LineJoin.Round),
          // lineColor: ConstantLayerProperty(Colors.red),
          // lineWidth: ConstantLayerProperty(2.0),
        ),
    ), tappable: true);

    _mapController.featureDataStream('okto-v1',
      sourceLayers: ["pointsOfInterest"],
    ).listen(_handleDataStream);
  }

  void _handleDataStream (event) {
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


    final ByteData bytes = await rootBundle.load(imageKey.name);
    final Uint8List list = bytes.buffer.asUint8List();

    await _mapController.addImage(name, list, false);
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
                target: LatLng(58.963186, 5.7468822),
                zoom: 14,
              ),
            ),
          ]
      ),
    );
  }

}

