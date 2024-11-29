import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:built_value/built_value.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
abstract class Song implements Built<Song, SongBuilder> {
  // Hive fields
  @HiveField(0)
  int get id;

  @HiveField(2)
  String get artist;

  @HiveField(1)
  String get title;

  @HiveField(4)
  String get playlist;

  @HiveField(3)
  int get length;

  @HiveField(5)
  int get imageId;

  @HiveField(6)
  String get path;

  // Constructor
  Song._();
  factory Song([void Function(SongBuilder) updates]) = _$Song;
}

@HiveType(typeId: 1)
abstract class Cover implements Built<Cover, CoverBuilder> {
  // Hive fields
  @HiveField(0)
  int get id;

  @HiveField(1)
  Uint8List get cover; // 图片的二进制数据用 BuiltList<int> 存储

  @HiveField(2)
  String get hash; // SHA256 字符串表示

  // Constructor
  Cover._();
  factory Cover([void Function(CoverBuilder) updates]) = _$Cover;
}

@HiveType(typeId: 2)
abstract class Playlist implements Built<Playlist, PlaylistBuilder> {
  // Hive fields
  @HiveField(0)
  int get id;

  @HiveField(1)
  String get title;

  @HiveField(2)
  String get author;

  @HiveField(3)
  int get imageId;

  // Constructor
  Playlist._();
  factory Playlist([void Function(PlaylistBuilder) updates]) = _$Playlist;
}
