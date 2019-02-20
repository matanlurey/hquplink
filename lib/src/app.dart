import 'package:flutter/material.dart';

class HQUplinkApp extends StatefulWidget {
  static final Key appBarKey = UniqueKey();
  static final Key drawerKey = UniqueKey();

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

  static Widget _routeArmies(BuildContext _) {
    return const _MainPage(
      title: 'Armies',
    );
  }

  static Widget _routeBrowse(BuildContext _) {
    return const _MainPage(
      title: 'Browse',
    );
  }
}

class _MainPage extends StatelessWidget {
  final String title;

  const _MainPage({
    @required this.title,
  }) : assert(title != null);

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        key: HQUplinkApp.appBarKey,
      ),
      drawer: Drawer(
        key: HQUplinkApp.drawerKey,
        child: ListView(
          children: [
            ListTile(
                title: const Text('Armies'),
                leading: const Icon(Icons.view_list),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                }),
            ListTile(
              title: const Text('Browse'),
              leading: const Icon(Icons.search),
              onTap: () {
                Navigator.pushNamed(context, '/browse');
              },
            ),
          ],
        ),
      ),
    );
  }
}
