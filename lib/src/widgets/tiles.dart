import 'package:flutter/material.dart';

export 'tiles/army_preview.dart';
export 'tiles/command_tile.dart';
export 'tiles/unit_tile.dart';
export 'tiles/upgrade_tile.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground();

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Row(
        children: const [
          Icon(Icons.delete),
          Icon(Icons.delete),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
