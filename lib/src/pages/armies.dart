import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/src/services/roster.dart';
import 'package:hquplink/widgets.dart';

import 'squads.dart';

class ArmiesPage extends StatefulWidget {
  const ArmiesPage();

  @override
  createState() => _ArmiesPageState();
}

class _ArmiesPageState extends State<ArmiesPage> {
  /// Currentlty displayed army list.
  var _armies = const Stream<List<Army>>.empty();

  /// Handle to the currently active [DataStore].
  DataStore _store;

  @override
  didChangeDependencies() {
    final store = DataStore.of(context);
    if (store != _store) {
      _store = store;
      _armies = store.armies().list();
    }
    super.didChangeDependencies();
  }

  @override
  build(context) {
    return Page(
      body: StreamBuilder<List<Army>>(
        // TODO: Avoid FOUC  by pre-fetching?
        initialData: const [],
        stream: _armies,
        builder: (context, snapshot) {
          print('>>> builder: ${snapshot.data.map((a) => a.name)}');
          return ArmyPreviewList(
            armies: snapshot.data,
            onDelete: (army) {
              print('>>> onDelete(${army.name})');
              _store.armies().delete(army.toRef());
            },
            onPressed: (army) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => SquadsPage(army: army),
                ),
              );
            },
          );
        },
      ),
      title: 'Armies',
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newArmy = await ArmyMetaDialog.show(context);
          if (newArmy != null) {
            await DataStore.of(context).armies().update(newArmy);
          }
        },
      ),
    );
  }
}
