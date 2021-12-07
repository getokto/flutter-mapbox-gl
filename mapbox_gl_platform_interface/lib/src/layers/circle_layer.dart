part of mapbox_gl_platform_interface;


class CircleLayer extends StyleLayer<StyleLayerOptions> {
  CircleLayer({
      required this.id,
      required this.source,
      this.sourceLayer,
      CircleLayerOptions? options,
    }
  ) : this.options = options != null ? options : CircleLayerOptions();

  /// A unique identifier for this fill.
  ///
  /// The identifier is an arbitrary unique string.
  final String id;

  /// The source from which to obtain the data to style.
  ///
  /// If the source has not yet been added to the current style, the behavior is undefined.
  final String source;

  final String? sourceLayer;

  final CircleLayerOptions options;

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': 'symbol',
    'source': source,
    'source-layer': sourceLayer,
    ...cleanMap(options.toMap()),
  };

  static CircleLayer fromMap(Map<String, dynamic> map) {
    return CircleLayer(
      id: map['id'],
      source: map['source'],
      sourceLayer: map['source-layer'],
      options: CircleLayerOptions.fromMap(<String, dynamic>{
        'layout': map['layout'],
        'paint': map['paint'],
      }),

    );
  }

  @override
  bool operator ==(Object other) {
    return other is CircleLayer && (
      other.id == id
      && other.source == source
      && other.sourceLayer == sourceLayer
      && other.options == options
    );
  }

  @override
  int get hashCode => hashValues(
    id,
    source,
    sourceLayer,
    options,
  );

}

class CircleLayerOptions extends StyleLayerOptions {
  CircleLayerOptions({
    this.circleBlur,
    this.circleColor,
    this.circleOpacity,
    this.circlePitchAlignment,
    this.circlePitchScale,
    this.circleRadius,
    this.circleSortKey,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.circleStrokeWidth,
    this.circleTranslate,
    this.circleTranslateAnchor,
    this.visibility = Visibility.Visible
  });

  /// Optional number. Defaults to 0
  final LayerProperty<double>? circleBlur;

  /// Optional color. Defaults to "#000000"
  final LayerProperty<Color>? circleColor;

  /// Optional number between 0 and 1 inclusive. Defaults to 1
  final LayerProperty<double>? circleOpacity;

  /// Optional enum. One of "map", "viewport" . Defaults to "viewport".
  final LayerProperty<AnchorAligment>? circlePitchAlignment;

  /// Optional enum. One of "map", "viewport". Defaults to "map".
  final LayerProperty<AnchorAligment>? circlePitchScale;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 5
  final LayerProperty<double>? circleRadius;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  final LayerProperty<int>? circleSortKey;

  /// Optional color. Defaults to "#000000"
  final LayerProperty<Color>? circleStrokeColor;

  /// Optional number between 0 and 1 inclusive. Defaults to 1.
  final LayerProperty<double>? circleStrokeOpacity;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 0
  final LayerProperty<double>? circleStrokeWidth;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0]
  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  final List<double>? circleTranslate;

  /// Optional enum. One of "map", "viewport". Defaults to "map". Requires circle-translate.
  final LayerProperty<AnchorAligment>? circleTranslateAnchor;

  /// Optional enum. One of "visible", "none". Defaults to "visible".
  final Visibility visibility;

  Map<String, dynamic> toMap() => {
    'layout': {
      if (circleSortKey != null) 'circle-sort-key': serializeValue(circleSortKey),
      'visibility': serializeValue(visibility),
    },
    'paint': {
      if (circleBlur != null) 'circle-blur': serializeValue(circleBlur),
      if (circleColor != null) 'circle-color': serializeValue(circleColor),
      if (circleOpacity != null) 'circle-opacity': serializeValue(circleOpacity),
      if (circlePitchAlignment != null) 'circle-pitch-alignment': serializeValue(circlePitchAlignment),
      if (circlePitchScale != null) 'circle-pitch-scale': serializeValue(circlePitchScale),
      if (circleRadius != null) 'circle-radius': serializeValue(circleRadius),
      if (circleStrokeColor != null) 'circle-stroke-color': serializeValue(circleStrokeColor),
      if (circleStrokeOpacity != null) 'circle-stroke-opacity': serializeValue(circleStrokeOpacity),
      if (circleStrokeWidth != null) 'circle-stroke-width': serializeValue(circleStrokeWidth),
      if (circleTranslate != null) 'circle-translate': serializeValue(circleTranslate),
      if (circleTranslateAnchor != null) 'circle-translate-anchor': serializeValue(circleTranslateAnchor),
    },
  };

  static fromMap(Map<String, dynamic> map) {
    return CircleLayerOptions(
      circleBlur: deserializeJson(map, 'paint', 'circle-blur'),
      circleColor: deserializeJson(map, 'paint', 'circle-color'),
      circleOpacity: deserializeJson(map, 'paint', 'circle-opacity'),
      circlePitchAlignment: deserializeJson(map, 'paint', 'circle-pitch-alignment'),
      circlePitchScale: deserializeJson(map, 'paint', 'circle-pitch-scale'),
      circleRadius: deserializeJson(map, 'paint', 'circle-radius'),
      circleSortKey: deserializeJson(map, 'layout', 'circle-sort-key'),
      circleStrokeColor: deserializeJson(map, 'paint', 'circle-stroke-color'),
      circleStrokeOpacity: deserializeJson(map, 'paint', 'circle-stroke-opacity'),
      circleStrokeWidth: deserializeJson(map, 'paint', 'circle-stroke-width'),
      circleTranslate: deserializeJson(map, 'paint', 'circle-translate'),
      circleTranslateAnchor: deserializeJson(map, 'paint', 'circle-translate-anchor'),
      visibility: deserializeJson(map,'layout', 'visibility'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CircleLayerOptions && (
      other.circleBlur == circleBlur
      && other.circleColor == circleColor
      && other.circleOpacity == circleOpacity
      && other.circlePitchAlignment == circlePitchAlignment
      && other.circlePitchScale == circlePitchScale
      && other.circleRadius == circleRadius
      && other.circleSortKey == circleSortKey
      && other.circleStrokeColor == circleStrokeColor
      && other.circleStrokeOpacity == circleStrokeOpacity
      && other.circleStrokeWidth == circleStrokeWidth
      && listEquals<double>(other.circleTranslate, circleTranslate)
      && other.circleTranslateAnchor == circleTranslateAnchor
      && other.visibility == visibility
    );
  }

  @override
  int get hashCode => hashValues(
    circleBlur,
    circleColor,
    circleOpacity,
    circlePitchAlignment,
    circlePitchScale,
    circleRadius,
    circleSortKey,
    circleStrokeColor,
    circleStrokeOpacity,
    circleStrokeWidth,
    hashList(circleTranslate),
    circleTranslateAnchor,
    visibility,
  );
}