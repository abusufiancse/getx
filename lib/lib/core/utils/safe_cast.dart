// lib/data/models/safe_cast.dart
// lib/data/models/safe_cast.dart
class SafeCast {
  static int asInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  static double asDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  static String asString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  static bool asBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    if (value is int) return value != 0;
    return defaultValue;
  }

  static List<T> asList<T>(dynamic value, {List<T>? defaultValue, T Function(dynamic)? elementConverter}) {
    if (value == null) return defaultValue ?? <T>[];
    if (value is List) {
      if (elementConverter != null) {
        return value.map((e) => elementConverter(e)).toList();
      }
      return value.cast<T>();
    }
    return defaultValue ?? <T>[];
  }

  static Map<String, dynamic> asMap(dynamic value, {Map<String, dynamic>? defaultValue}) {
    if (value == null) return defaultValue ?? {};
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return defaultValue ?? {};
  }
}