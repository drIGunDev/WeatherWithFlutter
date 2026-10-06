import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'location_db.g.dart';

class LocationTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();

  TextColumn get country => text()();

  TextColumn get countryCode => text()();

  TextColumn get city => text()();

  TextColumn get timezone => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LocationTable])
final class LocationDatabase extends _$LocationDatabase {
  static const String databaseName = 'location.sqlite';

  LocationDatabase([NativeDatabase? connection]) : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (m, from, to) async {},
  );

  Future<void> deleteEverything() => transaction(() async {
    await delete(locationTable).go();
  });

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File('${dbFolder.path}/$databaseName');
      file.parent.createSync(recursive: true);
      return NativeDatabase(file);
    });
  }
}
