class Parser {
  static String asString(dynamic value, {String defaultValue = ''}) {
    try {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    } catch (e) {
      _logError('asString', e, value);
      return defaultValue;
    }
  }

  static String? asStringOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    } catch (e) {
      _logError('asStringOrNull', e, value);
      return null;
    }
  }

  static int asInt(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.parse(value.toString());
    } catch (e) {
      _logError('asInt', e, value);
      return defaultValue;
    }
  }

  static int? asIntOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString());
    } catch (e) {
      _logError('asIntOrNull', e, value);
      return null;
    }
  }

  static double asDouble(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      _logError('asDouble', e, value);
      return defaultValue;
    }
  }

  static double? asDoubleOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    } catch (e) {
      _logError('asDoubleOrNull', e, value);
      return null;
    }
  }

  static DateTime asDateTime(dynamic value, {DateTime? defaultValue}) {
    try {
      if (value == null) return defaultValue ?? DateTime.now();
      if (value is DateTime) return value;
      final dateStr = value.toString();
      if (dateStr.isEmpty) return defaultValue ?? DateTime.now();
      return DateTime.parse(dateStr);
    } catch (e) {
      _logError('asDateTime', e, value);
      return defaultValue ?? DateTime.now();
    }
  }

  static DateTime? asDateTimeOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is DateTime) return value;
      final dateStr = value.toString();
      if (dateStr.isEmpty) return null;
      return DateTime.parse(dateStr);
    } catch (e) {
      _logError('asDateTimeOrNull', e, value);
      return null;
    }
  }

  static Map<String, dynamic> asMap(
    dynamic value, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is Map<String, dynamic>) return Map.from(value);
      if (value is Map<dynamic, dynamic>) {
        return {for (final k in value.keys) k.toString(): value[k]};
      }
      _logError('asMap', 'Value is not a Map', value);
      return defaultValue;
    } catch (e) {
      _logError('asMap', e, value);
      return defaultValue;
    }
  }

  static Map<String, dynamic>? asMapOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return Map.from(value);
      if (value is Map<dynamic, dynamic>) {
        return {for (final k in value.keys) k.toString(): value[k]};
      }
      _logError('asMapOrNull', 'Value is not a Map', value);
      return null;
    } catch (e) {
      _logError('asMapOrNull', e, value);
      return null;
    }
  }

  static List<Map<String, dynamic>> asListMap(
    dynamic value, {
    List<Map<String, dynamic>> defaultValue = const [],
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is! List) {
        _logError('asListMap', 'Value is not a List', value);
        return defaultValue;
      }
      return value
          .map((e) => asMap(e, defaultValue: {}))
          .toList()
          .cast<Map<String, dynamic>>();
    } catch (e) {
      _logError('asListMap', e, value);
      return defaultValue;
    }
  }

  static List<Map<String, dynamic>>? asListMapOrNull(dynamic value) {
    try {
      if (value == null) return null;
      if (value is! List) {
        _logError('asListMapOrNull', 'Value is not a List', value);
        return null;
      }
      return value
          .map((e) => asMap(e, defaultValue: {}))
          .toList()
          .cast<Map<String, dynamic>>();
    } catch (e) {
      _logError('asListMapOrNull', e, value);
      return null;
    }
  }

  static void _logError(String method, dynamic error, dynamic value) {
    // ignore: avoid_print
    print('Parser.$method Error: $error, Value: $value');
  }
}

extension MapParser on Map<String, dynamic> {
  String parseString(String key, {String defaultValue = ''}) {
    return Parser.asString(this[key], defaultValue: defaultValue);
  }

  String? parseStringOrNull(String key) {
    return Parser.asStringOrNull(this[key]);
  }

  int parseInt(String key, {int defaultValue = 0}) {
    return Parser.asInt(this[key], defaultValue: defaultValue);
  }

  int? parseIntOrNull(String key) {
    return Parser.asIntOrNull(this[key]);
  }

  double parseDouble(String key, {double defaultValue = 0.0}) {
    return Parser.asDouble(this[key], defaultValue: defaultValue);
  }

  double? parseDoubleOrNull(String key) {
    return Parser.asDoubleOrNull(this[key]);
  }

  DateTime parseDateTime(String key, {DateTime? defaultValue}) {
    return Parser.asDateTime(this[key], defaultValue: defaultValue);
  }

  DateTime? parseDateTimeOrNull(String key) {
    return Parser.asDateTimeOrNull(this[key]);
  }

  Map<String, dynamic> parseMap(String key,
      {Map<String, dynamic> defaultValue = const {}}) {
    return Parser.asMap(this[key], defaultValue: defaultValue);
  }

  Map<String, dynamic>? parseMapOrNull(String key) {
    return Parser.asMapOrNull(this[key]);
  }

  List<Map<String, dynamic>> parseListMap(
    String key, {
    List<Map<String, dynamic>> defaultValue = const [],
  }) {
    return Parser.asListMap(this[key], defaultValue: defaultValue);
  }

  List<Map<String, dynamic>>? parseListMapOrNull(String key) {
    return Parser.asListMapOrNull(this[key]);
  }
}
