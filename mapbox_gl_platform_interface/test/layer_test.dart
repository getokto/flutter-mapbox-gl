import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  test('Serialize to Json', () {

    final symbolLayer = SymbolLayer(
      id: 'points',
      source: 'point',
      options: SymbolLayerOptions(
        iconImage: ConstantLayerProperty('cat'),
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

  test('Deserialize from Json', () {

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
        iconImage: ConstantLayerProperty('cat'),
        iconSize: ConstantLayerProperty(0.25),
      )
    )));

  });
}
