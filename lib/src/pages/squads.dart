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

class _SquadsPageState extends State<SquadsPage> {
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
          // TOOD: Finish implemententation.
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
                  .where((s) => catalog.toUnit(s.card).rank == rank)
                  .map(
                    (squad) => UnitTile(card: squad.card),
                  )
                  .toList();
              return Column(
                children: <Widget>[header] + units,
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

  final Faction faction;
  final Rank rank;

  const _AddUnitDialog({
    @required this.faction,
    @required this.rank,
  })  : assert(faction != null),
        assert(rank != null);

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
          );
        }).toList(),
      ),
    );
  }
}
