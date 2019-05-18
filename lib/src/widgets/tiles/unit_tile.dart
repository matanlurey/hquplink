import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';

/// Creates multiple [Unit]s for a given [Rank] as a header.
class UnitTileGroup extends StatelessWidget {
  /// Cards being rendered.
  final List<Reference<Unit>> cards;

  /// Rank being displayed.
  final Rank rank;

  /// When [cards] is tapped.
  final void Function(Unit) onTap;

  UnitTileGroup({
    @required this.cards,
    @required this.rank,
    this.onTap,
  }) : assert(rank != null) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(cards != null && cards.isNotEmpty);
  }

  @override
  build(context) {
    final header = <Widget>[
      Container(
        child: RankTile(rank: rank),
        color: Theme.of(context).backgroundColor,
      ),
    ];
    final children = cards.map(
      (c) {
        return UnitTile(
          card: c,
          onTap: onTap == null ? null : () => onTap(catalog.toUnit(c)),
        );
      },
    ).toList();
    return Column(
      children: header + children,
    );
  }
}

class RankTile extends StatelessWidget {
  // TODO: Encapsulate this in a better manner.
  static const _ruleSet = {
    Rank.commander: '1 - 2',
    Rank.operative: '0 - 2',
    Rank.corps: '3 - 6',
    Rank.specialForces: '0 - 3',
    Rank.support: '0 - 3',
    Rank.heavy: '0 - 2',
  };

  /// Rank being displayed.
  final Rank rank;

  /// Whether to show a `+` button instead of the rules for the rank.
  final void Function() onPressed;

  const RankTile({
    @required this.rank,
    this.onPressed,
  }) : assert(rank != null);

  @override
  build(context) {
    return ListTile(
      title: Text(
        toTitleCase(rank.name),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(_ruleSet[rank]),
      leading: CircleAvatar(
        // TODO: Use an icon instead.
        child: Text(rank.name[0].toUpperCase()),
      ),
      onTap: onPressed,
    );
  }
}
