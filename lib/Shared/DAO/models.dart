import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'models.g.dart';

@DataClassName('Song')
class Songs extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get artist => text()();
  TextColumn get title => text()();
  TextColumn get playlist => text()(); // playlist Id
  IntColumn get length => integer()();
  IntColumn get imageId => integer()(); // utf-8 encoded Uint8List
  TextColumn get path => text()();
}

@DataClassName("Cover")
class Covers extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get image => text()();
}

@DataClassName("Playlist")
class Playlists extends Table{
  TextColumn get title => text()();
  TextColumn get author => text()();
  IntColumn get imageId => integer()();
}

@DriftDatabase(tables:[Songs, Covers,Playlists])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }
}