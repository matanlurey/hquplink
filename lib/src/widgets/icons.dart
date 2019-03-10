import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class CommandIcon extends StatelessWidget {
  /// [CommandCard] being referenced for the icon.
  final Reference<CommandCard> card;

  const CommandIcon({
    @required this.card,
  }) : assert(card != null);

  @override
  build(_) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/cards/commands/${card.id}.thumb.png'),
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
    return CircleAvatar(
      backgroundImage: AssetImage('assets/cards/units/${card.id}.thumb.png'),
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
    return CircleAvatar(
      backgroundImage: AssetImage('assets/cards/upgrades/${card.id}.thumb.png'),
    );
  }
}
