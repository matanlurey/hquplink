import 'package:flutter/material.dart';

/// Represents a routable root page [Widget].
///
/// Pages that are deeper in the navigation hierarchy (or are meant to be in
/// dialogs) should not use this widget and should instead build a [Scaffold]
/// directly.
class Page extends StatelessWidget {
  @visibleForTesting
  static final Key appBarKey = UniqueKey();

  @visibleForTesting
  static final Key drawerKey = UniqueKey();

  @visibleForTesting
  static final Key buttonKey = UniqueKey();

  /// Body of the page.
  final Widget body;

  /// Title of the page.
  final String title;

  /// Floating action button for the page.
  final Widget floatingActionButton;

  const Page({
    @required this.title,
    @required this.body,
    this.floatingActionButton,
  }) : assert(title != null);

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        key: appBarKey,
      ),
      floatingActionButton: KeyedSubtree(
        child: floatingActionButton ?? Container(),
        key: buttonKey,
      ),
      drawer: Drawer(
        key: drawerKey,
        child: ListView(
          children: [
            ListTile(
              title: const Text('Armies'),
              leading: const Icon(Icons.view_list),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
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
      body: body,
    );
  }
}
