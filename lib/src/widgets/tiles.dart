import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

export 'tiles/army_preview.dart';
export 'tiles/command_tile.dart';
export 'tiles/unit_tile.dart';
export 'tiles/upgrade_tile.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground();

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Row(
        children: const [
          Icon(Icons.delete),
          Icon(Icons.delete),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

mixin DismissableListMixin<T extends Indexable<T>, S extends StatefulWidget>
    on State<S> {
  final Set<Reference<T>> _dismissed = {};

  void _onDismissed(BuildContext context, T entity) async {
    setState(() {
      _dismissed.add(entity.toRef());
    });
    final controller = Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(labelEntity(entity)),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Intentionally left blank.
          },
        ),
      ),
    );
    if (await controller.closed != SnackBarClosedReason.action) {
      persistDelete(entity);
    }
    setState(() {
      _dismissed.remove(entity.toRef());
    });
  }

  @protected
  Key createKey(T entity) => Key(entity.id);

  @protected
  String labelEntity(T entity);

  @protected
  void persistDelete(T entity);

  @protected
  Dismissible wrapDismiss(BuildContext context, T entity, Widget child) {
    return Dismissible(
      child: child,
      key: createKey(entity),
      background: const DismissBackground(),
      onDismissed: (_) => _onDismissed(context, entity),
    );
  }

  @protected
  Iterable<T> visibleEntities(Iterable<T> allItems) {
    return allItems.where((i) => !_dismissed.contains(i.toRef()));
  }
}
