import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

class ArmyPreviewTile extends StatelessWidget {
  final Army army;
  final void Function() onPressed;

  const ArmyPreviewTile({
    @required this.army,
    this.onPressed,
  }) : assert(army != null);

  @override
  build(_) {
    return ListTile(
      title: Text(army.name),
      subtitle: Text('${army.totalPoints} Points'),
      leading: FactionIcon(
        faction: army.faction,
      ),
      trailing: army.featuredUnits.isEmpty ? const Text('No Units') : null,
      onTap: onPressed,
    );
  }
}

class ArmyPreviewList extends StatefulWidget {
  /// Armies to render.
  final List<Army> armies;

  /// Callback invoked when an [Army] should be deleted.
  final void Function(Army) onDelete;

  /// Callback invoked when an [Army] should be activated.
  final void Function(Army) onPressed;

  const ArmyPreviewList({
    @required this.armies,
    @required this.onDelete,
    @required this.onPressed,
  })  : assert(armies != null),
        assert(onDelete != null),
        assert(onPressed != null);

  @override
  createState() => _ArmyPreviewListState();
}

class _ArmyPreviewListState extends State<ArmyPreviewList> {
  var visibleArmies = const <Army>[];

  @override
  void didUpdateWidget(_) {
    visibleArmies = widget.armies.toList();
    super.didUpdateWidget(_);
  }

  @override
  build(context) {
    return ListView(
      children: visibleArmies.map((army) {
        return Dismissible(
          child: ArmyPreviewTile(
            army: army,
            onPressed: () => widget.onPressed(army),
          ),
          key: Key(army.id),
          background: const DismissBackground(),
          onDismissed: (_) => _onDismissed(army),
        );
      }).toList(),
    );
  }

  // TODO: Encapsulate in a re-usable function and/or mixin.
  //
  // Also potentially worthy to encapsulate the entire widget concept.
  void _onDismissed(Army army) async {
    final index = visibleArmies.indexOf(army);
    setState(() {
      visibleArmies.removeAt(index);
    });
    final controller = Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${army.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Intentionally left blank.
          },
        ),
      ),
    );
    if (await controller.closed == SnackBarClosedReason.action) {
      setState(() {
        visibleArmies.insert(index, army);
      });
    } else {
      widget.onDelete(army);
    }
  }
}
