import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage();

  @override
  build(context) {
    return Page(
      title: 'Browse',
      body: ListView(
        children: [
          ListTile(
            title: const Text('Commands'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Keywords'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Units'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Upgrades'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
