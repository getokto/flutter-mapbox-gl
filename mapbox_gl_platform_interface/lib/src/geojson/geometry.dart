part of mapbox_gl_platform_interface;

class _GeometryType implements EnumLike {
  const _GeometryType._(this.value);
  final int value;

  static const Point = _GeometryType._(0);
  static const LineString = _GeometryType._(1);
  static const Polygon = _GeometryType._(2);
  static const MultiPoint = _GeometryType._(3);
  static const MultiLineString = _GeometryType._(4);
  static const MultiPolygon = _GeometryType._(5);

  static List<String> get all => [Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon].map((e) => e.toString()).toList();

  static _GeometryType? fromString(String? str) {
    switch (str) {
      case 'Point':
        return Point;
      case 'LineString':
        return LineString;
      case 'Polygon':
        return Polygon;
      case 'MultiPoint':
        return MultiPoint;
      case 'MultiLineString':
        return MultiLineString;
      case 'MultiPolygon':
        return MultiPolygon;
    }
    return null;
  }

  @override
  String toString() {
    switch (this) {
      case Point:
        return 'Point';
      case LineString:
        return 'LineString';
      case Polygon:
        return 'Polygon';
      case MultiPoint:
        return 'MultiPoint';
      case MultiLineString:
        return 'MultiLineString';
      case MultiPolygon:
        return 'MultiPolygon';
    }
    throw Error();
  }
}

class PointGeometry extends Geometry<LatLng> {
  const PointGeometry({
    required LatLng coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.Point,
    );

  static PointGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "Point") {
      throw Exception('map is not a PointGeometry');
    }

    List<double> coordinates = List.castFrom(map['coordinates']);

    return PointGeometry(coordinates: LatLng(coordinates[1], coordinates[0]));
  }

  dynamic serializeCoordinates(coordinates) {
    return [coordinates.longitude, coordinates.latitude];
  }

  @override
  bool operator ==(Object other) {
    return other is PointGeometry &&
        (other.type == type &&
          other.coordinates == coordinates);
  }

  @override
  int get hashCode => hashValues(
        type,
        coordinates,
      );
}

class LineStringGeometry extends Geometry<List<LatLng>> {
  const LineStringGeometry({
    required List<LatLng> coordinates,
  }):
    super(
      coordinates: coordinates,
      type: _GeometryType.LineString,
    );

  static LineStringGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "LineString") {
      throw Exception('map is not a LineStringGeometry');
    }

    List<List<double>> coordinates = List.castFrom(map['coordinates']);

    return LineStringGeometry(coordinates: coordinates.map((x) =>  LatLng(x[1], x[0])).toList());
  }


  dynamic serializeCoordinates(coordinates) {
    return coordinates.map(((e) => [e.longitude, e.latitude])).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is LineStringGeometry &&
        (other.type == type &&
          listEquals(other.coordinates, coordinates));
  }

  @override
  int get hashCode => hashValues(
        type,
        hashList(coordinates),
      );
}

class PolygonGeometry extends Geometry<List<List<LatLng>>> {
  const PolygonGeometry({
    required List<List<LatLng>> coordinates,
  }):
    super(
      coordinates: coordinates,
      type: _GeometryType.Polygon,
    );

  static PolygonGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "Polygon") {
      throw Exception('map is not a PolygonGeometry');
    }

    List<List<List<double>>> coordinates = List.castFrom(map['coordinates']);

    return PolygonGeometry(coordinates: coordinates.map((x) => x.map((x) => LatLng(x[1], x[0])).toList()).toList());
  }

  dynamic serializeCoordinates(coordinates) {
    return coordinates.map((e) => e.map((e) => [e.longitude, e.latitude]).toList()).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is PolygonGeometry &&
        (other.type == type &&
          listEquals(other.coordinates, coordinates));
  }

  @override
  int get hashCode => hashValues(
        type,
        hashList(coordinates),
      );
}

class MultiPointGeometry extends Geometry<List<LatLng>> {
  const MultiPointGeometry({
    required List<LatLng> coordinates,
  }):
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiPoint,
    );

  static MultiPointGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "MultiPoint") {
      throw Exception('map is not a MultiPointGeometry');
    }

    List<List<double>> coordinates = List.castFrom(map['coordinates']);

    return MultiPointGeometry(coordinates: coordinates.map((x) =>  LatLng(x[1], x[0])).toList());
  }

  dynamic serializeCoordinates(coordinates) {
    return coordinates.map(((e) => [e.longitude, e.latitude])).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is MultiPointGeometry &&
        (other.type == type &&
          listEquals(other.coordinates, coordinates));
  }

  @override
  int get hashCode => hashValues(
        type,
        hashList(coordinates),
      );

}

class MultiLineStringGeometry extends Geometry<List<List<LatLng>>> {
  const MultiLineStringGeometry({
    required List<List<LatLng>> coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiLineString,
    );


  static MultiLineStringGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "MultiLineString") {
      throw Exception('map is not a MultiLineStringGeometry');
    }

    List<List<List<double>>> coordinates = List.castFrom(map['coordinates']);

    return MultiLineStringGeometry(coordinates: coordinates.map((x) => x.map((x) => LatLng(x[1], x[0])).toList()).toList());
  }

  dynamic serializeCoordinates(coordinates) {
    return coordinates.map((e) => e.map((e) => [e.longitude, e.latitude]).toList()).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is MultiLineStringGeometry &&
        (other.type == type &&
          listEquals(other.coordinates, coordinates));
  }

  @override
  int get hashCode => hashValues(
        type,
        hashList(coordinates),
      );
}

class MultiPolygonGeometry extends Geometry<List<List<List<LatLng>>>> {
  const MultiPolygonGeometry({
    required List<List<List<LatLng>>> coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiPolygon,
    );

  static MultiPolygonGeometry fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "MultiPolygon") {
      throw Exception('map is not a MultiPolygonGeometry');
    }

    List<List<List<List<double>>>> coordinates = List.castFrom(map['coordinates']);

    return MultiPolygonGeometry(coordinates: coordinates.map((x) =>
      x.map((x) =>
        x.map((x) => LatLng(x[1], x[0])).toList()
      ).toList(),
    ).toList());
  }

  dynamic serializeCoordinates(coordinates) {
    return coordinates.map((e) => e.map((e) => e.map((e) => [e.longitude, e.latitude]).toList()).toList()).toList();
  }


  @override
  bool operator ==(Object other) {
    return other is MultiPolygonGeometry &&
        (other.type == type &&
          listEquals(other.coordinates, coordinates));
  }

  @override
  int get hashCode => hashValues(
        type,
        hashList(coordinates),
      );

}

abstract class Geometry<T> {
  final _GeometryType type;
  final T coordinates;
  const Geometry({
    required this.type,
    required this.coordinates,
  });

  dynamic serializeCoordinates(T coordinates);

  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    'coordinates': serializeCoordinates(coordinates),
  };


  static Geometry fromMap(Map<String, dynamic> map) {
    final type = _GeometryType.fromString(map['type']);

    if (type == null) {
      throw Exception('map is not a geometry');
    }

    switch (type) {
      case _GeometryType.Point:
        return PointGeometry.fromMap(map);
      case _GeometryType.LineString:
        return LineStringGeometry.fromMap(map);
      case _GeometryType.Polygon:
        return PolygonGeometry.fromMap(map);
      case _GeometryType.MultiPoint:
        return MultiPointGeometry.fromMap(map);
      case _GeometryType.MultiLineString:
        return MultiLineStringGeometry.fromMap(map);
      case _GeometryType.MultiPolygon:
        return MultiPolygonGeometry.fromMap(map);
    }

    throw UnsupportedError('Unsupported geometry type');
  }
}


abstract class FeatureBase {
  BBox? get bbox;
  Map<String, dynamic> toMap();


  static FeatureBase fromMap(Map<String, dynamic> map) {
    final type = map["type"] as String?;

    switch(type) {
      case "Feature":
        return Feature.fromMap(map);
      case "FeatureCollection":
        return FeatureCollection.fromMap(map);
      default:
        throw UnsupportedError('type: $type is unsupported');
    }

  }

}

class Feature implements FeatureBase {
  Feature({
    this.bbox,
    required this.geometry,
    this.properties,
  });

  final BBox? bbox;
  final Geometry geometry;
  final Map<String, dynamic>? properties;

  static Feature fromMap(Map<String, dynamic> map) {
    if (!map.containsKey("type") || map["type"] != "Feature") {
      throw Exception('map is not a Feature');
    }

    if (!map.containsKey("geometry")) {
      throw Exception('geometry map is required');
    }

    return Feature(
      geometry: Geometry.fromMap(Map.from(map['geometry'])),
      properties: Map.castFrom(map['properties']),
    );
  }


  Map<String, dynamic> toMap() => {
    'type': 'Feature',
    if (bbox != null)'bbox': bbox!.toArray(),
    'geometry': geometry.toMap(),
    if (properties != null) 'properties': properties,
  };


  @override
  bool operator ==(Object other) {
    return other is Feature &&
        (other.bbox == bbox &&
          other.geometry == geometry &&
          mapEquals(other.properties, properties)
        );
  }

  @override
  int get hashCode => hashValues(
        bbox,
        geometry,
        properties,
      );


}

class FeatureCollection implements FeatureBase {
  FeatureCollection({
    required this.features,
    this.bbox,
  });

  final BBox? bbox;
  final List<Feature> features;

  static FeatureCollection fromMap(Map<String, dynamic> map) {
    if (map.containsKey("type") && map["type"] != "FeatureCollection") {
      throw Exception('map is not a FeatureCollection');
    }


    if (!map.containsKey("features")) {
      throw Exception('features list is required');
    }

    return FeatureCollection(
      features: List.from(map['features'] ?? []).map((e) => Feature.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'FeatureCollection',
      if (bbox != null)'bbox': bbox!.toArray(),
      'features': features.map((e) => e.toMap()).toList(),
    };
  }


  @override
  bool operator ==(Object other) {
    return other is FeatureCollection &&
        (other.bbox == bbox &&
            listEquals(other.features, features));
  }

  @override
  int get hashCode => hashValues(
        bbox,
        hashList(features),
      );
}
