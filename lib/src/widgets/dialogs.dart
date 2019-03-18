import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

export 'dialogs/preview.dart';

class ArmyMetaDialog extends StatefulWidget {
  static ArmyBuilder _defaultArmy() => ArmyBuilder()
    ..name = ''
    ..maxPoints = 800
    ..totalPoints = 0;

  static Future<Army> show(BuildContext context, {ArmyBuilder initialData}) {
    return Navigator.push(
      context,
      MaterialPageRoute<Army>(
        builder: (_) {
          return ArmyMetaDialog._(
            initialData: initialData ?? _defaultArmy(),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  final ArmyBuilder initialData;

  const ArmyMetaDialog._({
    @required this.initialData,
  }) : assert(initialData != null);

  @override
  createState() => _ArmyMetaDialogState();
}

class _ArmyMetaDialogState extends State<ArmyMetaDialog> {
  static final _formKey = GlobalKey<FormState>();

  ArmyBuilder army;
  TextEditingController name;

  /// Whether this is an existing [Army] being edited.
  bool get isExisting => army.id != null;

  @override
  initState() {
    army = widget.initialData;
    name = TextEditingController(text: army.name)
      ..addListener(() {
        setState(() {
          army.name = name.value.text;
        });
      });
    super.initState();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: isExisting ? const Text('Edit Army') : const Text('Add Army'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: army.name.isNotEmpty && army.faction != null
                ? () => Navigator.pop(context, army.build())
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                autofocus: true,
                autovalidate: false,
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Army name',
                ),
                style: Theme.of(context).textTheme.headline,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'A name is required';
                  }
                },
              ),
              _FactionSelector(
                onChanged: (faction) {
                  setState(() => army.faction = faction);
                },
                selected: army.faction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactionSelector extends StatelessWidget {
  /// Selected faction, if any.
  final Faction selected;

  /// Newly selected faction callback.
  final void Function(Faction) onChanged;

  const _FactionSelector({
    @required this.selected,
    @required this.onChanged,
  }) : assert(onChanged != null);

  @override
  build(_) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: const [Faction.imperials, Faction.rebels].map((faction) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Opacity(
              child: InkWell(
                child: FactionIcon(faction: faction),
                onTap: () {
                  onChanged(faction);
                },
              ),
              opacity: selected == faction ? 1.0 : 0.5,
            ),
          );
        }).toList(),
      ),
    );
  }
}
