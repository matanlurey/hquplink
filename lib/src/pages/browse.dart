import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const _BrowseCommandsByFaction(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Keywords'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Units'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Upgrades'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _BrowseCommandsByFaction extends StatelessWidget {
  static final BuiltListMultimap<Faction, CommandCard> _factions = () {
    final builder = ListMultimapBuilder<Faction, CommandCard>();
    for (final faction in Faction.values) {
      builder.addValues(
        faction,
        catalog.commandCards.where((c) => c.faction == faction),
      );
    }
    return builder.build();
  }();

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
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) {
                    return _BrowseCommandCards(
                      cards: pair.value,
                    );
                  },
                ),
              );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commands'),
      ),
      body: ListView(
        children: cards.map((card) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/cards/commands/${card.id}.thumb.png',
              ),
            ),
            title: Text(card.name),
          );
        }).toList(),
      ),
    );
  }
}
