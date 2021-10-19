import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart' hide Visibility;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart' as mb;
import 'package:test/test.dart';

void main() {

  test('Simple serialize LineLayer to Json', () {
    final lineLayer = LineLayer(
       id: 'terrain-data',
        source: 'mapbox-terrain',
        sourceLayer: 'contour',
        options: LineLayerOptions(
          lineJoin: ConstantLayerProperty(LineJoin.Round),
          lineCap: ConstantLayerProperty(LineCap.Round),
          lineColor: ConstantLayerProperty(Color(0x00ff69b4)),
          lineWidth: ConstantLayerProperty(1),
        )
    );

    final layer = lineLayer.toMap();

    expect(layer, equals({
      "id": "terrain-data",
      "type": "symbol",
      "source": "mapbox-terrain",
      "source-layer": "contour",
      "layout": {
        "line-cap": "round",
        "line-join": "round"
      },
      "paint": {
        "line-color": "#ff69b4",
        "line-width": 1
      }
    }));

  });

  test('Simple deserialize LineLayer to Json', () {

    final json = {
      "id": "terrain-data",
      "type": "symbol",
      "source": "mapbox-terrain",
      "source-layer": "contour",
      "layout": {
        "line-cap": "round",
        "line-join": "round"
      },
      "paint": {
        "line-color": "#ff69b4",
        "line-width": 1
      }
    };


    final layer = LineLayer.fromMap(json);

    expect(layer, equals(LineLayer(
      id: 'terrain-data',
      source: 'mapbox-terrain',
      sourceLayer: 'contour',
      options: LineLayerOptions(
        lineJoin: ConstantLayerProperty(LineJoin.Round),
        lineCap: ConstantLayerProperty(LineCap.Round),
        lineColor: ConstantLayerProperty(Color(0xffff69b4)),
        lineWidth: ConstantLayerProperty(1),
      )
    )));
  });

  test('Simple serialize SymbolLayer to Json', () {
    final symbolLayer = SymbolLayer(
      id: 'points',
      source: 'point',
      options: SymbolLayerOptions(
        iconImage: 'cat',
        iconSize: ConstantLayerProperty(0.25),
      )
    );

    final layer = symbolLayer.toMap();

    expect(layer, equals({
      'id': 'points',
      'type': 'symbol',
      'source': 'point', // reference the data source
      'layout': {
        'icon-image': 'cat', // reference the image
        'icon-size': 0.25
      }
    }));

  });

  test('Simple deserialize SymbolLayer from Json', () {

    final json = {
      'id': 'points',
      'type': 'symbol',
      'source': 'point', // reference the data source
      'layout': {
        'icon-image': 'cat', // reference the image
        'icon-size': 0.25
      }
    };


    final layer = SymbolLayer.fromMap(json);

    expect(layer, equals(SymbolLayer(
      id: 'points',
      source: 'point',
      options: SymbolLayerOptions(
        iconImage: 'cat',
        iconSize: ConstantLayerProperty(0.25),
      )
    )));
  });


  test('Full serialize SymbolLayer to Json', () {
    final symbolLayer = SymbolLayer(
      id: 'points',
      source: 'point',
      options: SymbolLayerOptions(
        iconAllowOverlap: true,
        iconAnchor: Anchor.Bottom,
        iconColor: ConstantLayerProperty(Colors.red),
        iconHaloBlur: ConstantLayerProperty(0.5),
        iconHaloColor: ConstantLayerProperty(Colors.blue),
        iconHaloWidth: ConstantLayerProperty(1),
        iconIgnorePlacement: true,
        iconImage: "cat",
        iconKeepUpright: true,
        iconOffset: ConstantLayerProperty(Offset(-12, -12)),
        iconOpacity: ConstantLayerProperty(1),
        iconOptional: true,
        iconPadding: ConstantLayerProperty(16),
        iconPitchAlignment: MapAligment.Map,
        iconRotate: ConstantLayerProperty(45),
        iconRotationAlignment: MapAligment.Map,
        iconSize: ConstantLayerProperty(24),
        iconTextFit: MapFit.Height,
        iconTextFitPadding: ConstantLayerProperty(EdgeInsets.all(16)),
        iconTranslate: ConstantLayerProperty(Offset(12,12)),
        iconTranslateAnchor: AnchorAligment.Map,
        symbolAvoidEdges: true,
        symbolPlacement: SymbolPlacement.Line,
        symbolSortKey: 1,
        symbolSpacing: ConstantLayerProperty(1),
        symbolZOrder: ZOrder.Source,
        textAllowOverlap: true,
        textAnchor: Anchor.Center,
        textColor: ConstantLayerProperty(Colors.green),
        textField: 'Hola',
        textFont: ['Arial'],
        textHaloBlur: ConstantLayerProperty(0.2),
        textHaloColor: ConstantLayerProperty(Colors.blue),
        textHaloWidth: ConstantLayerProperty(1),
        textIgnorePlacement: false,
        textJustify: Justify.Center,
        textKeepUpright: true,
        textLetterSpacing: ConstantLayerProperty(1),
        textLineHeight: ConstantLayerProperty(1.4),
        textMaxAngle: ConstantLayerProperty(45),
        textMaxWidth: ConstantLayerProperty(10),
        textOffset: ConstantLayerProperty(Offset(0, 0)),
        textOpacity: ConstantLayerProperty(1),
        textOptional: true,
        textPadding: ConstantLayerProperty(4),
        textPitchAlignment: MapAligment.Map,
        textRadialOffset: ConstantLayerProperty(1),
        textRotate: ConstantLayerProperty(0),
        textRotationAlignment: MapAligment.Map,
        textSize: ConstantLayerProperty(13),
        textTransform: TextTransform.None,
        textTranslate: ConstantLayerProperty(Offset(0,0)),
        textTranslateAnchor: AnchorAligment.Map,
        textVariableAnchor: Anchor.Center,
        textWritingMode: TextWritingMode.Horizontal,
        visibility: mb.Visibility.None,
      )
    );

    final layer = symbolLayer.toMap();

    expect(layer, equals({
      "id": "points",
      "type": "symbol",
      "source": "point",
      "layout": {
        "icon-allow-overlap": true,
        "icon-anchor": "bottom",
        "icon-ignore-placement": true,
        "icon-image": "cat",
        "icon-keep-upright": true,
        "icon-offset": [
          -12,
          -12
        ],
        "icon-optional": true,
        "icon-padding": 16,
        "icon-pitch-alignment": "map",
        "icon-rotate": 45,
        "icon-rotation-alignment": "map",
        "icon-size": 24,
        "icon-text-fit": "height",
        "icon-text-fit-padding": [
          16,
          16,
          16,
          16,
        ],
        "symbol-avoid-edges": true,
        "symbol-placement": "line",
        "symbol-sort-key": 1,
        "symbol-spacing": 1,
        "symbol-z-order": "source",
        "text-allow-overlap": true,
        "text-anchor": "center",
        "text-field": "Hola",
        "text-font": [
          "Arial"
        ],
        "text-ignore-placement": false,
        "text-justify": "center",
        "text-keep-upright": true,
        "text-letter-spacing": 1,
        "text-line-height": 1.4,
        "text-max-angle": 45,
        "text-max-width": 10,
        "text-offset": [
          0,
          0,
        ],
        "text-optional": true,
        "text-padding": 4,
        "text-pitch-alignment": "map",
        "text-radial-offset": 1,
        "text-rotate": 0,
        "text-rotation-alignment": "map",
        "text-size": 13,
        "text-transform": "none",
        "text-variable-anchor": "center",
        "text-writing-mode": "horizontal",
        "visibility": "none"
      },
      "paint": {
        "icon-color": "#f44336",
        "icon-halo-blur": 0.5,
        "icon-halo-color": "#2196f3",
        "icon-halo-width": 1,
        "icon-opacity": 1,
        "icon-translate": [
          12,
          12,
        ],
        "icon-translate-anchor": "map",
        "text-color": "#4caf50",
        "text-halo-blur": 0.2,
        "text-halo-color": "#2196f3",
        "text-halo-width": 1,
        "text-opacity": 1,
        "text-translate": [0, 0],
        "text-translate-anchor": "map",
      }
    }));



  });


  test('Full deserialize SymbolLayer from Json', () {

    final json = {
      "id": "points",
      "type": "symbol",
      "source": "point",
      "layout": {
        "icon-allow-overlap": true,
        "icon-anchor": "bottom",
        "icon-ignore-placement": true,
        "icon-image": "cat",
        "icon-keep-upright": true,
        "icon-offset": [
          -12,
          -12
        ],
        "icon-optional": true,
        "icon-padding": 16,
        "icon-pitch-alignment": "map",
        "icon-rotate": 45,
        "icon-rotation-alignment": "map",
        "icon-size": 24,
        "icon-text-fit": "height",
        "icon-text-fit-padding": [
          16,
          16,
          16,
          16,
        ],
        "symbol-avoid-edges": true,
        "symbol-placement": "line",
        "symbol-sort-key": 1,
        "symbol-spacing": 1,
        "symbol-z-order": "source",
        "text-allow-overlap": true,
        "text-anchor": "center",
        "text-field": "Hola",
        "text-font": [
          "Arial"
        ],
        "text-ignore-placement": false,
        "text-justify": "center",
        "text-keep-upright": true,
        "text-letter-spacing": 1,
        "text-line-height": 1.4,
        "text-max-angle": 45,
        "text-max-width": 10,
        "text-offset": [
          0,
          0,
        ],
        "text-optional": true,
        "text-padding": 4,
        "text-pitch-alignment": "map",
        "text-radial-offset": 1,
        "text-rotate": 0,
        "text-rotation-alignment": "map",
        "text-size": 13,
        "text-transform": "none",
        "text-variable-anchor": "center",
        "text-writing-mode": "horizontal",
        "visibility": "none"
      },
      "paint": {
        "icon-color": "#f44336",
        "icon-halo-blur": 0.5,
        "icon-halo-color": "#2196f3",
        "icon-halo-width": 1,
        "icon-opacity": 1,
        "icon-translate": [
          12,
          12,
        ],
        "icon-translate-anchor": "map",
        "text-color": "#4caf50",
        "text-halo-blur": 0.2,
        "text-halo-color": "#2196f3",
        "text-halo-width": 1,
        "text-opacity": 1,
        "text-translate": [0, 0],
        "text-translate-anchor": "map",
      }
    };


    final layer = SymbolLayer.fromMap(json);
    final shouldEqual = SymbolLayer(
      id: 'points',
      source: 'point',
      options: SymbolLayerOptions(
        iconAllowOverlap: true,
        iconAnchor: Anchor.Bottom,
        iconColor: ConstantLayerProperty(Colors.red.shade500),
        iconHaloBlur: ConstantLayerProperty(0.5),
        iconHaloColor: ConstantLayerProperty(Colors.blue.shade500),
        iconHaloWidth: ConstantLayerProperty(1),
        iconIgnorePlacement: true,
        iconImage: "cat",
        iconKeepUpright: true,
        iconOffset: ConstantLayerProperty(Offset(-12, -12)),
        iconOpacity: ConstantLayerProperty(1),
        iconOptional: true,
        iconPadding: ConstantLayerProperty(16),
        iconPitchAlignment: MapAligment.Map,
        iconRotate: ConstantLayerProperty(45),
        iconRotationAlignment: MapAligment.Map,
        iconSize: ConstantLayerProperty(24),
        iconTextFit: MapFit.Height,
        iconTextFitPadding: ConstantLayerProperty(EdgeInsets.all(16)),
        iconTranslate: ConstantLayerProperty(Offset(12,12)),
        iconTranslateAnchor: AnchorAligment.Map,
        symbolAvoidEdges: true,
        symbolPlacement: SymbolPlacement.Line,
        symbolSortKey: 1,
        symbolSpacing: ConstantLayerProperty(1),
        symbolZOrder: ZOrder.Source,
        textAllowOverlap: true,
        textAnchor: Anchor.Center,
        textColor: ConstantLayerProperty(Colors.green.shade500),
        textField: 'Hola',
        textFont: ['Arial'],
        textHaloBlur: ConstantLayerProperty(0.2),
        textHaloColor: ConstantLayerProperty(Colors.blue.shade500),
        textHaloWidth: ConstantLayerProperty(1),
        textIgnorePlacement: false,
        textJustify: Justify.Center,
        textKeepUpright: true,
        textLetterSpacing: ConstantLayerProperty(1),
        textLineHeight: ConstantLayerProperty(1.4),
        textMaxAngle: ConstantLayerProperty(45),
        textMaxWidth: ConstantLayerProperty(10),
        textOffset: ConstantLayerProperty(Offset(0, 0)),
        textOpacity: ConstantLayerProperty(1),
        textOptional: true,
        textPadding: ConstantLayerProperty(4),
        textPitchAlignment: MapAligment.Map,
        textRadialOffset: ConstantLayerProperty(1),
        textRotate: ConstantLayerProperty(0),
        textRotationAlignment: MapAligment.Map,
        textSize: ConstantLayerProperty(13),
        textTransform: TextTransform.None,
        textTranslate: ConstantLayerProperty(Offset(0,0)),
        textTranslateAnchor: AnchorAligment.Map,
        textVariableAnchor: Anchor.Center,
        textWritingMode: TextWritingMode.Horizontal,
        visibility: mb.Visibility.None,
      )
    );

    expect(layer, equals( shouldEqual));
  });
}
