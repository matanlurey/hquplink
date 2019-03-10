import 'package:built_collection/built_collection.dart';

/// Returns [values] converted into a [BuiltListMultimap].
BuiltListMultimap<S, T> groupBy<S, T>(Iterable<T> values, S Function(T) key) {
  final builder = ListMultimapBuilder<S, T>();
  for (final value in values) {
    builder.add(key(value), value);
  }
  return builder.build();
}

/// Returns [values] converted into a [BuiltSetMultimap].
BuiltSetMultimap<S, T> groupBySet<S, T>(Iterable<T> values, S Function(T) key) {
  final builder = SetMultimapBuilder<S, T>();
  for (final value in values) {
    builder.add(key(value), value);
  }
  return builder.build();
}
