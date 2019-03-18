import 'package:flutter/material.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';
import 'package:hquplink/common.dart';

Future<void> _previewAssetImage(
  BuildContext context,
  String key,
) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(key),
      );
    },
  );
}

/// Displays a preview dialog for seeing [card].
Future<void> previewCommandCard(
  BuildContext context,
  Reference<CommandCard> card,
) async {
  if (await assetExistsForCommand(card)) {
    return _previewAssetImage(context, 'assets/cards/commands/${card.id}.png');
  }
  final name = catalog.toCommandCard(card).name;
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Cannot preview "$name": Asset missing'),
  ));
  return null;
}

/// Displays a preview dialog for seeing [card].
Future<void> previewUnitCard(
  BuildContext context,
  Reference<Unit> card,
) async {
  if (await assetExistsForUnit(card)) {
    return _previewAssetImage(context, 'assets/cards/units/${card.id}.png');
  }
  final name = catalog.toUnit(card).name;
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Cannot preview "$name": Asset missing'),
  ));
  return null;
}

/// Displays a preview dialog for seeing [card].
Future<void> previewUpgradeCard(
  BuildContext context,
  Reference<Upgrade> card,
) async {
  if (await assetExistsForUpgrade(card)) {
    return _previewAssetImage(context, 'assets/cards/upgrades/${card.id}.png');
  }
  final name = catalog.toUpgrade(card).name;
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Cannot preview "$name": Asset missing'),
  ));
  return null;
}
