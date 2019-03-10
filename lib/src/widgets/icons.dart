import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:swlegion/swlegion.dart';

class FallbackIcon extends StatelessWidget {
  /// Name of card being referenced without an asset.
  final Indexable<void> card;

  const FallbackIcon({
    @required this.card,
  }) : assert(card != null);

  @override
  build(_) {
    return CircleAvatar(
      child: Text(card.id[0].toUpperCase()),
    );
  }
}

class CommandIcon extends StatelessWidget {
  /// [CommandCard] being referenced for the icon.
  final Reference<CommandCard> card;

  const CommandIcon({
    @required this.card,
  }) : assert(card != null);

  @override
  build(_) {
    return FutureBuilder<bool>(
      future: assetExistsForCommand(card),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return CircleAvatar(
            backgroundImage: AssetImage(
              'assets/cards/commands/${card.id}.thumb.png',
            ),
          );
        } else {
          return FallbackIcon(card: card);
        }
      },
    );
  }
}

class UnitIcon extends StatelessWidget {
  /// [Unit] being referenced for the icon.
  final Reference<Unit> card;

  const UnitIcon({
    @required this.card,
  }) : assert(card != null);

  @override
  build(_) {
    return FutureBuilder<bool>(
      future: assetExistsForUnit(card),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return CircleAvatar(
            backgroundImage: AssetImage(
              'assets/cards/units/${card.id}.thumb.png',
            ),
          );
        } else {
          return FallbackIcon(card: card);
        }
      },
    );
  }
}

class UpgradeIcon extends StatelessWidget {
  /// [Upgrade] being referenced for the icon.
  final Reference<Upgrade> card;

  const UpgradeIcon({
    @required this.card,
  }) : assert(card != null);

  @override
  build(_) {
    return FutureBuilder<bool>(
      future: assetExistsForUpgrade(card),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return CircleAvatar(
            backgroundImage: AssetImage(
              'assets/cards/upgrades/${card.id}.thumb.png',
            ),
          );
        } else {
          return FallbackIcon(card: card);
        }
      },
    );
  }
}
