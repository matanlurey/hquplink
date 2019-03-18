import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/src/services/roster.dart';
import 'package:hquplink/widgets.dart';

class ArmiesPage extends StatefulWidget {
  const ArmiesPage();

  @override
  createState() => _ArmiesPageState();
}

class _ArmiesPageState extends State<ArmiesPage> {
  Stream<List<Army>> _armies = const Stream.empty();

  @override
  didChangeDependencies() {
    final store = DataStore.of(context);
    _armies = store.armies().list();
    super.didChangeDependencies();
  }

  @override
  build(context) {
    return Page(
      body: StreamBuilder<List<Army>>(
        initialData: const [],
        stream: _armies,
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data.map((army) {
              return ListTile(
                title: Text(army.name),
                leading: FactionIcon(
                  faction: army.faction,
                ),
              );
            }).toList(),
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
