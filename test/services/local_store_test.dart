import 'package:flutter_test/flutter_test.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/src/services/roster.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';
import 'package:uuid/uuid.dart';

void main() {
  final unsavedEmptyImperials = Army((b) => b
    ..faction = Faction.imperials
    ..maxPoints = 800
    ..totalPoints = 0
    ..name = 'Imperial Army Regiment');

  final savedDarthVader = Squad((b) => b
    ..card = Units.darthVader
    ..id = 'SQUAD-VADER');

  test('adding armies should persist with a generated ID', () async {
    final store = LocalStore(
      idGenerator: const SimpleUuid(),
      onChanged: expectAsync1((_) {}, count: 1),
    );

    expect(unsavedEmptyImperials.id, isNull, reason: 'Not yet saved');
    expect(await store.armies().list().first, hasLength(0));

    final saved = await store.armies().update(unsavedEmptyImperials);
    expect(saved.id, 'ID-0', reason: 'Should assign an ID');
    expect(await store.armies().list().first, hasLength(1));
  });

  final saved501stLegion = Army((b) => b
    ..faction = Faction.imperials
    ..id = 'ID-501-LEGION'
    ..maxPoints = 800
    ..name = '501st Legion'
    ..totalPoints = Units.darthVader.points);

  test('deleting armies should clear persistence', () async {
    final store = LocalStore.from(
      LocalData(
        (b) => b..armies.add(saved501stLegion),
      ),
      onChanged: expectAsync1((_) {}, count: 1),
    );

    expect(await store.armies().list().first, hasLength(1));

    await store.armies().delete(saved501stLegion.toRef());
    expect(await store.armies().list().first, hasLength(0));
  });

  test('deleting armies should delete any related squads', () async {
    final army = saved501stLegion.toRef();
    final store = LocalStore.from(
      LocalData(
        (b) => b
          ..armies.add(saved501stLegion)
          ..squads.add(
            army,
            savedDarthVader,
          ),
      ),
      onChanged: expectAsync1((_) {}, count: 1),
    );

    expect(await store.squads(army).list().first, hasLength(1));

    await store.armies().delete(army);
    expect(await store.squads(army).list().first, hasLength(0));
  });

  test('adding squads should persist', () async {
    final army = saved501stLegion.toRef();
    final store = LocalStore.from(
      LocalData(
        (b) => b
          ..armies.add(saved501stLegion)
          ..squads.add(
            army,
            savedDarthVader,
          ),
      ),
      onChanged: expectAsync1((_) {}, count: 2),
    );

    expect(await store.squads(army).list().first, hasLength(1));

    final storms = Squad((b) => b..card = Units.stormtroopers);
    await store.squads(army).update(storms);
    expect(
      await store.squads(army).list().first,
      hasLength(2),
      reason: 'Stormtroopers should have been added',
    );

    final snows = Squad((b) => b..card = Units.snowtroopers);
    await store.squads(army).update(snows);
    expect(
      await store.squads(army).list().first,
      hasLength(3),
      reason: 'Snowtroopers should have been added',
    );
  });

  test('adding squads should aggregate totalPoints', () async {
    final army = saved501stLegion.toRef();
    final store = LocalStore.from(
      LocalData(
        (b) => b
          ..armies.add(saved501stLegion)
          ..squads.add(
            army,
            savedDarthVader,
          ),
      ),
      onChanged: expectAsync1((_) {}, count: 2),
    );

    final storms = Squad((b) => b..card = Units.stormtroopers);
    await store.squads(army).update(storms);

    // Validate Vader + Stormtroopers.
    var saved = await store.armies().fetch(army).first;
    expect(
      saved.totalPoints,
      Units.darthVader.points + Units.stormtroopers.points,
    );

    // Catches a bug where subsequent edits to an army did not trigger updates.
    final snows = Squad((b) => b..card = Units.snowtroopers);
    await store.squads(army).update(snows);

    // Validate Vader + Stormtroopers + Snowtroopers.
    saved = await store.armies().fetch(army).first;
    expect(
      saved.totalPoints,
      Units.darthVader.points +
          Units.stormtroopers.points +
          Units.snowtroopers.points,
    );
  });

  test('editing squads should aggregate totalPoints', () async {
    final army = saved501stLegion.toRef();
    final store = LocalStore.from(
      LocalData(
        (b) => b
          ..armies.add(saved501stLegion)
          ..squads.add(
            army,
            savedDarthVader,
          ),
      ),
      onChanged: expectAsync1((_) {}, count: 1),
    );

    final editedSquads = savedDarthVader.rebuild(
      (b) => b.upgrades.add(Upgrades.forceChoke),
    );
    await store.squads(army).update(editedSquads);

    final saved = await store.armies().fetch(army).first;
    expect(
      saved.totalPoints,
      Units.darthVader.points + Upgrades.forceChoke.points,
    );
  });

  test('deleting squads should aggregate totalPoints', () async {
    final army = saved501stLegion.toRef();
    final store = LocalStore.from(
      LocalData(
        (b) => b
          ..armies.add(saved501stLegion)
          ..squads.add(
            army,
            savedDarthVader,
          ),
      ),
      onChanged: expectAsync1((_) {}, count: 1),
    );

    await store.squads(army).delete(savedDarthVader.toRef());

    final saved = await store.armies().fetch(army).first;
    expect(await store.squads(army).list().first, hasLength(0));
    expect(
      saved.totalPoints,
      0,
    );
  });
}

class SimpleUuid implements Uuid {
  static var counter = 0;

  const SimpleUuid();

  @override
  Object noSuchMethod(_) => super.noSuchMethod(_);

  @override
  String v1({options}) => 'ID-${counter++}';
}
