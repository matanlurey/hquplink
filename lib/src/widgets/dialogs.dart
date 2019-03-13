import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
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
        title: isExisting ? const Text('Edit') : const Text('Add'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: army.name.isNotEmpty && army.faction != null
                ? () {
                    print(army.build());
                  }
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
              RadioListTile<Faction>(
                title: const Text('Imperials'),
                value: Faction.imperials,
                groupValue: army.faction,
                onChanged: (faction) {
                  setState(() => army.faction = faction);
                },
              ),
              RadioListTile<Faction>(
                title: const Text('Rebels'),
                value: Faction.rebels,
                groupValue: army.faction,
                onChanged: (faction) {
                  setState(() => army.faction = faction);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
