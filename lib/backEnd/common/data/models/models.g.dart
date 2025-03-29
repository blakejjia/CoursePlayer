// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lengthMeta = const VerificationMeta('length');
  @override
  late final GeneratedColumn<int> length = GeneratedColumn<int>(
      'length', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _imageIdMeta =
      const VerificationMeta('imageId');
  @override
  late final GeneratedColumn<int> imageId = GeneratedColumn<int>(
      'image_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<int> album = GeneratedColumn<int>(
      'album', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partsMeta = const VerificationMeta('parts');
  @override
  late final GeneratedColumn<String> parts = GeneratedColumn<String>(
      'parts', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trackMeta = const VerificationMeta('track');
  @override
  late final GeneratedColumn<int> track = GeneratedColumn<int>(
      'track', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playedInSecondMeta =
      const VerificationMeta('playedInSecond');
  @override
  late final GeneratedColumn<int> playedInSecond = GeneratedColumn<int>(
      'played_in_second', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        artist,
        title,
        length,
        imageId,
        album,
        parts,
        track,
        path,
        playedInSecond
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('length')) {
      context.handle(_lengthMeta,
          length.isAcceptableOrUnknown(data['length']!, _lengthMeta));
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('image_id')) {
      context.handle(_imageIdMeta,
          imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta));
    } else if (isInserting) {
      context.missing(_imageIdMeta);
    }
    if (data.containsKey('album')) {
      context.handle(
          _albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    } else if (isInserting) {
      context.missing(_albumMeta);
    }
    if (data.containsKey('parts')) {
      context.handle(
          _partsMeta, parts.isAcceptableOrUnknown(data['parts']!, _partsMeta));
    } else if (isInserting) {
      context.missing(_partsMeta);
    }
    if (data.containsKey('track')) {
      context.handle(
          _trackMeta, track.isAcceptableOrUnknown(data['track']!, _trackMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('played_in_second')) {
      context.handle(
          _playedInSecondMeta,
          playedInSecond.isAcceptableOrUnknown(
              data['played_in_second']!, _playedInSecondMeta));
    } else if (isInserting) {
      context.missing(_playedInSecondMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      length: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}length'])!,
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id'])!,
      album: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album'])!,
      parts: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parts'])!,
      track: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}track']),
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      playedInSecond: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}played_in_second'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;

  /// ---------- basic information -----------
  final String artist;
  final String title;
  final int length;
  final int imageId;

  /// ---------- playlist & sort information -----------
  /// name of head folder at indexing folder
  final int album;

  /// the name of closest folder, used for sorting
  final String parts;

  /// Track number in the album
  final int? track;

  /// ---------- file information -----------
  final String path;

  /// ---------- user information -----------
  final int playedInSecond;
  const Song(
      {required this.id,
      required this.artist,
      required this.title,
      required this.length,
      required this.imageId,
      required this.album,
      required this.parts,
      this.track,
      required this.path,
      required this.playedInSecond});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['artist'] = Variable<String>(artist);
    map['title'] = Variable<String>(title);
    map['length'] = Variable<int>(length);
    map['image_id'] = Variable<int>(imageId);
    map['album'] = Variable<int>(album);
    map['parts'] = Variable<String>(parts);
    if (!nullToAbsent || track != null) {
      map['track'] = Variable<int>(track);
    }
    map['path'] = Variable<String>(path);
    map['played_in_second'] = Variable<int>(playedInSecond);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      artist: Value(artist),
      title: Value(title),
      length: Value(length),
      imageId: Value(imageId),
      album: Value(album),
      parts: Value(parts),
      track:
          track == null && nullToAbsent ? const Value.absent() : Value(track),
      path: Value(path),
      playedInSecond: Value(playedInSecond),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      artist: serializer.fromJson<String>(json['artist']),
      title: serializer.fromJson<String>(json['title']),
      length: serializer.fromJson<int>(json['length']),
      imageId: serializer.fromJson<int>(json['imageId']),
      album: serializer.fromJson<int>(json['album']),
      parts: serializer.fromJson<String>(json['parts']),
      track: serializer.fromJson<int?>(json['track']),
      path: serializer.fromJson<String>(json['path']),
      playedInSecond: serializer.fromJson<int>(json['playedInSecond']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'artist': serializer.toJson<String>(artist),
      'title': serializer.toJson<String>(title),
      'length': serializer.toJson<int>(length),
      'imageId': serializer.toJson<int>(imageId),
      'album': serializer.toJson<int>(album),
      'parts': serializer.toJson<String>(parts),
      'track': serializer.toJson<int?>(track),
      'path': serializer.toJson<String>(path),
      'playedInSecond': serializer.toJson<int>(playedInSecond),
    };
  }

  Song copyWith(
          {int? id,
          String? artist,
          String? title,
          int? length,
          int? imageId,
          int? album,
          String? parts,
          Value<int?> track = const Value.absent(),
          String? path,
          int? playedInSecond}) =>
      Song(
        id: id ?? this.id,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        length: length ?? this.length,
        imageId: imageId ?? this.imageId,
        album: album ?? this.album,
        parts: parts ?? this.parts,
        track: track.present ? track.value : this.track,
        path: path ?? this.path,
        playedInSecond: playedInSecond ?? this.playedInSecond,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      artist: data.artist.present ? data.artist.value : this.artist,
      title: data.title.present ? data.title.value : this.title,
      length: data.length.present ? data.length.value : this.length,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      album: data.album.present ? data.album.value : this.album,
      parts: data.parts.present ? data.parts.value : this.parts,
      track: data.track.present ? data.track.value : this.track,
      path: data.path.present ? data.path.value : this.path,
      playedInSecond: data.playedInSecond.present
          ? data.playedInSecond.value
          : this.playedInSecond,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('artist: $artist, ')
          ..write('title: $title, ')
          ..write('length: $length, ')
          ..write('imageId: $imageId, ')
          ..write('album: $album, ')
          ..write('parts: $parts, ')
          ..write('track: $track, ')
          ..write('path: $path, ')
          ..write('playedInSecond: $playedInSecond')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, artist, title, length, imageId, album,
      parts, track, path, playedInSecond);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.artist == this.artist &&
          other.title == this.title &&
          other.length == this.length &&
          other.imageId == this.imageId &&
          other.album == this.album &&
          other.parts == this.parts &&
          other.track == this.track &&
          other.path == this.path &&
          other.playedInSecond == this.playedInSecond);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> artist;
  final Value<String> title;
  final Value<int> length;
  final Value<int> imageId;
  final Value<int> album;
  final Value<String> parts;
  final Value<int?> track;
  final Value<String> path;
  final Value<int> playedInSecond;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.artist = const Value.absent(),
    this.title = const Value.absent(),
    this.length = const Value.absent(),
    this.imageId = const Value.absent(),
    this.album = const Value.absent(),
    this.parts = const Value.absent(),
    this.track = const Value.absent(),
    this.path = const Value.absent(),
    this.playedInSecond = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String artist,
    required String title,
    required int length,
    required int imageId,
    required int album,
    required String parts,
    this.track = const Value.absent(),
    required String path,
    required int playedInSecond,
  })  : artist = Value(artist),
        title = Value(title),
        length = Value(length),
        imageId = Value(imageId),
        album = Value(album),
        parts = Value(parts),
        path = Value(path),
        playedInSecond = Value(playedInSecond);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? artist,
    Expression<String>? title,
    Expression<int>? length,
    Expression<int>? imageId,
    Expression<int>? album,
    Expression<String>? parts,
    Expression<int>? track,
    Expression<String>? path,
    Expression<int>? playedInSecond,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (artist != null) 'artist': artist,
      if (title != null) 'title': title,
      if (length != null) 'length': length,
      if (imageId != null) 'image_id': imageId,
      if (album != null) 'album': album,
      if (parts != null) 'parts': parts,
      if (track != null) 'track': track,
      if (path != null) 'path': path,
      if (playedInSecond != null) 'played_in_second': playedInSecond,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? artist,
      Value<String>? title,
      Value<int>? length,
      Value<int>? imageId,
      Value<int>? album,
      Value<String>? parts,
      Value<int?>? track,
      Value<String>? path,
      Value<int>? playedInSecond}) {
    return SongsCompanion(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      title: title ?? this.title,
      length: length ?? this.length,
      imageId: imageId ?? this.imageId,
      album: album ?? this.album,
      parts: parts ?? this.parts,
      track: track ?? this.track,
      path: path ?? this.path,
      playedInSecond: playedInSecond ?? this.playedInSecond,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (length.present) {
      map['length'] = Variable<int>(length.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (album.present) {
      map['album'] = Variable<int>(album.value);
    }
    if (parts.present) {
      map['parts'] = Variable<String>(parts.value);
    }
    if (track.present) {
      map['track'] = Variable<int>(track.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (playedInSecond.present) {
      map['played_in_second'] = Variable<int>(playedInSecond.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('artist: $artist, ')
          ..write('title: $title, ')
          ..write('length: $length, ')
          ..write('imageId: $imageId, ')
          ..write('album: $album, ')
          ..write('parts: $parts, ')
          ..write('track: $track, ')
          ..write('path: $path, ')
          ..write('playedInSecond: $playedInSecond')
          ..write(')'))
        .toString();
  }
}

class $CoversTable extends Covers with TableInfo<$CoversTable, Cover> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<Uint8List> cover = GeneratedColumn<Uint8List>(
      'cover', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, cover, hash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'covers';
  @override
  VerificationContext validateIntegrity(Insertable<Cover> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    } else if (isInserting) {
      context.missing(_coverMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cover map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cover(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}cover'])!,
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
    );
  }

  @override
  $CoversTable createAlias(String alias) {
    return $CoversTable(attachedDatabase, alias);
  }
}

class Cover extends DataClass implements Insertable<Cover> {
  final int id;
  final Uint8List cover;
  final String hash;
  const Cover({required this.id, required this.cover, required this.hash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cover'] = Variable<Uint8List>(cover);
    map['hash'] = Variable<String>(hash);
    return map;
  }

  CoversCompanion toCompanion(bool nullToAbsent) {
    return CoversCompanion(
      id: Value(id),
      cover: Value(cover),
      hash: Value(hash),
    );
  }

  factory Cover.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cover(
      id: serializer.fromJson<int>(json['id']),
      cover: serializer.fromJson<Uint8List>(json['cover']),
      hash: serializer.fromJson<String>(json['hash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cover': serializer.toJson<Uint8List>(cover),
      'hash': serializer.toJson<String>(hash),
    };
  }

  Cover copyWith({int? id, Uint8List? cover, String? hash}) => Cover(
        id: id ?? this.id,
        cover: cover ?? this.cover,
        hash: hash ?? this.hash,
      );
  Cover copyWithCompanion(CoversCompanion data) {
    return Cover(
      id: data.id.present ? data.id.value : this.id,
      cover: data.cover.present ? data.cover.value : this.cover,
      hash: data.hash.present ? data.hash.value : this.hash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cover(')
          ..write('id: $id, ')
          ..write('cover: $cover, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, $driftBlobEquality.hash(cover), hash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cover &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.cover, this.cover) &&
          other.hash == this.hash);
}

class CoversCompanion extends UpdateCompanion<Cover> {
  final Value<int> id;
  final Value<Uint8List> cover;
  final Value<String> hash;
  const CoversCompanion({
    this.id = const Value.absent(),
    this.cover = const Value.absent(),
    this.hash = const Value.absent(),
  });
  CoversCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List cover,
    required String hash,
  })  : cover = Value(cover),
        hash = Value(hash);
  static Insertable<Cover> custom({
    Expression<int>? id,
    Expression<Uint8List>? cover,
    Expression<String>? hash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cover != null) 'cover': cover,
      if (hash != null) 'hash': hash,
    });
  }

  CoversCompanion copyWith(
      {Value<int>? id, Value<Uint8List>? cover, Value<String>? hash}) {
    return CoversCompanion(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cover.present) {
      map['cover'] = Variable<Uint8List>(cover.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoversCompanion(')
          ..write('id: $id, ')
          ..write('cover: $cover, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageIdMeta =
      const VerificationMeta('imageId');
  @override
  late final GeneratedColumn<int> imageId = GeneratedColumn<int>(
      'image_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourcePathMeta =
      const VerificationMeta('sourcePath');
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
      'source_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastPlayedTimeMeta =
      const VerificationMeta('lastPlayedTime');
  @override
  late final GeneratedColumn<int> lastPlayedTime = GeneratedColumn<int>(
      'last_played_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastPlayedIndexMeta =
      const VerificationMeta('lastPlayedIndex');
  @override
  late final GeneratedColumn<int> lastPlayedIndex = GeneratedColumn<int>(
      'last_played_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalTracksMeta =
      const VerificationMeta('totalTracks');
  @override
  late final GeneratedColumn<int> totalTracks = GeneratedColumn<int>(
      'total_tracks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _playedTracksMeta =
      const VerificationMeta('playedTracks');
  @override
  late final GeneratedColumn<int> playedTracks = GeneratedColumn<int>(
      'played_tracks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        author,
        imageId,
        sourcePath,
        lastPlayedTime,
        lastPlayedIndex,
        totalTracks,
        playedTracks
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('image_id')) {
      context.handle(_imageIdMeta,
          imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta));
    } else if (isInserting) {
      context.missing(_imageIdMeta);
    }
    if (data.containsKey('source_path')) {
      context.handle(
          _sourcePathMeta,
          sourcePath.isAcceptableOrUnknown(
              data['source_path']!, _sourcePathMeta));
    } else if (isInserting) {
      context.missing(_sourcePathMeta);
    }
    if (data.containsKey('last_played_time')) {
      context.handle(
          _lastPlayedTimeMeta,
          lastPlayedTime.isAcceptableOrUnknown(
              data['last_played_time']!, _lastPlayedTimeMeta));
    } else if (isInserting) {
      context.missing(_lastPlayedTimeMeta);
    }
    if (data.containsKey('last_played_index')) {
      context.handle(
          _lastPlayedIndexMeta,
          lastPlayedIndex.isAcceptableOrUnknown(
              data['last_played_index']!, _lastPlayedIndexMeta));
    } else if (isInserting) {
      context.missing(_lastPlayedIndexMeta);
    }
    if (data.containsKey('total_tracks')) {
      context.handle(
          _totalTracksMeta,
          totalTracks.isAcceptableOrUnknown(
              data['total_tracks']!, _totalTracksMeta));
    } else if (isInserting) {
      context.missing(_totalTracksMeta);
    }
    if (data.containsKey('played_tracks')) {
      context.handle(
          _playedTracksMeta,
          playedTracks.isAcceptableOrUnknown(
              data['played_tracks']!, _playedTracksMeta));
    } else if (isInserting) {
      context.missing(_playedTracksMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id'])!,
      sourcePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_path'])!,
      lastPlayedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_played_time'])!,
      lastPlayedIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_played_index'])!,
      totalTracks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_tracks'])!,
      playedTracks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}played_tracks'])!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;

  /// ---------- basic information -----------
  /// title is the name of the playlist
  /// written based on dictionary name
  final String title;

  /// author is the author of the playlist
  /// written based on mp3 tag
  final String author;

  /// ImageId is the id of the cover image
  /// use to query the cover image, which is stored in the cover table
  final int imageId;

  /// sourcePath is the path of the playlist file
  /// will be queried when startup
  /// In this way keep the playlist file in the same directory as the music files
  final String sourcePath;

  /// -------- user information -------------
  /// lastPlayed is the timestamp of the last played song
  /// for ordering playlist in the playlists page
  final int lastPlayedTime;

  /// lastPlayedIndex is the index of the last played song
  /// for continue playing function
  final int lastPlayedIndex;

  /// totalTracks is the total number of tracks in the playlist
  /// for showing the total number of tracks in the playlist
  final int totalTracks;

  /// playedTracks is the number of tracks that have been played
  /// for showing the progress of the playlist
  final int playedTracks;
  const Album(
      {required this.id,
      required this.title,
      required this.author,
      required this.imageId,
      required this.sourcePath,
      required this.lastPlayedTime,
      required this.lastPlayedIndex,
      required this.totalTracks,
      required this.playedTracks});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['image_id'] = Variable<int>(imageId);
    map['source_path'] = Variable<String>(sourcePath);
    map['last_played_time'] = Variable<int>(lastPlayedTime);
    map['last_played_index'] = Variable<int>(lastPlayedIndex);
    map['total_tracks'] = Variable<int>(totalTracks);
    map['played_tracks'] = Variable<int>(playedTracks);
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      imageId: Value(imageId),
      sourcePath: Value(sourcePath),
      lastPlayedTime: Value(lastPlayedTime),
      lastPlayedIndex: Value(lastPlayedIndex),
      totalTracks: Value(totalTracks),
      playedTracks: Value(playedTracks),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      imageId: serializer.fromJson<int>(json['imageId']),
      sourcePath: serializer.fromJson<String>(json['sourcePath']),
      lastPlayedTime: serializer.fromJson<int>(json['lastPlayedTime']),
      lastPlayedIndex: serializer.fromJson<int>(json['lastPlayedIndex']),
      totalTracks: serializer.fromJson<int>(json['totalTracks']),
      playedTracks: serializer.fromJson<int>(json['playedTracks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'imageId': serializer.toJson<int>(imageId),
      'sourcePath': serializer.toJson<String>(sourcePath),
      'lastPlayedTime': serializer.toJson<int>(lastPlayedTime),
      'lastPlayedIndex': serializer.toJson<int>(lastPlayedIndex),
      'totalTracks': serializer.toJson<int>(totalTracks),
      'playedTracks': serializer.toJson<int>(playedTracks),
    };
  }

  Album copyWith(
          {int? id,
          String? title,
          String? author,
          int? imageId,
          String? sourcePath,
          int? lastPlayedTime,
          int? lastPlayedIndex,
          int? totalTracks,
          int? playedTracks}) =>
      Album(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        imageId: imageId ?? this.imageId,
        sourcePath: sourcePath ?? this.sourcePath,
        lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
        lastPlayedIndex: lastPlayedIndex ?? this.lastPlayedIndex,
        totalTracks: totalTracks ?? this.totalTracks,
        playedTracks: playedTracks ?? this.playedTracks,
      );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      sourcePath:
          data.sourcePath.present ? data.sourcePath.value : this.sourcePath,
      lastPlayedTime: data.lastPlayedTime.present
          ? data.lastPlayedTime.value
          : this.lastPlayedTime,
      lastPlayedIndex: data.lastPlayedIndex.present
          ? data.lastPlayedIndex.value
          : this.lastPlayedIndex,
      totalTracks:
          data.totalTracks.present ? data.totalTracks.value : this.totalTracks,
      playedTracks: data.playedTracks.present
          ? data.playedTracks.value
          : this.playedTracks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('imageId: $imageId, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('lastPlayedIndex: $lastPlayedIndex, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('playedTracks: $playedTracks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, author, imageId, sourcePath,
      lastPlayedTime, lastPlayedIndex, totalTracks, playedTracks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.imageId == this.imageId &&
          other.sourcePath == this.sourcePath &&
          other.lastPlayedTime == this.lastPlayedTime &&
          other.lastPlayedIndex == this.lastPlayedIndex &&
          other.totalTracks == this.totalTracks &&
          other.playedTracks == this.playedTracks);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> author;
  final Value<int> imageId;
  final Value<String> sourcePath;
  final Value<int> lastPlayedTime;
  final Value<int> lastPlayedIndex;
  final Value<int> totalTracks;
  final Value<int> playedTracks;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.imageId = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.lastPlayedIndex = const Value.absent(),
    this.totalTracks = const Value.absent(),
    this.playedTracks = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String author,
    required int imageId,
    required String sourcePath,
    required int lastPlayedTime,
    required int lastPlayedIndex,
    required int totalTracks,
    required int playedTracks,
  })  : title = Value(title),
        author = Value(author),
        imageId = Value(imageId),
        sourcePath = Value(sourcePath),
        lastPlayedTime = Value(lastPlayedTime),
        lastPlayedIndex = Value(lastPlayedIndex),
        totalTracks = Value(totalTracks),
        playedTracks = Value(playedTracks);
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<int>? imageId,
    Expression<String>? sourcePath,
    Expression<int>? lastPlayedTime,
    Expression<int>? lastPlayedIndex,
    Expression<int>? totalTracks,
    Expression<int>? playedTracks,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (imageId != null) 'image_id': imageId,
      if (sourcePath != null) 'source_path': sourcePath,
      if (lastPlayedTime != null) 'last_played_time': lastPlayedTime,
      if (lastPlayedIndex != null) 'last_played_index': lastPlayedIndex,
      if (totalTracks != null) 'total_tracks': totalTracks,
      if (playedTracks != null) 'played_tracks': playedTracks,
    });
  }

  AlbumsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? author,
      Value<int>? imageId,
      Value<String>? sourcePath,
      Value<int>? lastPlayedTime,
      Value<int>? lastPlayedIndex,
      Value<int>? totalTracks,
      Value<int>? playedTracks}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageId: imageId ?? this.imageId,
      sourcePath: sourcePath ?? this.sourcePath,
      lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
      lastPlayedIndex: lastPlayedIndex ?? this.lastPlayedIndex,
      totalTracks: totalTracks ?? this.totalTracks,
      playedTracks: playedTracks ?? this.playedTracks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (lastPlayedTime.present) {
      map['last_played_time'] = Variable<int>(lastPlayedTime.value);
    }
    if (lastPlayedIndex.present) {
      map['last_played_index'] = Variable<int>(lastPlayedIndex.value);
    }
    if (totalTracks.present) {
      map['total_tracks'] = Variable<int>(totalTracks.value);
    }
    if (playedTracks.present) {
      map['played_tracks'] = Variable<int>(playedTracks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('imageId: $imageId, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('lastPlayedIndex: $lastPlayedIndex, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('playedTracks: $playedTracks')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $CoversTable covers = $CoversTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [songs, covers, albums];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required String artist,
  required String title,
  required int length,
  required int imageId,
  required int album,
  required String parts,
  Value<int?> track,
  required String path,
  required int playedInSecond,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<String> artist,
  Value<String> title,
  Value<int> length,
  Value<int> imageId,
  Value<int> album,
  Value<String> parts,
  Value<int?> track,
  Value<String> path,
  Value<int> playedInSecond,
});

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get album => $composableBuilder(
      column: $table.album, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parts => $composableBuilder(
      column: $table.parts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playedInSecond => $composableBuilder(
      column: $table.playedInSecond,
      builder: (column) => ColumnFilters(column));
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get album => $composableBuilder(
      column: $table.album, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parts => $composableBuilder(
      column: $table.parts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playedInSecond => $composableBuilder(
      column: $table.playedInSecond,
      builder: (column) => ColumnOrderings(column));
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<int> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get parts =>
      $composableBuilder(column: $table.parts, builder: (column) => column);

  GeneratedColumn<int> get track =>
      $composableBuilder(column: $table.track, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get playedInSecond => $composableBuilder(
      column: $table.playedInSecond, builder: (column) => column);
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> artist = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> length = const Value.absent(),
            Value<int> imageId = const Value.absent(),
            Value<int> album = const Value.absent(),
            Value<String> parts = const Value.absent(),
            Value<int?> track = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<int> playedInSecond = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            artist: artist,
            title: title,
            length: length,
            imageId: imageId,
            album: album,
            parts: parts,
            track: track,
            path: path,
            playedInSecond: playedInSecond,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String artist,
            required String title,
            required int length,
            required int imageId,
            required int album,
            required String parts,
            Value<int?> track = const Value.absent(),
            required String path,
            required int playedInSecond,
          }) =>
              SongsCompanion.insert(
            id: id,
            artist: artist,
            title: title,
            length: length,
            imageId: imageId,
            album: album,
            parts: parts,
            track: track,
            path: path,
            playedInSecond: playedInSecond,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()>;
typedef $$CoversTableCreateCompanionBuilder = CoversCompanion Function({
  Value<int> id,
  required Uint8List cover,
  required String hash,
});
typedef $$CoversTableUpdateCompanionBuilder = CoversCompanion Function({
  Value<int> id,
  Value<Uint8List> cover,
  Value<String> hash,
});

class $$CoversTableFilterComposer
    extends Composer<_$AppDatabase, $CoversTable> {
  $$CoversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnFilters(column));
}

class $$CoversTableOrderingComposer
    extends Composer<_$AppDatabase, $CoversTable> {
  $$CoversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnOrderings(column));
}

class $$CoversTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoversTable> {
  $$CoversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);
}

class $$CoversTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CoversTable,
    Cover,
    $$CoversTableFilterComposer,
    $$CoversTableOrderingComposer,
    $$CoversTableAnnotationComposer,
    $$CoversTableCreateCompanionBuilder,
    $$CoversTableUpdateCompanionBuilder,
    (Cover, BaseReferences<_$AppDatabase, $CoversTable, Cover>),
    Cover,
    PrefetchHooks Function()> {
  $$CoversTableTableManager(_$AppDatabase db, $CoversTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<Uint8List> cover = const Value.absent(),
            Value<String> hash = const Value.absent(),
          }) =>
              CoversCompanion(
            id: id,
            cover: cover,
            hash: hash,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required Uint8List cover,
            required String hash,
          }) =>
              CoversCompanion.insert(
            id: id,
            cover: cover,
            hash: hash,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CoversTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CoversTable,
    Cover,
    $$CoversTableFilterComposer,
    $$CoversTableOrderingComposer,
    $$CoversTableAnnotationComposer,
    $$CoversTableCreateCompanionBuilder,
    $$CoversTableUpdateCompanionBuilder,
    (Cover, BaseReferences<_$AppDatabase, $CoversTable, Cover>),
    Cover,
    PrefetchHooks Function()>;
typedef $$AlbumsTableCreateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  required String title,
  required String author,
  required int imageId,
  required String sourcePath,
  required int lastPlayedTime,
  required int lastPlayedIndex,
  required int totalTracks,
  required int playedTracks,
});
typedef $$AlbumsTableUpdateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> author,
  Value<int> imageId,
  Value<String> sourcePath,
  Value<int> lastPlayedTime,
  Value<int> lastPlayedIndex,
  Value<int> totalTracks,
  Value<int> playedTracks,
});

class $$AlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPlayedIndex => $composableBuilder(
      column: $table.lastPlayedIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTracks => $composableBuilder(
      column: $table.totalTracks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playedTracks => $composableBuilder(
      column: $table.playedTracks, builder: (column) => ColumnFilters(column));
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPlayedIndex => $composableBuilder(
      column: $table.lastPlayedIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTracks => $composableBuilder(
      column: $table.totalTracks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playedTracks => $composableBuilder(
      column: $table.playedTracks,
      builder: (column) => ColumnOrderings(column));
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
      column: $table.sourcePath, builder: (column) => column);

  GeneratedColumn<int> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime, builder: (column) => column);

  GeneratedColumn<int> get lastPlayedIndex => $composableBuilder(
      column: $table.lastPlayedIndex, builder: (column) => column);

  GeneratedColumn<int> get totalTracks => $composableBuilder(
      column: $table.totalTracks, builder: (column) => column);

  GeneratedColumn<int> get playedTracks => $composableBuilder(
      column: $table.playedTracks, builder: (column) => column);
}

class $$AlbumsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
    Album,
    PrefetchHooks Function()> {
  $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<int> imageId = const Value.absent(),
            Value<String> sourcePath = const Value.absent(),
            Value<int> lastPlayedTime = const Value.absent(),
            Value<int> lastPlayedIndex = const Value.absent(),
            Value<int> totalTracks = const Value.absent(),
            Value<int> playedTracks = const Value.absent(),
          }) =>
              AlbumsCompanion(
            id: id,
            title: title,
            author: author,
            imageId: imageId,
            sourcePath: sourcePath,
            lastPlayedTime: lastPlayedTime,
            lastPlayedIndex: lastPlayedIndex,
            totalTracks: totalTracks,
            playedTracks: playedTracks,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String author,
            required int imageId,
            required String sourcePath,
            required int lastPlayedTime,
            required int lastPlayedIndex,
            required int totalTracks,
            required int playedTracks,
          }) =>
              AlbumsCompanion.insert(
            id: id,
            title: title,
            author: author,
            imageId: imageId,
            sourcePath: sourcePath,
            lastPlayedTime: lastPlayedTime,
            lastPlayedIndex: lastPlayedIndex,
            totalTracks: totalTracks,
            playedTracks: playedTracks,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
    Album,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$CoversTableTableManager get covers =>
      $$CoversTableTableManager(_db, _db.covers);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
}
