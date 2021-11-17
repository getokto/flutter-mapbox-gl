// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl_example/custom_marker.dart';
import 'package:mapbox_gl_example/full_map.dart';
import 'package:mapbox_gl_example/geojson_source.dart';
import 'package:mapbox_gl_example/offline_regions.dart';
import 'package:mapbox_gl_example/place_batch.dart';
import 'package:mapbox_gl_example/vector_source_mvt.dart';

import 'animate_camera.dart';
import 'annotation_order_maps.dart';
import 'full_map.dart';
import 'line.dart';
import 'local_style.dart';
import 'map_ui.dart';
import 'move_camera.dart';
import 'page.dart';
import 'place_circle.dart';
import 'place_source.dart';
import 'place_symbol.dart';
import 'place_fill.dart';
import 'scrolling_map.dart';
import 'vector_source.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  MapUiPage(),
  FullMapPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceSymbolPage(),
  PlaceSourcePage(),
  LinePage(),
  LocalStylePage(),
  PlaceCirclePage(),
  PlaceFillPage(),
  ScrollingMapPage(),
  OfflineRegionsPage(),
  AnnotationOrderPage(),
  CustomMarkerPage(),
  BatchAddPage(),
  VectorSourceExamplePage(),
  GeoJsonExamplePage(),
  VectorSourceMvtExamplePage(),
];

class MapsDemo extends StatelessWidget {
  //FIXME: Add your Mapbox access token here
  static const String ACCESS_TOKEN = "pk.eyJ1IjoiYmphcnRlYm9yZSIsImEiOiJja3VnaTV2N3QwcWh5MnVva21tNWJhZHZ5In0.MCrnbGAC3tKA1piTeqqrkw";

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
