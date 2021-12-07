part of mapbox_gl_platform_interface;


class FillLayer extends StyleLayer<StyleLayerOptions> {
  FillLayer({
      required this.id,
      required this.source,
      this.sourceLayer,
      FillLayerOptions? options,
    }
  ) : this.options = options != null ? options : FillLayerOptions();

  /// A unique identifier for this fill.
  ///
  /// The identifier is an arbitrary unique string.
  final String id;

  /// The source from which to obtain the data to style.
  ///
  /// If the source has not yet been added to the current style, the behavior is undefined.
  final String source;

  final String? sourceLayer;

  final FillLayerOptions options;

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': 'symbol',
    'source': source,
    'source-layer': sourceLayer,
    ...cleanMap(options.toMap()),
  };

  static FillLayer fromMap(Map<String, dynamic> map) {
    return FillLayer(
      id: map['id'],
      source: map['source'],
      sourceLayer: map['source-layer'],
      options: FillLayerOptions.fromMap(<String, dynamic>{
        'layout': map['layout'],
        'paint': map['paint'],
      }),

    );
  }

  @override
  bool operator ==(Object other) {
    return other is FillLayer && (
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

class FillLayerOptions extends StyleLayerOptions {
  FillLayerOptions({
    this.fillAntialias,
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
    this.fillSortKey,
    this.fillTranslate,
    this.fillTranslateAnchor,
    this.visibility = Visibility.Visible,
  });


  /// Optional boolean. Defaults to true
  final LayerProperty<bool>? fillAntialias;

  /// Optional color. Defaults to "#000000". Disabled by fill-pattern
  final LayerProperty<double>? fillColor;

  /// Optional number between 0 and 1 inclusive. Defaults to 1.
  final LayerProperty<double>? fillOpacity;

  /// Optional color. Disabled by fill-pattern. Requires fill-antialias to be true.
  final LayerProperty<Color>? fillOutlineColor;

  /// Optional resolvedImage.
  final ImageLayerProperty? fillPattern;

  /// Optional number.
  final LayerProperty<int>? fillSortKey;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0].
  final List<double>? fillTranslate;

  /// Optional enum. One of "map", "viewport". Defaults to "map".
  final LayerProperty<AnchorAligment>? fillTranslateAnchor;

  /// Optional enum. One of "visible", "none". Defaults to "visible".
  final Visibility visibility;

  Map<String, dynamic> toMap() => {
    'layout': {
      if (fillSortKey != null) 'fill-sort-key' : serializeValue(fillSortKey),
      'visibility': serializeValue(visibility),
    },
    'paint': {
      if (fillAntialias != null) 'fill-antialias' : serializeValue(fillAntialias),
      if (fillColor != null) 'fill-color' : serializeValue(fillColor),
      if (fillOpacity != null) 'fill-opacity' : serializeValue(fillOpacity),
      if (fillOutlineColor != null) 'fill-outline-color' : serializeValue(fillOutlineColor),
      if (fillPattern != null) 'fill-pattern' : serializeValue(fillPattern),
      if (fillTranslate != null) 'fill-translate' : serializeValue(fillTranslate),
      if (fillTranslateAnchor != null) 'fill-translate-anchor' : serializeValue(fillTranslateAnchor),
    },
  };

  static fromMap(Map<String, dynamic> map) {
    return FillLayerOptions(
      fillAntialias: deserializeJson(map, 'paint', 'fill-antialias'),
      fillColor: deserializeJson(map, 'paint', 'fill-color'),
      fillOpacity: deserializeJson(map, 'paint', 'fill-opacity'),
      fillOutlineColor: deserializeJson(map, 'paint', 'fill-outline-color'),
      fillPattern: deserializeJson(map, 'paint', 'fill-pattern'),
      fillSortKey: deserializeJson(map, 'layout', 'fill-sort-key'),
      fillTranslate: deserializeJson(map, 'paint', 'fill-translate'),
      fillTranslateAnchor: deserializeJson(map, 'paint', 'fill-translate-anchor'),
      visibility: deserializeJson(map,'layout', 'visibility'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FillLayerOptions && (
    other.fillAntialias == fillAntialias
    && other.fillColor == fillColor
    && other.fillOpacity == fillOpacity
    && other.fillOutlineColor == fillOutlineColor
    && other.fillPattern == fillPattern
    && other.fillSortKey == fillSortKey
    && listEquals<double>(other.fillTranslate, fillTranslate)
    && other.fillTranslateAnchor == fillTranslateAnchor
    && other.visibility == visibility
    );
  }

  @override
  int get hashCode => hashValues(
    fillAntialias,
    fillColor,
    fillOpacity,
    fillOutlineColor,
    fillPattern,
    fillSortKey,
    hashList(fillTranslate),
    fillTranslateAnchor,
    visibility,
  );
}