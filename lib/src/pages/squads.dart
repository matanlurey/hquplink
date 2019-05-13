import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/src/services/roster.dart';
import 'package:hquplink/widgets.dart';

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
    return Page(
      body: StreamBuilder<List<Squad>>(
        // TODO: Avoid FOUC by pre-fetching?
        initialData: const [],
        stream: _units,
        builder: (context, snapshot) {
          // TOOD: Implement.
          return Container();
        },
      ),
      title: widget.army.name,
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
