import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';

void _navigate(BuildContext context, WidgetBuilder build) {
  Navigator.push(context, MaterialPageRoute<void>(builder: build));
}

/// Top-level `"Browse"` page with links to parts of the catalog.
class BrowsePage extends StatelessWidget {
  const BrowsePage();

  @override
  build(context) {
    return Page(
      title: 'Browse',
      body: ListView(
        children: [
          ListTile(
            title: const Text('Commands'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) => const _BrowseCommandsByFaction());
            },
          ),
          ListTile(
            title: const Text('Keywords'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) => const _BrowseKeywordsByType());
            },
          ),
          ListTile(
            title: const Text('Units'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) => const _BrowseUnitsByFaction());
            },
          ),
          ListTile(
            title: const Text('Upgrades'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) => const _BrowseUpgradesByFaction());
            },
          ),
        ],
      ),
    );
  }
}

class _BrowseCommandsByFaction extends StatelessWidget {
  static final BuiltListMultimap<Faction, CommandCard> _factions = groupBy(
    catalog.commandCards,
    (c) => c.faction,
  );

  const _BrowseCommandsByFaction();

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commands'),
      ),
      body: ListView(
        children: _factions.asMap().entries.map((pair) {
          return ListTile(
            title: Text(toTitleCase(pair.key.name)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) => _BrowseCommandCards(cards: pair.value));
            },
          );
        }).toList(),
      ),
    );
  }
}

class _BrowseCommandCards extends StatelessWidget {
  final Iterable<CommandCard> cards;

  const _BrowseCommandCards({
    @required this.cards,
  }) : assert(cards != null);

  @override
  build(context) {
    void onTap(CommandCard card) => _onTap(context, card);
    final tiles = _groupByUnit(cards).asMap().entries.map(
      (entry) {
        final cards = entry.value.toList()..sort(_compareByPip);
        if (entry.key == null) {
          return CommandTileGroup.generic(
            cards: cards,
            onTap: onTap,
          );
        } else {
          return CommandTileGroup(
            cards: cards,
            unit: entry.key,
            onTap: onTap,
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commands'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList(),
      ),
    );
  }

  void _onTap(BuildContext context, CommandCard card) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/cards/commands/${card.id}.png'),
        );
      },
    );
  }

  static int _compareByPip(CommandCard a, CommandCard b) {
    return a.pips.compareTo(b.pips);
  }

  static BuiltListMultimap<Reference<Unit>, CommandCard> _groupByUnit(
    Iterable<CommandCard> cards,
  ) {
    return groupBy(cards, (c) => c.required.isEmpty ? null : c.required.first);
  }
}

class _BrowseKeywordsByType extends StatelessWidget {
  const _BrowseKeywordsByType();

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keywords'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Units'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) {
                return _BrowseKeywords(
                  title: const Text('Unit Keywords'),
                  keywords: UnitKeyword.values.toList(),
                );
              });
            },
          ),
          ListTile(
            title: const Text('Upgrades'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) {
                return _BrowseKeywords(
                  title: const Text('Upgrade Keywords'),
                  keywords: UpgradeKeyword.values.toList(),
                );
              });
            },
          ),
          ListTile(
            title: const Text('Weapons'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) {
                return _BrowseKeywords(
                  title: const Text('Weapon Keywords'),
                  keywords: WeaponKeyword.values.toList(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _BrowseKeywords<K extends Keyword<K>> extends StatelessWidget {
  static final _extraWhitespace = RegExp(r'\s\s+');

  final List<K> keywords;
  final Widget title;

  const _BrowseKeywords({
    @required this.keywords,
    @required this.title,
  })  : assert(keywords != null),
        assert(title != null);

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: ListView(
        children: keywords.map((k) {
          return ListTile(
            title: Text(k.displayName),
            subtitle: Text(k.description
                .replaceAll(_extraWhitespace, ' ')
                .replaceAll(' * ', ' ')),
          );
        }).toList(),
      ),
    );
  }
}

class _BrowseUnitsByFaction extends StatelessWidget {
  static final BuiltListMultimap<Faction, Unit> _factions = groupBy(
    catalog.units,
    (c) => c.faction,
  );

  const _BrowseUnitsByFaction();

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: _factions.asMap().entries.map((pair) {
          return ListTile(
            title: Text(toTitleCase(pair.key.name)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) {
                return _BrowseUnits(
                  cards: pair.value,
                  title: Text(toTitleCase(pair.key.name)),
                );
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class _BrowseUnits extends StatelessWidget {
  final Iterable<Unit> cards;
  final Widget title;

  const _BrowseUnits({
    @required this.cards,
    @required this.title,
  })  : assert(cards != null),
        assert(title != null);

  @override
  build(context) {
    void onTap(Unit card) => _onTap(context, card);
    final tiles = _groupByRank(cards).asMap().entries.toList()
      ..sort((a, b) => _sortByRank(a.key, b.key));
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles.map(
            (entry) {
              return UnitTileGroup(
                cards: entry.value.toList()
                  ..sort((a, b) => a.name.compareTo(b.name)),
                rank: entry.key,
                onTap: onTap,
              );
            },
          ),
        ).toList(),
      ),
    );
  }

  void _onTap(BuildContext context, Unit card) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/cards/units/${card.id}.png'),
        );
      },
    );
  }

  static BuiltListMultimap<Rank, Unit> _groupByRank(
    Iterable<Unit> cards,
  ) {
    return groupBy(cards, (c) => c.rank);
  }

  static int _sortByRank(Rank a, Rank b) {
    final aPos = _rankPosition(a);
    final bPos = _rankPosition(b);
    return aPos.compareTo(bPos);
  }

  static int _rankPosition(Rank rank) =>
      const {
        Rank.commander: 1,
        Rank.operative: 2,
        Rank.corps: 3,
        Rank.specialForces: 4,
        Rank.support: 5,
        Rank.heavy: 6,
      }[rank] ??
      10;
}

class _BrowseUpgradesByFaction extends StatelessWidget {
  const _BrowseUpgradesByFaction();

  @override
  build(context) {
    final factions = groupBy<Faction, Upgrade>(
      catalog.upgrades,
      (c) {
        var faction = Faction.neutral;
        if (c.restrictedToFaction != null) {
          faction = c.restrictedToFaction;
        } else if (c.restrictedToUnit.isNotEmpty) {
          faction = catalog.toUnit(c.restrictedToUnit.first).faction;
        }
        return faction;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: factions.asMap().entries.map((pair) {
          return ListTile(
            title: Text(toTitleCase(pair.key.name)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigate(context, (_) {
                return _BrowseUpgrades(
                  cards: pair.value,
                  title: Text(toTitleCase(pair.key.name)),
                );
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class _BrowseUpgrades extends StatelessWidget {
  final Iterable<Upgrade> cards;
  final Widget title;

  const _BrowseUpgrades({
    @required this.cards,
    @required this.title,
  })  : assert(cards != null),
        assert(title != null);

  @override
  build(context) {
    void onTap(Upgrade card) => _onTap(context, card);
    final entries = _groupBySlot(cards).asMap().entries;
    final tiles = entries.toList()..sort((a, b) => _sortBySlot(a.key, b.key));
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles.map(
            (entry) {
              return UpgradeTileGroup(
                cards: entry.value.toList()
                  ..sort((a, b) => a.name.compareTo(b.name)),
                slot: entry.key,
                onTap: onTap,
              );
            },
          ),
        ).toList(),
      ),
    );
  }

  void _onTap(BuildContext context, Upgrade card) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/cards/upgrades/${card.id}.png'),
        );
      },
    );
  }

  static BuiltListMultimap<UpgradeSlot, Upgrade> _groupBySlot(
    Iterable<Upgrade> cards,
  ) {
    return groupBy(cards, (c) => c.type);
  }

  static int _sortBySlot(UpgradeSlot a, UpgradeSlot b) {
    return a.name.compareTo(b.name);
  }
}
