import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:swlegion/swlegion.dart';

/// Returns whether an asset for [card] exists.
Future<bool> assetExistsForCommand(
  Reference<CommandCard> card, [
  AssetBundle bundle,
]) async {
  bundle ??= rootBundle;
  try {
    await bundle.load('assets/cards/commands/${card.id}.png');
    return true;
  } on Object catch (_) {
    return false;
  }
}

/// Returns whether an asset for [card] exists.
Future<bool> assetExistsForUnit(
  Reference<Unit> card, [
  AssetBundle bundle,
]) async {
  bundle ??= rootBundle;
  try {
    await bundle.load('assets/cards/units/${card.id}.png');
    return true;
  } on Object catch (_) {
    return false;
  }
}

/// Returns whether an asset for [card] exists.
Future<bool> assetExistsForUpgrade(
  Reference<Upgrade> card, [
  AssetBundle bundle,
]) async {
  bundle ??= rootBundle;
  try {
    await bundle.load('assets/cards/upgrades/${card.id}.png');
    return true;
  } on Object catch (_) {
    return false;
  }
}

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
