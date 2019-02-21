import 'package:flutter/material.dart';

import 'pages/armies.dart';
import 'pages/browse.dart';

class HQUplinkApp extends StatefulWidget {
  const HQUplinkApp();

  @override
  createState() => _HQUplinkAppState();
}

class _HQUplinkAppState extends State<HQUplinkApp> {
  @override
  build(_) {
    return MaterialApp(
      title: 'HQ Uplink',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: const {
        '/': _routeArmies,
        '/browse': _routeBrowse,
      },
    );
  }

  static Widget _routeArmies(void _) {
    return const ArmiesPage();
  }

  static Widget _routeBrowse(void _) {
    return const BrowsePage();
  }
}
