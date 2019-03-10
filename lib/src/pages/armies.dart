import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';

class ArmiesPage extends StatelessWidget {
  const ArmiesPage();

  @override
  build(context) {
    return Page(
      body: Container(),
      title: 'Armies',
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Implement.
        },
      ),
    );
  }
}
