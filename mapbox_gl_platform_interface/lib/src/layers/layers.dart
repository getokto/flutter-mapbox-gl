part of mapbox_gl_platform_interface;


bool typesEqual<T1, T2>() => T1 == T2;

bool typesEqualOrNull<T1, T2>() => typesEqual<T1, T2>() || typesEqual<T1, T2?>();


T? deserializeJson<T>(Map<String, dynamic> map, String type, String key) {
  final value = map.containsKey(type) && map[type] is Map
    ? map[type][key]
    : null;
  if (value == null) {
    return null;
  }


  if (typesEqualOrNull<T, LayerProperty<bool>>()) {
      return ConstantLayerProperty<bool>(deserialzeValue<bool>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<double>>()) {
      return ConstantLayerProperty<double>(deserialzeValue<double>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<int>>()) {
      return ConstantLayerProperty<int>(deserialzeValue<int>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<Color>>()) {
      return ConstantLayerProperty<Color>(deserialzeValue<Color>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<SymbolPlacement>>()) {
      return ConstantLayerProperty<SymbolPlacement>(deserialzeValue<SymbolPlacement>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<Anchor>>()) {
      return ConstantLayerProperty<Anchor>(deserialzeValue<Anchor>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<MapAligment>>()) {
      return ConstantLayerProperty<MapAligment>(deserialzeValue<MapAligment>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<AnchorAligment>>()) {
      return ConstantLayerProperty<AnchorAligment>(deserialzeValue<AnchorAligment>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<MapFit>>()) {
      return ConstantLayerProperty<MapFit>(deserialzeValue<MapFit>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<ZOrder>>()) {
      return ConstantLayerProperty<ZOrder>(deserialzeValue<ZOrder>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<Justify>>()) {
      return ConstantLayerProperty<Justify>(deserialzeValue<Justify>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<TextWritingMode>>()) {
      return ConstantLayerProperty<TextWritingMode>(deserialzeValue<TextWritingMode>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<Visibility>>()) {
      return ConstantLayerProperty<Visibility>(deserialzeValue<Visibility>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<LineCap>>()) {
      return ConstantLayerProperty<LineCap>(deserialzeValue<LineCap>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<LineJoin>>()) {
      return ConstantLayerProperty<LineJoin>(deserialzeValue<LineJoin>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<Offset>>()) {
      return ConstantLayerProperty<Offset>(deserialzeValue<Offset>(value!)) as T;
  } if (typesEqualOrNull<T, LayerProperty<EdgeInsets>>()) {
      return ConstantLayerProperty<EdgeInsets>(deserialzeValue<EdgeInsets>(value!)) as T;
  }

  return deserialzeValue(value!);
}


T deserialzeValue<T>(dynamic value) {

  if (typesEqualOrNull<T, String>() ) {
      return value as T;
  } if (typesEqualOrNull<T, double>() ) {
      return value * 1.0 as T;
  } if (typesEqualOrNull<T, bool>() ) {
      return value as T;
  } if (typesEqualOrNull<T, int>() ) {
      return value as T;
  }  if (typesEqualOrNull<T, List<String>>() ) {
      return value as T;
  }

  if (typesEqualOrNull<T, Color>() ) {
    return fromCssColor(value) as T;
  } if (typesEqualOrNull<T, Offset>() ) {
    return Offset(value[0] * 1.0, value[1] * 1.0) as T;
  } if (typesEqualOrNull<T, EdgeInsets>() ) {
    return EdgeInsets.fromLTRB(value[3] * 1.0, value[0] * 1.0, value[1] * 1.0, value[2] * 1.0) as T;
  }

  // Enum values
  if (typesEqualOrNull<T, SymbolPlacement>()) {
    return SymbolPlacement.fromString(value as String) as T;
  } if (typesEqualOrNull<T, Anchor>()) {
    return Anchor.fromString(value as String) as T;
  } if (typesEqualOrNull<T, MapAligment>() ) {
    return MapAligment.fromString(value as String) as T;
  } if (typesEqualOrNull<T, AnchorAligment>() ) {
    return AnchorAligment.fromString(value as String) as T;
  } if (typesEqualOrNull<T, MapFit>() ) {
    return MapFit.fromString(value as String) as T;
  } if (typesEqualOrNull<T, ZOrder>() ) {
    return ZOrder.fromString(value as String) as T;
  } if (typesEqualOrNull<T, Justify>() ) {
    return Justify.fromString(value as String) as T;
  } if (typesEqualOrNull<T, TextTransform>() ) {
    return TextTransform.fromString(value as String) as T;
  } if (typesEqualOrNull<T, TextWritingMode>() ) {
    return TextWritingMode.fromString(value as String) as T;
  } if (typesEqualOrNull<T, Visibility>() ) {
    return Visibility.fromString(value as String) as T;
  } if (typesEqualOrNull<T, LineCap>() ) {
    return LineCap.fromString(value as String) as T;
  } if (typesEqualOrNull<T, LineJoin>() ) {
    return LineJoin.fromString(value as String) as T;
  }

  throw UnimplementedError();
}

abstract class LayerProperty<T> {

  const LayerProperty(this.value);

  final T? value;

  dynamic serialize() {
    final _value = value;
    if (_value is EnumLike) {
      return _value.toString();
    } if (_value is Color) {
      return ["rgba", _value.red, _value.green, _value.blue, _value.opacity];
    } if (_value  is Offset) {
      return [_value.dx, _value.dy];
    } if (_value is EdgeInsets) {
      return [_value.top, _value.right, _value.bottom, _value.left];
    } if (_value is List<String>) {
      return ['literal', _value];
    }
    return _value;
  }

  static T deserialize<T>(dynamic value, T Function(dynamic) callback) {
    return callback(value);
  }

  @override
  bool operator ==(Object other) {
    return other is LayerProperty && (
      other.value == value
    );
  }

  @override
  int get hashCode => value.hashCode;

}

class ConstantLayerProperty<T> extends LayerProperty<T> {
  const ConstantLayerProperty(T value): super(value);
}

class ImageLayerProperty extends LayerProperty<String> {
  const ImageLayerProperty(String value): _value = value, super(null);

  final String _value;

  dynamic serialize() => ["image", _value];
}

/// This will accept any raw value to this propery
/// The value is unsafe and must be directly (json) serializable
/// to a value acceptable to the style specification.
/// https://docs.mapbox.com/mapbox-gl-js/style-spec/
///
/// This is especially useful when building expressions
class RawLayerProperty<T> extends LayerProperty<T> {
  const RawLayerProperty(dynamic value): _value = value, super(null);

  final dynamic _value;

  dynamic serialize() => _value;
}

abstract class StyleLayer<T extends StyleLayerOptions> {

  StyleLayerOptions get options;

  Map<String, dynamic> toMap();

  Map<K, V> cleanMap<K, V>(Map<K, V> map) {

    return map.entries.fold({}, (previousValue, element) {
      final value = element.value;
      final key = element.key;
      if (value is Map) {
        if (value.isNotEmpty) {
          previousValue[key] = value;
        }
      } else {
        previousValue[key] = value;
      }
      return previousValue;
    });
  }

}

abstract class StyleLayerOptions {
  Map<String, dynamic> toMap();
}

abstract class EnumLike {
  int get value;
}


class SymbolPlacement implements EnumLike {
  const SymbolPlacement._(this.value);
  final int value;

  static const Point = SymbolPlacement._(0);
  static const Line = SymbolPlacement._(1);
  static const LineCenter = SymbolPlacement._(2);

  @override
  String toString() {
    switch (this) {
      case Point:
        return 'point';
      case Line:
        return 'line';
      case LineCenter:
        return 'line-center';
    }
    throw Error();
  }

  static SymbolPlacement? fromString(String? str) {
    switch (str) {
      case 'point':
        return Point;
      case 'line':
        return Line;
      case 'line-center':
        return LineCenter;
    }
  }
}

class Anchor implements EnumLike {
  const Anchor._(this.value);
  final int value;

  static const Center = Anchor._(0);
  static const Left = Anchor._(1);
  static const Right = Anchor._(2);
  static const Top = Anchor._(3);
  static const Bottom = Anchor._(4);
  static const TopLeft = Anchor._(5);
  static const TopRight = Anchor._(6);
  static const BottomLeft = Anchor._(7);
  static const BottomRigh = Anchor._(8);

  @override
  String toString() {
    switch (this) {
      case Center:
        return 'center';
      case Left:
        return 'left';
      case Right:
        return 'right';
      case Top:
        return 'top';
      case Bottom:
        return 'bottom';
      case TopLeft:
        return 'top-left';
      case TopRight:
        return 'top-right';
      case BottomLeft:
        return 'bottom-left';
      case BottomRigh:
        return 'bottom-righ';
    }
    throw Error();
  }

  static Anchor? fromString(String? str) {
    switch (str) {
      case 'center':
        return Center;
      case 'left':
        return Left;
      case 'right':
        return Right;
      case 'top':
        return Top;
      case 'bottom':
        return Bottom;
      case 'top-left':
        return TopLeft;
      case 'top-right':
        return TopRight;
      case 'bottom-left':
        return BottomLeft;
      case 'bottom-righ':
        return BottomRigh;
    }
  }
}

class MapAligment implements EnumLike {
  const MapAligment._(this.value);
  final int value;

  static const Map = MapAligment._(0);
  static const Viewport = MapAligment._(1);
  static const Auto = MapAligment._(2);

  @override
  String toString() {
    switch (this) {
      case Map:
        return 'map';
      case Viewport:
        return 'viewport';
      case Auto:
        return 'auto';
    }
    throw Error();
  }

  static MapAligment? fromString(String? str) {
    switch (str) {
      case 'map':
        return Map;
      case 'viewport':
        return Viewport;
      case 'auto':
        return Auto;
    }
  }
}

class AnchorAligment implements EnumLike {
  const AnchorAligment._(this.value);
  final int value;

  static const Map = AnchorAligment._(0);
  static const Viewport = AnchorAligment._(1);

  @override
  String toString() {
    switch (this) {
      case Map:
        return 'map';
      case Viewport:
        return 'viewport';
    }
    throw Error();
  }

  static AnchorAligment? fromString(String? str) {
    switch (str) {
      case 'map':
        return Map;
      case 'viewport':
        return Viewport;
    }
  }
}

class MapFit implements EnumLike {
  const MapFit._(this.value);
  final int value;

  static const None = MapFit._(0);
  static const Width = MapFit._(1);
  static const Height = MapFit._(2);
  static const Both = MapFit._(3);

  @override
  String toString() {
    switch (this) {
      case None:
        return 'none';
      case Width:
        return 'width';
      case Height:
        return 'height';
      case Both:
        return 'both';
    }
    throw Error();
  }

  static MapFit? fromString(String? str) {
    switch (str) {
      case 'none':
        return None;
      case 'width':
        return Width;
      case 'height':
        return Height;
      case 'both':
        return Both;
    }
  }
}

class ZOrder implements EnumLike {
  const ZOrder._(this.value);
  final int value;

  static const Auto = ZOrder._(0);
  static const ViewportY = ZOrder._(1);
  static const Source = ZOrder._(2);

  @override
  String toString() {
    switch (this) {

      case Auto:
        return 'auto';
      case ViewportY:
        return 'viewport-y';
      case Source:
        return 'source';
    }
    throw Error();
  }

  static ZOrder? fromString(String? str) {
    switch (str) {

      case 'auto':
        return Auto;
      case 'viewport-y':
        return ViewportY;
      case 'source':
        return Source;
    }
  }
}


class Justify implements EnumLike {
  const Justify._(this.value);
  final int value;

  static const Auto = Justify._(3);
  static const Left = Justify._(2);
  static const Center = Justify._(1);
  static const Right = Justify._(0);

  @override
  String toString() {
    switch (this) {
      case Auto:
        return 'auto';
      case Left:
        return 'left';
      case Center:
        return 'center';
      case Right:
        return 'right';
    }
    throw Error();
  }

  static Justify? fromString(String? str) {
    switch (str) {
      case 'auto':
        return Auto;
      case 'left':
        return Left;
      case 'center':
        return Center;
      case 'right':
        return Right;
    }
  }
}


class TextTransform implements EnumLike {
  const TextTransform._(this.value);
  final int value;

  static const None = TextTransform._(2);
  static const Uppercase = TextTransform._(1);
  static const Lowercase = TextTransform._(0);

  @override
  String toString() {
    switch (this) {
      case None:
        return 'none';
      case Uppercase:
        return 'uppercase';
      case Lowercase:
        return 'lowercase';
    }
    throw Error();
  }

  static TextTransform? fromString(String? str) {
    switch (str) {
      case 'none':
        return None;
      case 'uppercase':
        return Uppercase;
      case 'lowercase':
        return Lowercase;
    }
  }
}


class TextWritingMode implements EnumLike {
  const TextWritingMode._(this.value);
  final int value;

  static const Horizontal = TextWritingMode._(0);
  static const Vertical = TextWritingMode._(1);

  @override
  String toString() {
    switch (this) {
      case Horizontal:
        return 'horizontal';
      case Vertical:
        return 'vertical';
    }
    throw Error();
  }

  static TextWritingMode? fromString(String? str) {
    switch (str) {
      case 'horizontal':
        return Horizontal;
      case 'vertical':
        return Vertical;
    }
  }
}

class LineCap implements EnumLike {
  const LineCap._(this.value);
  final int value;

  static const But = LineCap._(0);
  static const Round = LineCap._(1);
  static const Square = LineCap._(2);

  @override
  String toString() {
    switch (this) {
      case But:
        return 'but';
      case Round:
        return 'round';
      case Square:
        return 'square';
    }
    throw Error();
  }

  static LineCap? fromString(String? str) {
    switch (str) {
      case 'but':
        return But;
      case 'round':
        return Round;
      case 'square':
        return Square;
    }
  }
}

class LineJoin implements EnumLike {
  const LineJoin._(this.value);
  final int value;

  static const Bevel = LineJoin._(0);
  static const Round = LineJoin._(1);
  static const Miter = LineJoin._(2);

  @override
  String toString() {
    switch (this) {
      case Bevel:
        return 'bevel';
      case Round:
        return 'round';
      case Miter:
        return 'miter';
    }
    throw Error();
  }

  static LineJoin? fromString(String? str) {
    switch (str) {
      case 'bevel':
        return Bevel;
      case 'round':
        return Round;
      case 'miter':
        return Miter;
    }
  }
}

class Visibility implements EnumLike {
  const Visibility._(this.value);
  final int value;

  static const Visible = Visibility._(0);
  static const None = Visibility._(1);

  @override
  String toString() {
    switch (this) {
      case Visible:
        return 'visible';
      case None:
        return 'none';
    }
    throw Error();
  }

  static Visibility? fromString(String? str) {
    switch (str) {
      case 'visible':
        return Visible;
      case 'none':
        return None;
    }
  }
}