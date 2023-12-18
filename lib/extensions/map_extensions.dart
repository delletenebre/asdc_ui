import 'list_extensions.dart';

extension FormBuilderStateExtensions on Map<String, dynamic> {
  static Map<String, dynamic> _dotNotationToMap(
      Map<String, dynamic> object, String key, dynamic value) {
    final keys = key.split('.');
    final currentKey = keys.removeAt(0);

    object = {...object};

    if (keys.isEmpty) {
      object[currentKey] = value;
    } else {
      object.remove(key);
      final nextKey = keys.first;

      if (object[currentKey] == null) {
        final intNextKey = int.tryParse(nextKey);
        if (intNextKey != null) {
          object[currentKey] = [];
        } else {
          object[currentKey] = <String, dynamic>{};
        }
      }

      if (object[currentKey] is List) {
        final index = int.parse(keys.removeAt(0));
        if (object[currentKey].length > index) {
          object[currentKey][index] = (_dotNotationToMap(
              object[currentKey][index], keys.join('.'), value));
        } else {
          object[currentKey].add(_dotNotationToMap({}, keys.join('.'), value));
        }
      } else {
        object[currentKey] =
            _dotNotationToMap(object[currentKey], keys.join('.'), value);
      }
    }

    return object;
  }

  Map<String, dynamic> fromDotNotation(String key, dynamic value) {
    return _dotNotationToMap(this, key, value);
    // final keys = key.split('.');
    // final currentKey = keys.removeAt(0);

    // final object = {...this};

    // if (keys.isEmpty) {
    //   object[currentKey] = value;
    // } else {
    //   object.remove(key);
    //   final nextKey = keys.first;

    //   if (object[currentKey] == null) {
    //     final intNextKey = int.tryParse(nextKey);
    //     if (intNextKey != null) {
    //       object[currentKey] = [];
    //     } else {
    //       object[currentKey] = <String, dynamic>{};
    //     }
    //   }

    //   if (object[currentKey] is List) {
    //     final index = int.parse(keys.removeAt(0));
    //     if (object[currentKey].length > index) {
    //       object[currentKey][index] =
    //           object[currentKey][index].fromDotNotation(keys.join('.'), value);
    //     } else {
    //       object[currentKey]
    //           .add(<String, dynamic>{}.fromDotNotation(keys.join('.'), value));
    //     }
    //   } else {
    //     object[currentKey] =
    //         object[currentKey].fromDotNotation(keys.join('.'), value);
    //   }
    // }

    // return object;
  }

  Map<String, dynamic> toFlatten() {
    Map<String, dynamic> result = {};

    void flattenMapRecursively(Map map, {String prefix = ''}) {
      map.forEach((key, value) {
        final newKey = prefix.isEmpty ? key : '$prefix.$key';
        if (value is Map<String, dynamic>) {
          flattenMapRecursively(value, prefix: newKey);
        } else if (value is List) {
          if (value.isEmpty) {
            result[newKey] = value;
          } else {
            if (value.first is Map) {
              for (int i = 0; i < value.length; i++) {
                final listKey = '$newKey.$i';
                if (value[i] is Map<String, dynamic>) {
                  flattenMapRecursively(value[i], prefix: listKey);
                } else {
                  result[listKey] = value[i];
                }
              }
            } else {
              result[newKey] = value;
            }
          }
        } else {
          result[newKey] = value;
        }
      });
    }

    flattenMapRecursively(this);

    return result;
  }

  Map<String, dynamic> convertNumbersToStrings() {
    final inputMap = this;
    Map<String, dynamic> stringMap = {};

    for (final key in inputMap.keys) {
      dynamic value = inputMap[key];
      if (value is Map<String, dynamic>) {
        /// if the value is a nested map, recursively convert it
        stringMap[key] = value.convertNumbersToStrings();
      } else {
        /// otherwise, convert the value to a string
        if (value is num?) {
          if (value == null) {
            stringMap[key] = '';
          } else {
            stringMap[key] = value.toString();
          }
        } else {
          stringMap[key] = value;
        }
      }
      // else if (value is List) {
      //   // If the value is a list, recursively convert its elements
      //   stringMap[key] = value.map((element) {
      //     if (element is Map<String, dynamic>) {
      //       return element.convertNumbersToStrings();
      //     } else {
      //       if (element is num?) {
      //         if (element == null) {
      //           return '';
      //         } else {
      //           return element.toString();
      //         }
      //       } else {
      //         return element;
      //       }
      //     }
      //   }).toList();
      // }
    }

    return stringMap;
  }
}

extension MapExtensions on Map {
  Object? valueFor(String keyPath) {
    final keysSplit = keyPath.split('.');
    final thisKey = keysSplit.removeAt(0);
    final thisValue = this[thisKey];
    if (keysSplit.isEmpty) {
      return thisValue;
    } else if (thisValue is Map) {
      return thisValue.valueFor(keysSplit.join('.'));
    } else if (thisValue is List) {
      return thisValue.valueFor(keysSplit.join('.'));
    }
    return thisValue;
  }
}
