// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Song extends Song {
  @override
  final int id;
  @override
  final String artist;
  @override
  final String title;
  @override
  final String playlist;
  @override
  final int length;
  @override
  final int imageId;
  @override
  final String path;

  factory _$Song([void Function(SongBuilder)? updates]) =>
      (new SongBuilder()..update(updates))._build();

  _$Song._(
      {required this.id,
      required this.artist,
      required this.title,
      required this.playlist,
      required this.length,
      required this.imageId,
      required this.path})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Song', 'id');
    BuiltValueNullFieldError.checkNotNull(artist, r'Song', 'artist');
    BuiltValueNullFieldError.checkNotNull(title, r'Song', 'title');
    BuiltValueNullFieldError.checkNotNull(playlist, r'Song', 'playlist');
    BuiltValueNullFieldError.checkNotNull(length, r'Song', 'length');
    BuiltValueNullFieldError.checkNotNull(imageId, r'Song', 'imageId');
    BuiltValueNullFieldError.checkNotNull(path, r'Song', 'path');
  }

  @override
  Song rebuild(void Function(SongBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SongBuilder toBuilder() => new SongBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Song &&
        id == other.id &&
        artist == other.artist &&
        title == other.title &&
        playlist == other.playlist &&
        length == other.length &&
        imageId == other.imageId &&
        path == other.path;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, artist.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, playlist.hashCode);
    _$hash = $jc(_$hash, length.hashCode);
    _$hash = $jc(_$hash, imageId.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Song')
          ..add('id', id)
          ..add('artist', artist)
          ..add('title', title)
          ..add('playlist', playlist)
          ..add('length', length)
          ..add('imageId', imageId)
          ..add('path', path))
        .toString();
  }
}

class SongBuilder implements Builder<Song, SongBuilder> {
  _$Song? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _artist;
  String? get artist => _$this._artist;
  set artist(String? artist) => _$this._artist = artist;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _playlist;
  String? get playlist => _$this._playlist;
  set playlist(String? playlist) => _$this._playlist = playlist;

  int? _length;
  int? get length => _$this._length;
  set length(int? length) => _$this._length = length;

  int? _imageId;
  int? get imageId => _$this._imageId;
  set imageId(int? imageId) => _$this._imageId = imageId;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  SongBuilder();

  SongBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _artist = $v.artist;
      _title = $v.title;
      _playlist = $v.playlist;
      _length = $v.length;
      _imageId = $v.imageId;
      _path = $v.path;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Song other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Song;
  }

  @override
  void update(void Function(SongBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Song build() => _build();

  _$Song _build() {
    final _$result = _$v ??
        new _$Song._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Song', 'id'),
            artist: BuiltValueNullFieldError.checkNotNull(
                artist, r'Song', 'artist'),
            title:
                BuiltValueNullFieldError.checkNotNull(title, r'Song', 'title'),
            playlist: BuiltValueNullFieldError.checkNotNull(
                playlist, r'Song', 'playlist'),
            length: BuiltValueNullFieldError.checkNotNull(
                length, r'Song', 'length'),
            imageId: BuiltValueNullFieldError.checkNotNull(
                imageId, r'Song', 'imageId'),
            path: BuiltValueNullFieldError.checkNotNull(path, r'Song', 'path'));
    replace(_$result);
    return _$result;
  }
}

class _$Cover extends Cover {
  @override
  final int id;
  @override
  final Uint8List cover;
  @override
  final String hash;

  factory _$Cover([void Function(CoverBuilder)? updates]) =>
      (new CoverBuilder()..update(updates))._build();

  _$Cover._({required this.id, required this.cover, required this.hash})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Cover', 'id');
    BuiltValueNullFieldError.checkNotNull(cover, r'Cover', 'cover');
    BuiltValueNullFieldError.checkNotNull(hash, r'Cover', 'hash');
  }

  @override
  Cover rebuild(void Function(CoverBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CoverBuilder toBuilder() => new CoverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cover &&
        id == other.id &&
        cover == other.cover &&
        hash == other.hash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cover.hashCode);
    _$hash = $jc(_$hash, hash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Cover')
          ..add('id', id)
          ..add('cover', cover)
          ..add('hash', hash))
        .toString();
  }
}

class CoverBuilder implements Builder<Cover, CoverBuilder> {
  _$Cover? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  Uint8List? _cover;
  Uint8List? get cover => _$this._cover;
  set cover(Uint8List? cover) => _$this._cover = cover;

  String? _hash;
  String? get hash => _$this._hash;
  set hash(String? hash) => _$this._hash = hash;

  CoverBuilder();

  CoverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cover = $v.cover;
      _hash = $v.hash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Cover other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Cover;
  }

  @override
  void update(void Function(CoverBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Cover build() => _build();

  _$Cover _build() {
    final _$result = _$v ??
        new _$Cover._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Cover', 'id'),
            cover:
                BuiltValueNullFieldError.checkNotNull(cover, r'Cover', 'cover'),
            hash:
                BuiltValueNullFieldError.checkNotNull(hash, r'Cover', 'hash'));
    replace(_$result);
    return _$result;
  }
}

class _$Playlist extends Playlist {
  @override
  final int id;
  @override
  final String title;
  @override
  final String author;
  @override
  final int imageId;

  factory _$Playlist([void Function(PlaylistBuilder)? updates]) =>
      (new PlaylistBuilder()..update(updates))._build();

  _$Playlist._(
      {required this.id,
      required this.title,
      required this.author,
      required this.imageId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Playlist', 'id');
    BuiltValueNullFieldError.checkNotNull(title, r'Playlist', 'title');
    BuiltValueNullFieldError.checkNotNull(author, r'Playlist', 'author');
    BuiltValueNullFieldError.checkNotNull(imageId, r'Playlist', 'imageId');
  }

  @override
  Playlist rebuild(void Function(PlaylistBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaylistBuilder toBuilder() => new PlaylistBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Playlist &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        imageId == other.imageId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, imageId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Playlist')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('imageId', imageId))
        .toString();
  }
}

class PlaylistBuilder implements Builder<Playlist, PlaylistBuilder> {
  _$Playlist? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  int? _imageId;
  int? get imageId => _$this._imageId;
  set imageId(int? imageId) => _$this._imageId = imageId;

  PlaylistBuilder();

  PlaylistBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _author = $v.author;
      _imageId = $v.imageId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Playlist other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Playlist;
  }

  @override
  void update(void Function(PlaylistBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Playlist build() => _build();

  _$Playlist _build() {
    final _$result = _$v ??
        new _$Playlist._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Playlist', 'id'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'Playlist', 'title'),
            author: BuiltValueNullFieldError.checkNotNull(
                author, r'Playlist', 'author'),
            imageId: BuiltValueNullFieldError.checkNotNull(
                imageId, r'Playlist', 'imageId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song();
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.playlist)
      ..writeByte(3)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.imageId)
      ..writeByte(6)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CoverAdapter extends TypeAdapter<Cover> {
  @override
  final int typeId = 1;

  @override
  Cover read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cover();
  }

  @override
  void write(BinaryWriter writer, Cover obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cover)
      ..writeByte(2)
      ..write(obj.hash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 2;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist();
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.imageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
