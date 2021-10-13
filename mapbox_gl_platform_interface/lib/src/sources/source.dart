part of mapbox_gl_platform_interface;
// import 'dart:ui';

// import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
// import 'package:mapbox_gl_platform_interface/src/layers/symbol_layer.dart';



class SourceType implements EnumLike {
  const SourceType._(this.value);
  final int value;

  static const Vector = SourceType._(0);
  static const Raster = SourceType._(1);
  static const RasterDem = SourceType._(2);
  static const GeoJson = SourceType._(3);
  static const Image = SourceType._(4);
  static const Video = SourceType._(5);

  @override
  String toString() {
    switch (this) {
      case Vector:
        return 'vector';
      case Raster:
        return 'raster';
      case RasterDem:
        return 'raster-dem';
      case GeoJson:
        return 'geo-json';
      case Image:
        return 'image';
      case Video:
        return 'video';
    }
    throw Error();
  }

  static SourceType? fromString(String? str) {
    switch (str) {
      case 'vector':
        return Vector;
      case 'raster':
        return Raster;
      case 'raster-dem':
        return RasterDem;
      case 'geo-json':
        return GeoJson;
      case 'image':
        return Image;
      case 'video':
        return Video;
    }
  }
}

class Scheme implements EnumLike {
  const Scheme._(this.value);
  final int value;

  static const XYZ = Scheme._(0);
  static const TMS = Scheme._(1);

  @override
  String toString() {
    switch (this) {
      case XYZ:
        return 'xyz';
      case TMS:
        return 'tms';
    }
    throw Error();
  }

  static Scheme? fromString(String? str) {
    switch (str) {
      case 'xyz':
        return XYZ;
      case 'tms':
        return TMS;
    }
  }
}

class BBox {
  const BBox(this.sw, this.ne);
  final LatLng sw;
  final LatLng ne;

  List<double> toArray() => [
    sw.longitude,
    sw.latitude,
    ne.longitude,
    ne.latitude,
  ];

  static BBox fromArray(List<double> arr) {
    assert(arr.length == 4);

    return BBox(
      LatLng(arr[0], arr[1]),
      LatLng(arr[2], arr[3]),
    );
  }
}

abstract class Source {
  Map<String, dynamic> toMap();

  static fromMap(Map<String, dynamic> map) {
    final type = SourceType.fromString(map['type']);

    switch(type) {
      case SourceType.Vector:
        return VectorSource.fromMap(map);
      case SourceType.GeoJson:
        return GeoJsonSource.fromMap(map);
      default:
        throw UnimplementedError();
    }
  }
}

class VectorSource implements Source {
  VectorSource({
    this.attribution,
    this.bounds,
    this.maxZoom,
    this.minZoom,
    this.promoteId,
    this.scheme,
    this.tiles,
    this.url,
  });
  final SourceType type = SourceType.Vector;
  final String? attribution;
  final BBox? bounds;
  final double? maxZoom;
  final double? minZoom;
  final String? promoteId;
  final Scheme? scheme;
  final List<Uri>? tiles;
  final Uri? url;

  @override
  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    if(attribution != null) 'attribution': attribution,
    if(bounds != null) 'bounds': bounds?.toArray(),
    if(maxZoom != null) 'maxZoom': maxZoom,
    if(minZoom != null) 'minZoom': minZoom,
    if(promoteId != null) 'promoteId': promoteId,
    if(scheme != null) 'scheme': scheme?.toString(),
    if(tiles != null) 'tiles': tiles?.map((e) => e.toString()).toList(),
    if(url != null) 'url': url?.toString(),
  };

  static VectorSource fromMap(Map<String, dynamic> map) {
    return VectorSource(
      attribution: map['attribution'] as String?,
      bounds: _tryParseBBox(map['bounds'] as List<double>?),
      maxZoom: map['maxZoom'] as double?,
      minZoom: map['minZoom'] as double?,
      promoteId: map['promoteId'] as String?,
      scheme: Scheme.fromString(map['scheme'] as String?),
      tiles: _tryParseUris(map['tiles'] as List<String>?),
      url: Uri.tryParse(map['url'] as String? ?? ','),
    );
  }

  static List<Uri>? _tryParseUris(List<String>? uris) {
    return uris?.map((e) => Uri.parse(e)).toList();
  }

  static BBox? _tryParseBBox(List<double>? uris) {
    try {
      if (uris != null) {
        return BBox.fromArray(uris);
      }
      return null;
    } catch(_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is VectorSource && (
    other.attribution == attribution
      && other.bounds == bounds
      && other.maxZoom == maxZoom
      && other.minZoom == minZoom
      && other.promoteId == promoteId
      && other.scheme == scheme
      && other.tiles == tiles
      && other.url == url
    );
  }

  @override
  int get hashCode => hashValues(
    attribution,
    bounds,
    maxZoom,
    minZoom,
    promoteId,
    scheme,
    tiles,
    url,
  );
}


class GeoJsonSource implements Source {
  GeoJsonSource({
    this.attribution,
    this.buffer,
    this.cluster,
    this.clusterMaxZoom,
    this.clusterMinPoints,
    this.clusterProperties,
    this.clusterRadius,
    this.data,
    this.filter,
    this.generateId,
    this.lineMetrics,
    this.maxZoom,
    this.promoteId,
    this.tolerance,
  });
  final SourceType type = SourceType.GeoJson;
  final String? attribution;
  final double? buffer;
  final bool? cluster;
  final double? clusterMaxZoom;
  final double? clusterMinPoints;
  final Map<String, dynamic>? clusterProperties;
  final double? clusterRadius;
  final String? data;
  final dynamic filter;
  final bool? generateId;
  final bool? lineMetrics;
  final double? maxZoom;
  final String? promoteId;
  final double? tolerance;

  @override
  Map<String, dynamic> toMap() => {
    'type': type.toString(),
    if (attribution != null) 'attribution': attribution,
    if (buffer != null) 'buffer': buffer,
    if (cluster != null) 'cluster': cluster,
    if (clusterMaxZoom != null) 'clusterMaxZoom': clusterMaxZoom,
    if (clusterMinPoints != null) 'clusterMinPoints': clusterMinPoints,
    if (clusterProperties != null) 'clusterProperties': clusterProperties,
    if (clusterRadius != null) 'clusterRadius': clusterRadius,
    if (data != null) 'data': data,
    if (filter != null) 'filter': filter,
    if (generateId != null) 'generateId': generateId,
    if (lineMetrics != null) 'lineMetrics': lineMetrics,
    if (maxZoom != null) 'maxZoom': maxZoom,
    if (promoteId != null) 'promoteId': promoteId,
    if (tolerance != null) 'tolerance': tolerance,
  };

  static GeoJsonSource fromMap(Map<String, dynamic> map) {
    return GeoJsonSource(
      attribution: map['attribution'] as String?,
      buffer: map['buffer'] as double?,
      cluster: map['cluster'] as bool?,
      clusterMaxZoom: map['clusterMaxZoom'] as double?,
      clusterMinPoints: map['clusterMinPoints'] as double?,
      clusterProperties: map['clusterProperties'] as Map<String, dynamic>,
      clusterRadius: map['clusterRadius'] as double?,
      data: map['data'] as dynamic,
      filter: map['filter'] as dynamic,
      generateId: map['generateId'] as bool?,
      lineMetrics: map['lineMetrics'] as bool?,
      maxZoom: map['maxZoom'] as double?,
      promoteId: map['promoteId'] as String?,
      tolerance: map['tolerance'] as double,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeoJsonSource && (
    other.attribution == attribution
      && other.attribution == attribution
      && other.buffer == buffer
      && other.cluster == cluster
      && other.clusterMaxZoom == clusterMaxZoom
      && other.clusterMinPoints == clusterMinPoints
      && other.clusterProperties == clusterProperties
      && other.clusterRadius == clusterRadius
      && other.data == data
      && other.filter == filter
      && other.generateId == generateId
      && other.lineMetrics == lineMetrics
      && other.maxZoom == maxZoom
      && other.promoteId == promoteId
      && other.tolerance == tolerance
    );
  }

  @override
  int get hashCode => hashValues(
    attribution,
    buffer,
    cluster,
    clusterMaxZoom,
    clusterMinPoints,
    clusterProperties,
    clusterRadius,
    data,
    filter,
    generateId,
    lineMetrics,
    maxZoom,
    promoteId,
    tolerance,
  );

}


