import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'models.g.dart';

@DataClassName('Song')
class Songs extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get artist => text()();
  TextColumn get title => text()();
  TextColumn get playlist => text()();
  IntColumn get length => integer()();
  IntColumn get image => integer()(); // utf-8 encoded Uint8List
  TextColumn get path => text()();
}

@DataClassName("Image")
class Images extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get image => text()();
}

@DriftDatabase(tables:[Songs, Images])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }
}