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

class _ArmyPreviewListState extends State<ArmyPreviewList>
    with DismissableListMixin<Army, ArmyPreviewList> {
  @override
  build(context) {
    return ListView(
      children: visibleEntities(widget.armies).map((army) {
        return wrapDismiss(
          context,
          army,
          ArmyPreviewTile(
            army: army,
            onPressed: () => widget.onPressed(army),
          ),
        );
      }).toList(),
    );
  }

  @override
  labelEntity(entity) => 'Removed "${entity.name}"';

  @override
  persistDelete(entity) {
    widget.onDelete(entity);
  }
}
