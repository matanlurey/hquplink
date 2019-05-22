import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/src/services/roster.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';

class SquadsPage extends StatefulWidget {
  final Army army;

  const SquadsPage({
    this.army,
  });

  @override
  createState() => _SquadsPageState();
}

class _SquadsPageState extends State<SquadsPage>
    with DismissableListMixin<Squad, SquadsPage> {
  /// Currentlty displayed units for the army.
  var _units = const Stream<List<Squad>>.empty();

  /// Handle to the currently active [DataStore].
  DataStore _store;

  @override
  didChangeDependencies() {
    final store = DataStore.of(context);
    if (store != _store) {
      _store = store;
      _units = store.squads(widget.army.toRef()).list();
    }
    super.didChangeDependencies();
  }

  @override
  labelEntity(entity) => 'Removed ${catalog.toUnit(entity.card).name}';

  @override
  persistDelete(entity) async {
    await DataStore.of(context)
        .squads(widget.army.toRef())
        .delete(entity.toRef());
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.army.name),
      ),
      body: StreamBuilder<List<Squad>>(
        // TODO: Avoid FOUC by pre-fetching?
        initialData: const [],
        stream: _units,
        builder: (context, snapshot) {
          return ListView(
            children: Rank.values.map((rank) {
              final header = Container(
                child: RankTile(
                  rank: rank,
                  onPressed: () async {
                    final toAdd = await Navigator.push(
                      context,
                      MaterialPageRoute<Unit>(
                        builder: (_) {
                          return _AddUnitDialog(
                            faction: widget.army.faction,
                            rank: rank,
                            uniques: snapshot.data
                                .map((s) => catalog.toUnit(s.card))
                                .where((u) => u.isUnique)
                                .toSet(),
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                    if (toAdd != null) {
                      await DataStore.of(context)
                          .squads(widget.army.toRef())
                          .update(Squad((b) => b.card = toAdd));
                    }
                  },
                ),
                color: Theme.of(context).backgroundColor,
              );
              final units = snapshot.data
                  .where((s) => catalog.toUnit(s.card).rank == rank);
              final visible = visibleEntities(units)
                  .map((squad) => wrapDismiss(
                        context,
                        squad,
                        UnitTile(
                          card: squad.card,
                        ),
                      ))
                  .toList();
              return Column(
                children: <Widget>[header] + visible,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _AddUnitDialog extends StatelessWidget {
  static Iterable<Unit> _unitsByRank(Faction faction, Rank rank) {
    return catalog.units.where((unit) {
      return unit.faction == faction && unit.rank == rank;
    });
  }

  /// Faction to select units from.
  final Faction faction;

  /// Rank to select units from.
  final Rank rank;

  /// Unique units that cannot be selected.
  final Set<Unit> uniques;

  _AddUnitDialog({
    @required this.faction,
    @required this.rank,
    this.uniques = const {},
  })  : assert(faction != null),
        assert(rank != null),
        assert(uniques != null) {
    assert(() {
      for (final unique in uniques) {
        assert(unique.isUnique, '${unique.name} is not a unique unit.');
      }
      return true;
    }());
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${toTitleCase(rank.name)}'),
      ),
      body: ListView(
        children: _unitsByRank(faction, rank).map((unit) {
          // TODO: Grey-out invalid units.
          return UnitTile(
            card: unit,
            onTap: () {
              Navigator.pop(context, unit);
            },
            isDisabled: uniques.contains(unit),
          );
        }).toList(),
      ),
    );
  }
}
