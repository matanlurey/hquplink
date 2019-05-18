import 'dart:convert';
import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:flutter/widgets.dart';
import 'package:hquplink/models.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'src/app.dart';
import 'src/services/roster.dart';

void main() async {
  // TODO: Encapsulate this all in a configurable service.
  final jsonPath = p.join(
    (await getApplicationDocumentsDirectory()).path,
    'hquplink.json',
  );
  final jsonFile = File(jsonPath);

  var initialData = LocalData((_) {});
  if (await jsonFile.exists()) {
    final jsonText = await jsonFile.readAsString();
    try {
      initialData = appSerializers.deserializeWith(
        LocalData.serializer,
        jsonDecode(jsonText),
      );
      print(
        'Loaded initialData (${jsonText.length} bytes) from ${jsonFile.path}',
      );
    } on DeserializationError catch (e, s) {
      print('Failed to deserialize: $e\n$s');
    }
  } else {
    print('No initialData found (${jsonFile.path})');
  }

  runApp(HQUplinkApp(
    dataStore: LocalStore.from(
      initialData,
      onChanged: (newData) async {
        final jsonData = appSerializers.serializeWith(
          LocalData.serializer,
          newData,
        );
        final jsonText = jsonEncode(jsonData);
        print('Saved ${jsonText.length} bytes to disk');
        await jsonFile.writeAsString(jsonText);
      },
    ),
  ));
}
