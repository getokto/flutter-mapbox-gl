import 'package:flutter/material.dart';
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

      await _mapController.addVectorSource('mapbox-terrain', VectorSource(
        minZoom: 6,
        maxZoom: 14,
        url: Uri.parse('mapbox://mapbox.mapbox-terrain-v2'),
      ).toMap());

    await _mapController.addLineLayer(LineLayer(
      id: 'terrain-data',
      source: 'mapbox-terrain',
      sourceLayer: 'contour',
      options: LineLayerOptions(
        lineJoin: ConstantLayerProperty(LineJoin.Round),
        lineCap: ConstantLayerProperty(LineCap.Round),
        lineColor: ConstantLayerProperty(Color(0xFFff0000).withOpacity(0.5)),
        lineWidth: ConstantLayerProperty(1),
      )
    ), tappable: true);



    _mapController.featureDataStream('terrain-data').listen(_handleDataStream);
  }

  void _handleDataStream (event) {
    print(event.length);
    int a = 1;
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
                target: LatLng(37.753574, -122.447303),
                zoom: 13,
              ),
            ),
          ]
      ),
    );
  }

}

