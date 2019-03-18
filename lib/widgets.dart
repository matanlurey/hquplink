export 'src/widgets/dialogs.dart';
export 'src/widgets/icons.dart';
export 'src/widgets/page.dart';
export 'src/widgets/tiles.dart';

final _matcher = RegExp(r'[_.\- ]+(\w|$)');

/// Converts a `hyphen-case` [input] string to `'Title Case'`.
String toTitleCase(String input) {
  final replaced = input.replaceAllMapped(
    _matcher,
    (m) => m.group(0).toUpperCase(),
  );
  final result = replaced[0].toUpperCase() + replaced.substring(1);
  return result.replaceAll('-', ' ');
}

