part of mapbox_gl_platform_interface;


class SymbolLayer extends StyleLayer<SymbolLayerOptions> {
  SymbolLayer({
    required this.id,
    required this.source,
    // this.sourceLayerID,
    // this.aboveLayerID,
    // this.belowLayerID,
    // this.layerIndex,
    // this.filter,
    // this.minZoomLevel,
    // this.maxZoomLevel,
    SymbolLayerOptions? options,
  }) : this.options = options != null ? options : SymbolLayerOptions();

  /// A unique identifier for this fill.
  ///
  /// The identifier is an arbitrary unique string.
  final String id;

  /// The source from which to obtain the data to style. If the source has not yet been added to the current style, the behavior is undefined.
  final String source;

  /// Identifier of the layer within the source identified by the sourceID property from which the receiver obtains the data to style.
  // final String? sourceLayerID;

  /// Inserts a layer above aboveLayerID.
  // final String? aboveLayerID;

  /// Inserts a layer below belowLayerID
  // final String? belowLayerID;

  /// Inserts a layer at a specified index
  // final int? layerIndex;

  ///  Filter only the features in the source layer that satisfy a condition that you define
  // final List<dynamic> filter;

  /// The minimum zoom level at which the layer gets parsed and appears.
  // final int? minZoomLevel;

  /// The maximum zoom level at which the layer gets parsed and appears.
  // final int? maxZoomLevel;

  // final Map? _data;
  // Map? get data => _data;

  /// The fill configuration options most recently applied programmatically
  /// via the map controller.
  ///
  /// The returned value does not reflect any changes made to the fill through
  /// touch events. Add listeners to the owning map controller to track those.
  final options;


  Map<String, dynamic> toMap() => {
    'id': id,
    'type': 'symbol',
    'source': source,
    ...cleanMap(options.toMap()),
  };

  static SymbolLayer fromMap(Map<String, dynamic> map) {
    return SymbolLayer(
      id: map['id'],
      source: map['source'],
      options: SymbolLayerOptions.fromMap(<String, dynamic>{
        'layout': map['layout'],
        'paint': map['paint'],
      }),

    );
  }

  @override
  bool operator ==(Object other) {
    return other is SymbolLayer && (
      other.id == id
      && other.source == source
      && other.options == options
    );
  }

  @override
  int get hashCode => hashValues(
    id,
    source,
    options,
  );

}



class SymbolLayerOptions extends StyleLayerOptions {
  SymbolLayerOptions({
    this.iconAllowOverlap,
    this.iconAnchor,
    this.iconColor,
    this.iconHaloBlur,
    this.iconHaloColor,
    this.iconHaloWidth,
    this.iconIgnorePlacement,
    this.iconImage,
    this.iconKeepUpright,
    this.iconOffset,
    this.iconOpacity,
    this.iconOptional,
    this.iconPadding,
    this.iconPitchAlignment,
    this.iconRotate,
    this.iconRotationAlignment,
    this.iconSize,
    this.iconTextFit,
    this.iconTextFitPadding,
    this.iconTranslate,
    this.iconTranslateAnchor,
    this.symbolAvoidEdges,
    this.symbolPlacement,
    this.symbolSortKey,
    this.symbolSpacing,
    this.symbolZOrder,
    this.textAllowOverlap,
    this.textAnchor,
    this.textColor,
    this.textField,
    this.textFont,
    this.textHaloBlur,
    this.textHaloColor,
    this.textHaloWidth,
    this.textIgnorePlacement,
    this.textJustify,
    this.textKeepUpright,
    this.textLetterSpacing,
    this.textLineHeight,
    this.textMaxAngle,
    this.textMaxWidth,
    this.textOffset,
    this.textOpacity,
    this.textOptional,
    this.textPadding,
    this.textPitchAlignment,
    this.textRadialOffset,
    this.textRotate,
    this.textRotationAlignment,
    this.textSize,
    this.textTransform,
    this.textTranslate,
    this.textTranslateAnchor,
    this.textVariableAnchor,
    this.textWritingMode,
    this.visibility,

  });


  final LayerProperty<bool>? iconAllowOverlap;
  final LayerProperty<Anchor>? iconAnchor;
  final LayerProperty<Color>? iconColor;
  final LayerProperty<double>? iconHaloBlur;
  final LayerProperty<Color>? iconHaloColor;
  final LayerProperty<double>? iconHaloWidth;
  final LayerProperty<bool>? iconIgnorePlacement;
  final LayerProperty<String>? iconImage;
  final LayerProperty<bool>? iconKeepUpright;
  final LayerProperty<Offset>? iconOffset;
  final LayerProperty<double>? iconOpacity;
  final LayerProperty<bool>? iconOptional;
  final LayerProperty<int>? iconPadding;
  final LayerProperty<MapAligment>? iconPitchAlignment;
  final LayerProperty<double>? iconRotate;
  final LayerProperty<MapAligment>? iconRotationAlignment;

  /// Optional [double] greater than or equal to 0. Units in factor of the original icon size.
  /// Defaults to 1. Requires [iconImage].
  ///
  /// Scales the original size of the icon by the provided factor. The new pixel size of
  /// the image will be the original pixel size multiplied by icon-size. 1 is the original
  /// size; 3 triples the size of the image.
  final LayerProperty<double>? iconSize;

  /// Optional enum. One of "none", "width", "height", "both". Defaults to "none".
  /// Requires [iconImage]. Requires [textField].
  final LayerProperty<MapFit>? iconTextFit;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0,0,0]. Requires icon-image.
  /// Requires [textField].
  /// Requires [iconTextFit] to be "both", or "width", or "height"
  final LayerProperty<EdgeInsets>? iconTextFitPadding;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0]. Requires icon-image.
  final LayerProperty<Offset>? iconTranslate;

  ///  Optional enum. One of "map", "viewport". Defaults to "map". Requires icon-image. Requires icon-translate.
  final LayerProperty<AnchorAligment>? iconTranslateAnchor;

  /// Optional boolean. Defaults to false.
  final LayerProperty<bool>? symbolAvoidEdges;

  /// Optional enum. One of "point", "line", "line-center". Defaults to "point".
  final LayerProperty<SymbolPlacement>? symbolPlacement;

  /// Optional number.
  final LayerProperty<int>? symbolSortKey;

  /// Optional number greater than or equal to 1. Units in pixels. Defaults to 250. Requires symbol-placement to be "line".
  final LayerProperty<int>? symbolSpacing;

  /// Optional enum. One of "auto", "viewport-y", "source". Defaults to "auto".
  final LayerProperty<ZOrder>? symbolZOrder;

  /// Optional boolean. Defaults to false. Requires text-field.
  final LayerProperty<bool>? textAllowOverlap;

  /// Optional enum. One of "center", "left", "right", "top", "bottom", "top-left",
  /// "top-right", "bottom-left", "bottom-right". Defaults to "center".
  /// Requires text-field. Disabled by text-variable-anchor.
  final LayerProperty<Anchor>? textAnchor;

  /// Optional color. Defaults to "#000000". Requires text-field.
  final LayerProperty<Color>? textColor;

  /// Optional formatted. Defaults to "".
  final LayerProperty<String>? textField;

  /// Optional array of strings. Defaults to ["Open Sans Regular","Arial Unicode MS Regular"].
  /// Requires text-field.
  final LayerProperty<List<String>>? textFont;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 0.
  /// Requires text-field. Supports
  final LayerProperty<double>? textHaloBlur;

  /// Optional color. Defaults to "rgba(0, 0, 0, 0)". Requires text-field.
  final LayerProperty<Color>? textHaloColor;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 0. Requires text-field.
  final LayerProperty<double>? textHaloWidth;

  /// Optional boolean. Defaults to false. Requires text-field.
  final LayerProperty<bool>? textIgnorePlacement;

  /// Optional enum. One of "auto", "left", "center", "right". Defaults to "center". Requires text-field.
  final LayerProperty<Justify>? textJustify;

  /// Optional boolean. Defaults to true. Requires text-field. Requires text-rotation-alignment
  /// to be "map". Requires symbol-placement to be "line", or "line-center".
  final LayerProperty<bool>? textKeepUpright;

  /// Units in ems. Defaults to 0. Requires text-field
  final LayerProperty<double>? textLetterSpacing;

  /// Units in ems. Defaults to 1.2. Requires text-field
  final LayerProperty<double>? textLineHeight;

  /// Units in degrees. Defaults to 45. Requires text-field.
  final LayerProperty<double>? textMaxAngle;

  /// Units in ems. Defaults to 10. Requires text-field. Requires symbol-placement to be "point"
  final LayerProperty<double>? textMaxWidth;

  /// Units in ems. Defaults to [0,0]. Requires text-field. Disabled by text-radial-offset.
  final LayerProperty<Offset>? textOffset;

  /// Optional number between 0 and 1 inclusive. Defaults to 1. Requires text-field.
  final LayerProperty<double>? textOpacity;

  /// Optional boolean. Defaults to false. Requires text-field. Requires icon-image.
  final LayerProperty<bool>? textOptional;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 2. Requires text-field
  final LayerProperty<double>? textPadding;

  /// Optional enum. One of "map", "viewport", "auto". Defaults to "auto". Requires text-field.
  final LayerProperty<Alignment>? textPitchAlignment;

  /// Optional number. Units in ems. Defaults to 0. Requires text-field.
  final LayerProperty<double>? textRadialOffset;

  /// Optional number. Units in degrees. Defaults to 0. Requires text-field.
  final LayerProperty<double>? textRotate;

  /// Optional enum. One of "map", "viewport", "auto". Defaults to "auto". Requires text-field.
  final LayerProperty<Alignment>? textRotationAlignment;

  /// Optional number greater than or equal to 0. Units in pixels. Defaults to 16. Requires text-field.
  final LayerProperty<double>? textSize;

  /// Optional enum. One of "none", "uppercase", "lowercase". Defaults to "none".
  final LayerProperty<TextTransform>? textTransform;

  /// Optional array of numbers. Units in pixels. Defaults to [0,0]. Requires text-field.
  final LayerProperty<Offset>? textTranslate;

  /// Optional enum. One of "map", "viewport". Defaults to "map". Requires text-field.
  final LayerProperty<AnchorAligment>? textTranslateAnchor;

  /// Optional array of enums. One of "center", "left", "right", "top", "bottom", "top-left", "top-right", "bottom-left", "bottom-right". Requires text-field. Requires symbol-placement to be "point".
  final LayerProperty<Anchor>? textVariableAnchor;

  /// Optional array of enums. One of "horizontal", "vertical". Requires text-field.
  final LayerProperty<TextWritingMode>? textWritingMode;

  /// Optional enum. One of "visible", "none". Defaults to "visible".
  final LayerProperty<Visibility>? visibility;

  Map<String, dynamic> toMap() => {
    'layout': {
      if (iconAllowOverlap != null) 'icon-allow-overlap': _serializeJson(iconAllowOverlap),
      if (iconAnchor != null) 'icon-anchor': _serializeJson(iconAnchor),
      if (iconIgnorePlacement != null) 'icon-ignore-placement': _serializeJson(iconIgnorePlacement),
      if (iconImage != null) 'icon-image': _serializeJson(iconImage),
      if (iconKeepUpright != null) 'icon-keep-upright': _serializeJson(iconKeepUpright),
      if (iconOffset != null) 'icon-offset': _serializeJson(iconOffset),
      if (iconOptional != null) 'icon-optional': _serializeJson(iconOptional),
      if (iconPadding != null) 'icon-padding': _serializeJson(iconPadding),
      if (iconPitchAlignment != null) 'icon-pitch-alignment': _serializeJson(iconPitchAlignment),
      if (iconRotate != null) 'icon-rotate': _serializeJson(iconRotate),
      if (iconRotationAlignment != null) 'icon-rotation-alignment': _serializeJson(iconRotationAlignment),
      if (iconSize != null) 'icon-size': _serializeJson(iconSize),
      if (iconTextFit != null) 'icon-text-fit': _serializeJson(iconTextFit),
      if (iconTextFitPadding != null) 'icon-text-fit-padding': _serializeJson(iconTextFitPadding),
      if (symbolAvoidEdges != null) 'symbol-avoid-edges': _serializeJson(symbolAvoidEdges),
      if (symbolPlacement != null) 'symbol-placement': _serializeJson(symbolPlacement),
      if (symbolSortKey != null) 'symbol-sort-key': _serializeJson(symbolSortKey),
      if (symbolSpacing != null) 'symbol-spacing': _serializeJson(symbolSpacing),
      if (symbolZOrder != null) 'symbol-z-order': _serializeJson(symbolZOrder),
      if (textAllowOverlap != null) 'text-allow-overlap': _serializeJson(textAllowOverlap),
      if (textAnchor != null) 'text-anchor': _serializeJson(textAnchor),
      if (textField != null) 'text-field': _serializeJson(textField),
      if (textFont != null) 'text-font': _serializeJson(textFont),
      if (textIgnorePlacement != null) 'text-ignore-placement': _serializeJson(textIgnorePlacement),
      if (textJustify != null) 'text-justify': _serializeJson(textJustify),
      if (textKeepUpright != null) 'text-keep-upright': _serializeJson(textKeepUpright),
      if (textLetterSpacing != null) 'text-letter-spacing': _serializeJson(textLetterSpacing),
      if (textLineHeight != null) 'text-line-height': _serializeJson(textLineHeight),
      if (textMaxAngle != null) 'text-max-angle': _serializeJson(textMaxAngle),
      if (textMaxWidth != null) 'text-max-width': _serializeJson(textMaxWidth),
      if (textOffset != null) 'text-offset': _serializeJson(textOffset),
      if (textOptional != null) 'text-optional': _serializeJson(textOptional),
      if (textPadding != null) 'text-padding': _serializeJson(textPadding),
      if (textPitchAlignment != null) 'text-pitch-alignment': _serializeJson(textPitchAlignment),
      if (textRadialOffset != null) 'text-radial-offset': _serializeJson(textRadialOffset),
      if (textRotate != null) 'text-rotate': _serializeJson(textRotate),
      if (textRotationAlignment != null) 'text-rotation-alignment': _serializeJson(textRotationAlignment),
      if (textSize != null) 'text-size': _serializeJson(textSize),
      if (textTransform != null) 'text-transform': _serializeJson(textTransform),
      if (textVariableAnchor != null) 'text-variable-anchor': _serializeJson(textVariableAnchor),
      if (textWritingMode != null) 'text-writing-mode': _serializeJson(textWritingMode),
      if (visibility != null) 'visibility': _serializeJson(visibility),

    },
    'paint': {
      if (iconColor != null) 'icon-color': _serializeJson(iconColor),
      if (iconHaloBlur != null) 'icon-halo-blur': _serializeJson(iconHaloBlur),
      if (iconHaloColor != null) 'icon-halo-color': _serializeJson(iconHaloColor),
      if (iconHaloWidth != null) 'icon-halo-width': _serializeJson(iconHaloWidth),
      if (iconOpacity != null) 'icon-opacity': _serializeJson(iconOpacity),
      if (iconTranslate != null) 'icon-translate': _serializeJson(iconTranslate),
      if (iconTranslateAnchor != null) 'icon-translate-anchor': _serializeJson(iconTranslateAnchor),
      if (textColor != null) 'text-color': _serializeJson(textColor),
      if (textHaloBlur != null) 'text-halo-blur': _serializeJson(textHaloBlur),
      if (textHaloColor != null) 'text-halo-color': _serializeJson(textHaloColor),
      if (textHaloWidth != null) 'text-halo-width': _serializeJson(textHaloWidth),
      if (textOpacity != null) 'text-opacity': _serializeJson(textOpacity),
      if (textTranslate != null) 'text-translate': _serializeJson(textTranslate),
      if (textTranslateAnchor != null) 'text-translate-anchor': _serializeJson(textTranslateAnchor),

    },
  };

  static fromMap(Map<String, dynamic> map) {
    return SymbolLayerOptions(
      iconAllowOverlap: _deserializeJson(map,'layout', 'icon-allow-overlap'),
      iconAnchor: _deserializeJson(map,'layout', 'icon-anchor'),
      iconColor: _deserializeJson(map,'paint', 'icon-color'),
      iconHaloBlur: _deserializeJson(map,'paint', 'icon-halo-blur'),
      iconHaloColor: _deserializeJson(map,'paint', 'icon-halo-color'),
      iconHaloWidth: _deserializeJson(map,'paint', 'icon-halo-width'),
      iconIgnorePlacement: _deserializeJson(map,'layout', 'icon-ignore-placement'),
      iconImage: _deserializeJson(map,'layout', 'icon-image'),
      iconKeepUpright: _deserializeJson(map,'layout', 'icon-keep-upright'),
      iconOffset: _deserializeJson(map,'layout', 'icon-offset'),
      iconOpacity: _deserializeJson(map,'paint', 'icon-opacity'),
      iconOptional: _deserializeJson(map,'layout', 'icon-optional'),
      iconPadding: _deserializeJson(map,'layout', 'icon-padding'),
      iconPitchAlignment: _deserializeJson(map,'layout', 'icon-pitch-alignment'),
      iconRotate: _deserializeJson(map,'layout', 'icon-rotate'),
      iconRotationAlignment: _deserializeJson(map,'layout', 'icon-rotation-alignment'),
      iconSize: _deserializeJson(map,'layout', 'icon-size'),
      iconTextFit: _deserializeJson(map,'layout', 'icon-text-fit'),
      iconTextFitPadding: _deserializeJson(map,'layout', 'icon-text-fit-padding'),
      iconTranslate: _deserializeJson(map,'paint', 'icon-translate'),
      iconTranslateAnchor: _deserializeJson(map,'paint', 'icon-translate-anchor'),
      symbolAvoidEdges: _deserializeJson(map,'layout', 'symbol-avoid-edges'),
      symbolPlacement: _deserializeJson(map,'layout', 'symbol-placement'),
      symbolSortKey: _deserializeJson(map,'layout', 'symbol-sort-key'),
      symbolSpacing: _deserializeJson(map,'layout', 'symbol-spacing'),
      symbolZOrder: _deserializeJson(map,'layout', 'symbol-z-order'),
      textAllowOverlap: _deserializeJson(map,'layout', 'text-allow-overlap'),
      textAnchor: _deserializeJson(map,'layout', 'text-anchor'),
      textColor: _deserializeJson(map,'paint', 'text-color'),
      textField: _deserializeJson(map,'layout', 'text-field'),
      textFont: _deserializeJson(map,'layout', 'text-font'),
      textHaloBlur: _deserializeJson(map,'paint', 'text-halo-blur'),
      textHaloColor: _deserializeJson(map,'paint', 'text-halo-color'),
      textHaloWidth: _deserializeJson(map,'paint', 'text-halo-width'),
      textIgnorePlacement: _deserializeJson(map,'layout', 'text-ignore-placement'),
      textJustify: _deserializeJson(map,'layout', 'text-justify'),
      textKeepUpright: _deserializeJson(map,'layout', 'text-keep-upright'),
      textLetterSpacing: _deserializeJson(map,'layout', 'text-letter-spacing'),
      textLineHeight: _deserializeJson(map,'layout', 'text-line-height'),
      textMaxAngle: _deserializeJson(map,'layout', 'text-max-angle'),
      textMaxWidth: _deserializeJson(map,'layout', 'text-max-width'),
      textOffset: _deserializeJson(map,'layout', 'text-offset'),
      textOpacity: _deserializeJson(map,'paint', 'text-opacity'),
      textOptional: _deserializeJson(map,'layout', 'text-optional'),
      textPadding: _deserializeJson(map,'layout', 'text-padding'),
      textPitchAlignment: _deserializeJson(map,'layout', 'text-pitch-alignment'),
      textRadialOffset: _deserializeJson(map,'layout', 'text-radial-offset'),
      textRotate: _deserializeJson(map,'layout', 'text-rotate'),
      textRotationAlignment: _deserializeJson(map,'layout', 'text-rotation-alignment'),
      textSize: _deserializeJson(map,'layout', 'text-size'),
      textTransform: _deserializeJson(map,'layout', 'text-transform'),
      textTranslate: _deserializeJson(map,'paint', 'text-translate'),
      textTranslateAnchor: _deserializeJson(map,'paint', 'text-translate-anchor'),
      textVariableAnchor: _deserializeJson(map,'layout', 'text-variable-anchor'),
      textWritingMode: _deserializeJson(map,'layout', 'text-writing-mode'),
      visibility: _deserializeJson(map,'layout', 'visibility'),
    );
  }

  dynamic _serializeJson<T>(T value) {
    if (value is EnumLike) {
      return value.toString();
    } if (value is Color) {
      return value.toHex();
    }
    return value;
  }


  static T? _deserializeJson<T>(Map<String, dynamic> map, String type, String key) {
    final value = map.containsKey(type) && map[type] is Map
      ? map[type][key]
      : null;
    if (value == null) {
      return null;
    }

    // Simple values
    if ([String, double, bool, int].contains(T)) {
      return value as T;
    }

    if (T == Color) {
      return HexColor.fromHex(value) as T;
    }

    // Enum values
    if (T == SymbolPlacement) {
      return SymbolPlacement.fromString(value as String) as T;
    } if (T == Anchor) {
      return Anchor.fromString(value as String) as T;
    } if (T == MapAligment) {
      return MapAligment.fromString(value as String) as T;
    } if (T == AnchorAligment) {
      return AnchorAligment.fromString(value as String) as T;
    } if (T == MapFit) {
      return MapFit.fromString(value as String) as T;
    } if (T == ZOrder) {
      return ZOrder.fromString(value as String) as T;
    } if (T == Justify) {
      return Justify.fromString(value as String) as T;
    } if (T == TextTransform) {
      return TextTransform.fromString(value as String) as T;
    } if (T == TextWritingMode) {
      return TextWritingMode.fromString(value as String) as T;
    } if (T == Visibility) {
      return Visibility.fromString(value as String) as T;
    }
    // List values

    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) {
    return other is SymbolLayerOptions && (
    other.iconAllowOverlap == iconAllowOverlap
    && other.iconAnchor == iconAnchor
    && other.iconColor == iconColor
    && other.iconHaloBlur == iconHaloBlur
    && other.iconHaloColor == iconHaloColor
    && other.iconHaloWidth == iconHaloWidth
    && other.iconIgnorePlacement == iconIgnorePlacement
    && other.iconImage == iconImage
    && other.iconKeepUpright == iconKeepUpright
    && other.iconOffset == iconOffset
    && other.iconOpacity == iconOpacity
    && other.iconOptional == iconOptional
    && other.iconPadding == iconPadding
    && other.iconPitchAlignment == iconPitchAlignment
    && other.iconRotate == iconRotate
    && other.iconRotationAlignment == iconRotationAlignment
    && other.iconSize == iconSize
    && other.iconTextFit == iconTextFit
    && other.iconTextFitPadding == iconTextFitPadding
    && other.iconTranslate == iconTranslate
    && other.iconTranslateAnchor == iconTranslateAnchor
    && other.symbolAvoidEdges == symbolAvoidEdges
    && other.symbolPlacement == symbolPlacement
    && other.symbolSortKey == symbolSortKey
    && other.symbolSpacing == symbolSpacing
    && other.symbolZOrder == symbolZOrder
    && other.textAllowOverlap == textAllowOverlap
    && other.textAnchor == textAnchor
    && other.textColor == textColor
    && other.textField == textField
    && other.textFont == textFont
    && other.textHaloBlur == textHaloBlur
    && other.textHaloColor == textHaloColor
    && other.textHaloWidth == textHaloWidth
    && other.textIgnorePlacement == textIgnorePlacement
    && other.textJustify == textJustify
    && other.textKeepUpright == textKeepUpright
    && other.textLetterSpacing == textLetterSpacing
    && other.textLineHeight == textLineHeight
    && other.textMaxAngle == textMaxAngle
    && other.textMaxWidth == textMaxWidth
    && other.textOffset == textOffset
    && other.textOpacity == textOpacity
    && other.textOptional == textOptional
    && other.textPadding == textPadding
    && other.textPitchAlignment == textPitchAlignment
    && other.textRadialOffset == textRadialOffset
    && other.textRotate == textRotate
    && other.textRotationAlignment == textRotationAlignment
    && other.textSize == textSize
    && other.textTransform == textTransform
    && other.textTranslate == textTranslate
    && other.textTranslateAnchor == textTranslateAnchor
    && other.textVariableAnchor == textVariableAnchor
    && other.textWritingMode == textWritingMode
    && other.visibility == visibility);
  }

  @override
  int get hashCode => hashValues(
    hashValues(
      iconAllowOverlap,
      iconAnchor,
      iconColor,
      iconHaloBlur,
      iconHaloColor,
      iconHaloWidth,
      iconIgnorePlacement,
      iconImage,
      iconKeepUpright,
      iconOffset,
      iconOpacity,
      iconOptional,
      iconPadding,
      iconPitchAlignment,
      iconRotate,
      iconRotationAlignment,
      iconSize,
      iconTextFit,
      iconTextFitPadding,
      iconTranslate,

    ),
    hashValues(
      iconTranslateAnchor,
      symbolAvoidEdges,
      symbolPlacement,
      symbolSortKey,
      symbolSpacing,
      symbolZOrder,
      textAllowOverlap,
      textAnchor,
      textColor,
      textField,
      textFont,
      textHaloBlur,
      textHaloColor,
      textHaloWidth,
      textIgnorePlacement,
      textJustify,
      textKeepUpright,
      textLetterSpacing,
    ),
    hashValues(
      textLineHeight,
      textMaxAngle,
      textMaxWidth,
      textOffset,
      textOpacity,
      textOptional,
      textPadding,
      textPitchAlignment,
      textRadialOffset,
      textRotate,
      textRotationAlignment,
      textSize,
      textTransform,
      textTranslate,
      textTranslateAnchor,
      textVariableAnchor,
      textWritingMode,
      visibility,
    ),
  );

}