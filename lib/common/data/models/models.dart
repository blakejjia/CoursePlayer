import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'models.g.dart';

@DataClassName('Song')
class Songs extends Table{
  IntColumn get id => integer().autoIncrement()();
  /// ---------- basic information -----------
  TextColumn get artist => text()();
  TextColumn get title => text()();
  IntColumn get length => integer()();
  IntColumn get imageId => integer()();
  /// ---------- playlist & sort information -----------

  /// name of head folder at indexing folder
  TextColumn get album => text()();

  /// the name of closest folder, used for sorting
  TextColumn get parts => text()();

  /// ---------- file information -----------
  TextColumn get path => text()();

  /// ---------- user information -----------
  IntColumn get playedInSecond => integer()();
}

/// [Album] is the main table of the app
/// containing information about playlists
/// Specific load rules can be found in [load_from_file.dart]
@DataClassName("Album")
class Albums extends Table{
  IntColumn get id => integer().autoIncrement()();
  /// ---------- basic information -----------

  /// title is the name of the playlist
  /// written based on dictionary name
  TextColumn get title => text()();

  /// author is the author of the playlist
  /// written based on mp3 tag
  /// TODO: function to change author of a playlist
  TextColumn get author => text()();

  /// ImageId is the id of the cover image
  /// use to query the cover image, which is stored in the cover table
  IntColumn get imageId => integer()();

  /// sourcePath is the path of the playlist file
  /// will be queried when startup
  /// In this way keep the playlist file in the same directory as the music files
  TextColumn get sourcePath => text()();

  /// -------- user information -------------
  /// lastPlayed is the timestamp of the last played song
  /// for ordering playlist in the playlists page
  IntColumn get lastPlayedTime => integer()();

  /// lastPlayedIndex is the index of the last played song
  /// for continue playing function
  IntColumn get lastPlayedIndex => integer()();

  /// totalTracks is the total number of tracks in the playlist
  /// for showing the total number of tracks in the playlist
  IntColumn get totalTracks => integer()();

  /// playedTracks is the number of tracks that have been played
  /// for showing the progress of the playlist
  /// TODO: function to change the playedTracks
  IntColumn get playedTracks => integer()();
}

@DataClassName("Cover")
class Covers extends Table{
  IntColumn get id => integer().autoIncrement()();
  BlobColumn get cover => blob()(); // 使用Blob存储图片的二进制数据
  TextColumn get hash => text()(); // 使用hash来检测图片是否重复
}

@DriftDatabase(tables:[Songs, Covers, Albums])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lemon.db');
  }
}