import 'package:flutter/widgets.dart';

import 'src/app.dart';
import 'src/services/roster.dart';

void main() {
  runApp(HQUplinkApp(
    dataStore: LocalStore(),
  ));
}
