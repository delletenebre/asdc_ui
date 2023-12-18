import 'map_extensions.dart';

/// Various extensions on lists of arbitrary elements.
extension ListExtensions<E> on List<E> {
  /// Maps each element and its index to a new value.
  Iterable<R> mapIndexed<R>(R Function(int index, E element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }

  Object? valueFor(String keyPath) {
    final keysSplit = keyPath.split('.');
    final thisKey = keysSplit.removeAt(0);
    final thisValue = this[int.parse(thisKey)];
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
