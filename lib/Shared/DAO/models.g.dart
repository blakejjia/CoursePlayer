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
  static const VerificationMeta _playlistMeta =
      const VerificationMeta('playlist');
  @override
  late final GeneratedColumn<String> playlist = GeneratedColumn<String>(
      'playlist', aliasedName, false,
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
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, artist, title, playlist, length, imageId, path];
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
    if (data.containsKey('playlist')) {
      context.handle(_playlistMeta,
          playlist.isAcceptableOrUnknown(data['playlist']!, _playlistMeta));
    } else if (isInserting) {
      context.missing(_playlistMeta);
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
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
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
      playlist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}playlist'])!,
      length: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}length'])!,
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String artist;
  final String title;
  final String playlist;
  final int length;
  final int imageId;
  final String path;
  const Song(
      {required this.id,
      required this.artist,
      required this.title,
      required this.playlist,
      required this.length,
      required this.imageId,
      required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['artist'] = Variable<String>(artist);
    map['title'] = Variable<String>(title);
    map['playlist'] = Variable<String>(playlist);
    map['length'] = Variable<int>(length);
    map['image_id'] = Variable<int>(imageId);
    map['path'] = Variable<String>(path);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      artist: Value(artist),
      title: Value(title),
      playlist: Value(playlist),
      length: Value(length),
      imageId: Value(imageId),
      path: Value(path),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      artist: serializer.fromJson<String>(json['artist']),
      title: serializer.fromJson<String>(json['title']),
      playlist: serializer.fromJson<String>(json['playlist']),
      length: serializer.fromJson<int>(json['length']),
      imageId: serializer.fromJson<int>(json['imageId']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'artist': serializer.toJson<String>(artist),
      'title': serializer.toJson<String>(title),
      'playlist': serializer.toJson<String>(playlist),
      'length': serializer.toJson<int>(length),
      'imageId': serializer.toJson<int>(imageId),
      'path': serializer.toJson<String>(path),
    };
  }

  Song copyWith(
          {int? id,
          String? artist,
          String? title,
          String? playlist,
          int? length,
          int? imageId,
          String? path}) =>
      Song(
        id: id ?? this.id,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        playlist: playlist ?? this.playlist,
        length: length ?? this.length,
        imageId: imageId ?? this.imageId,
        path: path ?? this.path,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      artist: data.artist.present ? data.artist.value : this.artist,
      title: data.title.present ? data.title.value : this.title,
      playlist: data.playlist.present ? data.playlist.value : this.playlist,
      length: data.length.present ? data.length.value : this.length,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('artist: $artist, ')
          ..write('title: $title, ')
          ..write('playlist: $playlist, ')
          ..write('length: $length, ')
          ..write('imageId: $imageId, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, artist, title, playlist, length, imageId, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.artist == this.artist &&
          other.title == this.title &&
          other.playlist == this.playlist &&
          other.length == this.length &&
          other.imageId == this.imageId &&
          other.path == this.path);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> artist;
  final Value<String> title;
  final Value<String> playlist;
  final Value<int> length;
  final Value<int> imageId;
  final Value<String> path;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.artist = const Value.absent(),
    this.title = const Value.absent(),
    this.playlist = const Value.absent(),
    this.length = const Value.absent(),
    this.imageId = const Value.absent(),
    this.path = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String artist,
    required String title,
    required String playlist,
    required int length,
    required int imageId,
    required String path,
  })  : artist = Value(artist),
        title = Value(title),
        playlist = Value(playlist),
        length = Value(length),
        imageId = Value(imageId),
        path = Value(path);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? artist,
    Expression<String>? title,
    Expression<String>? playlist,
    Expression<int>? length,
    Expression<int>? imageId,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (artist != null) 'artist': artist,
      if (title != null) 'title': title,
      if (playlist != null) 'playlist': playlist,
      if (length != null) 'length': length,
      if (imageId != null) 'image_id': imageId,
      if (path != null) 'path': path,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? artist,
      Value<String>? title,
      Value<String>? playlist,
      Value<int>? length,
      Value<int>? imageId,
      Value<String>? path}) {
    return SongsCompanion(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      title: title ?? this.title,
      playlist: playlist ?? this.playlist,
      length: length ?? this.length,
      imageId: imageId ?? this.imageId,
      path: path ?? this.path,
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
    if (playlist.present) {
      map['playlist'] = Variable<String>(playlist.value);
    }
    if (length.present) {
      map['length'] = Variable<int>(length.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('artist: $artist, ')
          ..write('title: $title, ')
          ..write('playlist: $playlist, ')
          ..write('length: $length, ')
          ..write('imageId: $imageId, ')
          ..write('path: $path')
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
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, image];
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
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
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
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
    );
  }

  @override
  $CoversTable createAlias(String alias) {
    return $CoversTable(attachedDatabase, alias);
  }
}

class Cover extends DataClass implements Insertable<Cover> {
  final int id;
  final String image;
  const Cover({required this.id, required this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image'] = Variable<String>(image);
    return map;
  }

  CoversCompanion toCompanion(bool nullToAbsent) {
    return CoversCompanion(
      id: Value(id),
      image: Value(image),
    );
  }

  factory Cover.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cover(
      id: serializer.fromJson<int>(json['id']),
      image: serializer.fromJson<String>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'image': serializer.toJson<String>(image),
    };
  }

  Cover copyWith({int? id, String? image}) => Cover(
        id: id ?? this.id,
        image: image ?? this.image,
      );
  Cover copyWithCompanion(CoversCompanion data) {
    return Cover(
      id: data.id.present ? data.id.value : this.id,
      image: data.image.present ? data.image.value : this.image,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cover(')
          ..write('id: $id, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cover && other.id == this.id && other.image == this.image);
}

class CoversCompanion extends UpdateCompanion<Cover> {
  final Value<int> id;
  final Value<String> image;
  const CoversCompanion({
    this.id = const Value.absent(),
    this.image = const Value.absent(),
  });
  CoversCompanion.insert({
    this.id = const Value.absent(),
    required String image,
  }) : image = Value(image);
  static Insertable<Cover> custom({
    Expression<int>? id,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (image != null) 'image': image,
    });
  }

  CoversCompanion copyWith({Value<int>? id, Value<String>? image}) {
    return CoversCompanion(
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoversCompanion(')
          ..write('id: $id, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [title, author, imageId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final String title;
  final String author;
  final int imageId;
  const Playlist(
      {required this.title, required this.author, required this.imageId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['image_id'] = Variable<int>(imageId);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      title: Value(title),
      author: Value(author),
      imageId: Value(imageId),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      imageId: serializer.fromJson<int>(json['imageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'imageId': serializer.toJson<int>(imageId),
    };
  }

  Playlist copyWith({String? title, String? author, int? imageId}) => Playlist(
        title: title ?? this.title,
        author: author ?? this.author,
        imageId: imageId ?? this.imageId,
      );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('imageId: $imageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, author, imageId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.title == this.title &&
          other.author == this.author &&
          other.imageId == this.imageId);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<String> title;
  final Value<String> author;
  final Value<int> imageId;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.imageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String title,
    required String author,
    required int imageId,
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        author = Value(author),
        imageId = Value(imageId);
  static Insertable<Playlist> custom({
    Expression<String>? title,
    Expression<String>? author,
    Expression<int>? imageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (imageId != null) 'image_id': imageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith(
      {Value<String>? title,
      Value<String>? author,
      Value<int>? imageId,
      Value<int>? rowid}) {
    return PlaylistsCompanion(
      title: title ?? this.title,
      author: author ?? this.author,
      imageId: imageId ?? this.imageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('imageId: $imageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $CoversTable covers = $CoversTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [songs, covers, playlists];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required String artist,
  required String title,
  required String playlist,
  required int length,
  required int imageId,
  required String path,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<String> artist,
  Value<String> title,
  Value<String> playlist,
  Value<int> length,
  Value<int> imageId,
  Value<String> path,
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

  ColumnFilters<String> get playlist => $composableBuilder(
      column: $table.playlist, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get playlist => $composableBuilder(
      column: $table.playlist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get playlist =>
      $composableBuilder(column: $table.playlist, builder: (column) => column);

  GeneratedColumn<int> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
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
            Value<String> playlist = const Value.absent(),
            Value<int> length = const Value.absent(),
            Value<int> imageId = const Value.absent(),
            Value<String> path = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            artist: artist,
            title: title,
            playlist: playlist,
            length: length,
            imageId: imageId,
            path: path,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String artist,
            required String title,
            required String playlist,
            required int length,
            required int imageId,
            required String path,
          }) =>
              SongsCompanion.insert(
            id: id,
            artist: artist,
            title: title,
            playlist: playlist,
            length: length,
            imageId: imageId,
            path: path,
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
  required String image,
});
typedef $$CoversTableUpdateCompanionBuilder = CoversCompanion Function({
  Value<int> id,
  Value<String> image,
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

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);
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
            Value<String> image = const Value.absent(),
          }) =>
              CoversCompanion(
            id: id,
            image: image,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String image,
          }) =>
              CoversCompanion.insert(
            id: id,
            image: image,
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
typedef $$PlaylistsTableCreateCompanionBuilder = PlaylistsCompanion Function({
  required String title,
  required String author,
  required int imageId,
  Value<int> rowid,
});
typedef $$PlaylistsTableUpdateCompanionBuilder = PlaylistsCompanion Function({
  Value<String> title,
  Value<String> author,
  Value<int> imageId,
  Value<int> rowid,
});

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);
}

class $$PlaylistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist>),
    Playlist,
    PrefetchHooks Function()> {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> title = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<int> imageId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion(
            title: title,
            author: author,
            imageId: imageId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String title,
            required String author,
            required int imageId,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion.insert(
            title: title,
            author: author,
            imageId: imageId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaylistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist>),
    Playlist,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$CoversTableTableManager get covers =>
      $$CoversTableTableManager(_db, _db.covers);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
}
