part of mapbox_gl_platform_interface;


class LineLayer extends StyleLayer<StyleLayerOptions> {
  LineLayer({
      required this.id,
      required this.source,
      this.sourceLayer,
      LineLayerOptions? options,
    }
  ) : this.options = options != null ? options : LineLayerOptions();

  /// A unique identifier for this fill.
  ///
  /// The identifier is an arbitrary unique string.
  final String id;

  /// The source from which to obtain the data to style.
  ///
  /// If the source has not yet been added to the current style, the behavior is undefined.
  final String source;

  final String? sourceLayer;

  final LineLayerOptions options;

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': 'symbol',
    'source': source,
    'source-layer': sourceLayer,
    ...cleanMap(options.toMap()),
  };

  static LineLayer fromMap(Map<String, dynamic> map) {
    return LineLayer(
      id: map['id'],
      source: map['source'],
      sourceLayer: map['source-layer'],
      options: LineLayerOptions.fromMap(<String, dynamic>{
        'layout': map['layout'],
        'paint': map['paint'],
      }),

    );
  }

  @override
  bool operator ==(Object other) {
    return other is LineLayer && (
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

class LineLayerOptions extends StyleLayerOptions {
  LineLayerOptions({
    this.lineBlur,
    this.lineCap,
    this.lineColor,
    this.lineDasharray,
    this.lineGapWidth,
    this.lineGradient,
    this.lineJoin,
    this.lineMiterLimit,
    this.lineOffset,
    this.lineOpacity,
    this.linePattern,
    this.lineRoundLimit,
    this.lineSortKey,
    this.lineTranslate,
    this.lineTranslateAnchor,
    this.lineWidth,
    this.visibility,
  });


  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 0.
  final LayerProperty<double>? lineBlur;

  /// Optional enum. One of "butt", "round", "square". Defaults to "butt".
  final LayerProperty<LineCap>? lineCap;

  /// Optional color. Defaults to "#000000". Disabled by line-pattern.
  final LayerProperty<Color>? lineColor;

  /// Optional array of numbers greater than or equal to 0. Units in line widths.
  final LayerProperty<double>?  lineDasharray;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 0.
  final LayerProperty<double>? lineGapWidth;

  /// Optional color. Disabled by line-pattern. Requires source to be "geojson".
  final LayerProperty<Color>? lineGradient;

  /// Optional enum. One of "bevel", "round", "miter". Defaults to "miter".
  final LayerProperty<LineJoin>? lineJoin;

  /// Optional number. Defaults to 2. Requires line-join to be "miter".
  final LayerProperty<int>? lineMiterLimit;

  /// Optional number. Units in pixels. Defaults to 0
  final LayerProperty<int>? lineOffset;

  /// Optional number between 0 and 1 inclusive. Defaults to 1.
  final LayerProperty<double>? lineOpacity;

  /// Optional resolvedImage.
  final LayerProperty<String>? linePattern;

  /// Optional number. Defaults to 1.05. Requires line-join to be "round".
  final LayerProperty<double>? lineRoundLimit;

  /// Optional number.
  final LayerProperty<int>? lineSortKey;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0].
  final LayerProperty<Offset>? lineTranslate;

  /// Optional enum. One of "map", "viewport". Defaults to "map". Requires line-translate.
  final LayerProperty<AnchorAligment>? lineTranslateAnchor;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 1
  final LayerProperty<double>? lineWidth;

  /// Optional enum. One of "visible", "none". Defaults to "visible".
  final LayerProperty<Visibility>? visibility;

  Map<String, dynamic> toMap() => {
    'layout': {
      if (lineCap != null) 'line-cap': lineCap!.serialize(),
      if (lineJoin != null) 'line-join': lineJoin!.serialize(),
      if (lineMiterLimit != null) 'line-miter-limit': lineMiterLimit!.serialize(),
      if (lineRoundLimit != null) 'line-round-limit': lineRoundLimit!.serialize(),
      if (lineSortKey != null) 'line-sort-key': lineSortKey!.serialize(),
      if (visibility != null) 'visibility': visibility!.serialize(),
    },
    'paint': {
      if (lineBlur != null) 'line-blur': lineBlur!.serialize(),
      if (lineColor != null) 'line-color': lineColor!.serialize(),
      if (lineDasharray != null) 'line-dasharray': lineDasharray!.serialize(),
      if (lineGapWidth != null) 'line-gap-width': lineGapWidth!.serialize(),
      if (lineGradient != null) 'line-gradient': lineGradient!.serialize(),
      if (lineOffset != null) 'line-offset': lineOffset!.serialize(),
      if (lineOpacity != null) 'line-opacity': lineOpacity!.serialize(),
      if (linePattern != null) 'line-pattern': linePattern!.serialize(),
      if (lineTranslate != null) 'line-translate': lineTranslate!.serialize(),
      if (lineTranslateAnchor != null) 'line-translate-anchor': lineTranslateAnchor!.serialize(),
      if (lineWidth != null) 'line-width': lineWidth!.serialize(),
    },
  };

  static fromMap(Map<String, dynamic> map) {
    return LineLayerOptions(
      lineBlur: deserializeJson(map, 'paint', 'line-blur'),
      lineCap: deserializeJson(map, 'layout', 'line-cap'),
      lineColor: deserializeJson(map, 'paint', 'line-color'),
      lineDasharray: deserializeJson(map, 'paint', 'line-dasharray'),
      lineGapWidth: deserializeJson(map, 'paint', 'line-gap-width'),
      lineGradient: deserializeJson(map, 'paint', 'line-gradient'),
      lineJoin: deserializeJson(map, 'layout', 'line-join'),
      lineMiterLimit: deserializeJson(map, 'layout', 'line-miter-limit'),
      lineOffset: deserializeJson(map, 'paint', 'line-offset'),
      lineOpacity: deserializeJson(map, 'paint', 'line-opacity'),
      linePattern: deserializeJson(map, 'paint', 'line-pattern'),
      lineRoundLimit: deserializeJson(map, 'layout', 'line-round-limit'),
      lineSortKey: deserializeJson(map, 'layout', 'line-sort-key'),
      lineTranslate: deserializeJson(map, 'paint', 'line-translate'),
      lineTranslateAnchor: deserializeJson(map, 'paint', 'line-translate-anchor'),
      lineWidth: deserializeJson(map, 'paint', 'line-width'),
      visibility: deserializeJson(map,'layout', 'visibility'),
    );
  }

  // static T? _deserializeJson<T>(Map<String, dynamic> map, String type, String key) {
  //   final value = map.containsKey(type) && map[type] is Map
  //     ? map[type][key]
  //     : null;
  //   if (value == null) {
  //     return null;
  //   }

  //   // Simple values
  //   if ([String, double, bool, int].contains(T)) {
  //     return value as T;
  //   }

  //   if (T == Color) {
  //     return HexColor.fromHex(value) as T;
  //   }

  //   // Enum values
  //   if (T == LineJoin) {
  //     return LineJoin.fromString(value as String) as T;
  //   } if (T == LineCap) {
  //     return LineCap.fromString(value as String) as T;
  //   } if (T == AnchorAligment) {
  //     return AnchorAligment.fromString(value as String) as T;
  //   } if (T == Visibility) {
  //     return Visibility.fromString(value as String) as T;
  //   }

  //   throw UnimplementedError();
  // }

  @override
  bool operator ==(Object other) {
    return other is LineLayerOptions && (
      other.lineBlur == lineBlur
      && other.lineCap == lineCap
      && other.lineColor == lineColor
      && other.lineDasharray == lineDasharray
      && other.lineGapWidth == lineGapWidth
      && other.lineGradient == lineGradient
      && other.lineJoin == lineJoin
      && other.lineMiterLimit == lineMiterLimit
      && other.lineOffset == lineOffset
      && other.lineOpacity == lineOpacity
      && other.linePattern == linePattern
      && other.lineRoundLimit == lineRoundLimit
      && other.lineSortKey == lineSortKey
      && other.lineTranslate == lineTranslate
      && other.lineTranslateAnchor == lineTranslateAnchor
      && other.lineWidth == lineWidth
      && other.visibility == visibility
    );
  }

  @override
  int get hashCode => hashValues(
    lineBlur,
    lineCap,
    lineColor,
    lineDasharray,
    lineGapWidth,
    lineGradient,
    lineJoin,
    lineMiterLimit,
    lineOffset,
    lineOpacity,
    linePattern,
    lineRoundLimit,
    lineSortKey,
    lineTranslate,
    lineTranslateAnchor,
    lineWidth,
    visibility,
  );
}