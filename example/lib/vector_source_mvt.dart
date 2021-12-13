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

    await addImageFromAsset("assett-image", "assets/symbols/custom-icon.png");

      await _mapController.addVectorSource('mapillary', VectorSource(
        minZoom: 6,
        maxZoom: 14,
        tiles: [
          // access_token is double encoded to ensure that it is not decoded
          Uri.parse('https://tiles.mapillary.com/maps/vtp/mly1_public/2/{z}/{x}/{y}?access_token=MLY%7C4142433049200173%7C72206abe5035850d6743b23a49c41333'),
        ]
      ).toMap());

    await _mapController.addLineLayer(LineLayer(
      id: 'mapillary',
      sourceLayer: 'sequence',
      source: 'mapillary',
      options: LineLayerOptions(
        lineJoin: ConstantLayerProperty(LineJoin.Round),
        lineCap: ConstantLayerProperty(LineCap.Round),
        lineColor: ConstantLayerProperty(Colors.lightGreen),
        lineWidth: ConstantLayerProperty(2.0),
      )
    ), tappable: false);



    await _mapController.addVectorSource('test', VectorSource(
      minZoom: 6,
      maxZoom: 14,
      tiles: [
        Uri.parse('https://oktoservices.azurewebsites.net/v1/GeneratePoints/mapbox/helleu/{z}/{x}/{y}.mvt'),
      ]
    ).toMap());

    await _mapController.addCircleLayer(CircleLayer(
      id: 'agp-circle',
      sourceLayer: "agp",
      source: 'test',
        options: CircleLayerOptions(
          circleColor: ConstantLayerProperty(Colors.red),
          circleRadius: ConstantLayerProperty(5),
        ),
    ), tappable: true);


    // await _mapController.addSymbolLayer(SymbolLayer(
    //   id: 'agp',
    //   sourceLayer: "agp",
    //   source: 'test',
    //     options: SymbolLayerOptions(
    //       iconImage: ImageLayerProperty('rocket-15'),
    //       iconColor: ConstantLayerProperty(Colors.blue),
    //     ),
    // ), tappable: true);


    _mapController.streamSourceFeaturesQuery('auto-points', sourceLayers: ['agp']).listen(_handleDataStream);
  }

  void _handleDataStream (event) {
    print(event.length);
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
              compassEnabled: false,
              scaleBarEnabled: false,
              trackCameraPosition: true,
              myLocationEnabled: false,
              myLocationTrackingMode: MyLocationTrackingMode.None,
              onMapCreated: _onMapCreated,
              onLayerTap: (sourceId, sourceLayerId, point, coordinates, data) {
                int a = 1;
              },
              minMaxZoomPreference: MinMaxPreference(14, 20),
              minMaxPitchPreference: MinMaxPreference(0, 45),
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.878781, -87.622088),
                pitch: 0,
                zoom: 14,
              ),
            ),
          ]
      ),
    );
  }

}

