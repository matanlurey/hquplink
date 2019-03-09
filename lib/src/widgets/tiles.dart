import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';

/// Creates a [ListTile] for a [CommandCard].
class CommandTile extends StatelessWidget {
  /// [CommandCard] being referenced for the tile.
  final Reference<CommandCard> card;

  /// When the tile is pressed.
  final void Function() onTap;

  const CommandTile({
    @required this.card,
    this.onTap,
  }) : assert(card != null);

  @override
  build(_) {
    final details = catalog.toCommandCard(card);
    return ListTile(
      leading: CommandIcon(card: details),
      trailing: Text('${details.pips}'),
      title: Text(details.name),
      subtitle: Text(details.activated),
      onTap: onTap,
    );
  }
}

/// Creates multiple [CommandTile]s for a given [Unit] as a header.
class CommandTileGroup extends StatelessWidget {
  /// Cards being rendered.
  final List<Reference<CommandCard>> cards;

  /// When [cards] is tapped.
  final void Function(CommandCard) onTap;

  factory CommandTileGroup(
      {@required Reference<Unit> unit,
      @required List<Reference<CommandCard>> cards,
      void Function(CommandCard) onTap}) = _UnitCommandTileGroup;

  CommandTileGroup.generic({
    @required this.cards,
    this.onTap,
  }) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(cards != null && cards.isNotEmpty);
  }

  @override
  build(context) {
    final header = <Widget>[
      Container(
        child: ListTile(
          title: buildHeaderTitle(context),
          leading: buildHeaderLeading(context),
        ),
        color: Theme.of(context).backgroundColor,
      ),
    ];
    final children = cards.map(
      (c) {
        return CommandTile(
          card: c,
          onTap: onTap == null ? null : () => onTap(catalog.toCommandCard(c)),
        );
      },
    ).toList();
    return Column(
      children: header + children,
    );
  }

  @protected
  Widget buildHeaderTitle(BuildContext context) {
    return const Text('Generic');
  }

  Widget buildHeaderLeading(BuildContext context) {
    return const CircleAvatar();
  }
}

class _UnitCommandTileGroup extends CommandTileGroup {
  final Reference<Unit> unit;

  _UnitCommandTileGroup({
    @required this.unit,
    @required List<Reference<CommandCard>> cards,
    void Function(CommandCard) onTap,
  })  : assert(unit != null),
        super.generic(
          cards: cards,
          onTap: onTap,
        );

  @override
  buildHeaderTitle(context) {
    final details = catalog.toUnit(unit);
    return Text(details.name);
  }

  @override
  buildHeaderLeading(_) {
    return UnitIcon(card: unit);
  }
}
