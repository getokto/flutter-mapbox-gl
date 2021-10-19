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

class PointGeometry extends Geometry {
  const PointGeometry({
    required LatLng coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.Point,
    );
}

class LineStringGeometry extends Geometry {
  const LineStringGeometry({
    required List<LatLng> coordinates,
  }):
    super(
      coordinates: coordinates,
      type: _GeometryType.LineString,
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

  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    'coordinates': coordinates.map((e) => e.map((e) => e.toJson().reversed.toList()).toList()).toList(),
  };
}

class MultiPointGeometry extends Geometry<List<LatLng>> {
  const MultiPointGeometry({
    required List<LatLng> coordinates,
  }):
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiPoint,
    );

  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    'coordinates': coordinates.map((e) => e.toJson().reversed.toList()).toList(),
  };
}

class MultiLineStringGeometry extends Geometry {
  const MultiLineStringGeometry({
    required List<List<LatLng>> coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiLineString,
    );
}

class MultiPolygonGeometry extends Geometry {
  const MultiPolygonGeometry({
    required List<List<List<LatLng>>> coordinates,
  }) :
    super(
      coordinates: coordinates,
      type: _GeometryType.MultiPolygon,
    );


}

abstract class Geometry<T> {
  final _GeometryType type;
  final T coordinates;
  const Geometry({
    required this.type,
    required this.coordinates,
  });

  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    'coordinates': coordinates,
  };
}


abstract class FeatureBase {
  BBox? get bbox;
  Map<String, dynamic> toMap();
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

  Map<String, dynamic> toMap() => {
    'type': 'Feature',
    if (bbox != null)'bbox': bbox!.toArray(),
    'geometry': geometry.toMap(),
    if (properties != null) 'properties': properties,
  };
}

class FeatureCollection implements FeatureBase {
  FeatureCollection({
    required this.features,
    this.bbox,
  });

  final BBox? bbox;
  final List<Feature> features;

  Map<String, dynamic> toMap() {
    return {
      'type': 'FeatureCollection',
      if (bbox != null)'bbox': bbox!.toArray(),
      'features': features.map((e) => e.toMap()).toList(),
    };
  }
}
