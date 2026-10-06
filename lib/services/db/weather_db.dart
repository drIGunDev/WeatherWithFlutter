import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'weather_db.g.dart';

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

  DateTimeColumn get weatherUpdatedAt => dateTime().nullable().withDefault(const Constant(null))();

  @override
  Set<Column> get primaryKey => {id};
}

class WeatherTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get start => dateTime()();

  DateTimeColumn get end => dateTime()();

  IntColumn get type => integer()();

  RealColumn get temperature => real()();

  RealColumn get apparentTemperature => real()();

  RealColumn get windForce => real()();

  RealColumn get windGusts => real()();

  RealColumn get windDirectionGrad => real()();

  RealColumn get precipitationPercent => real()();

  RealColumn get precipitationAmountMm => real()();

  RealColumn get rain => real()();

  TextColumn get locationId =>
      text().references(LocationTable, #id, onDelete: .cascade)();
}

@DriftDatabase(tables: [LocationTable, WeatherTable])
final class WeatherDatabase extends _$WeatherDatabase {
  static const String databaseName = 'weather.sqlite';

  WeatherDatabase([NativeDatabase? connection]) : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 1;

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
