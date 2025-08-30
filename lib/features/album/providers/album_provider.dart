import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/json/models/models.dart';
import 'package:lemon/core/data/load_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon/main.dart';

class LatestPlayed {
  final Album album;
  final int songId;

  const LatestPlayed(this.album, this.songId);

  Map<String, dynamic> toMap() => {
        'album': {
          'id': album.id,
          'title': album.title,
          'author': album.author,
          'imageId': album.imageId,
          'sourcePath': album.sourcePath,
          'lastPlayedTime': album.lastPlayedTime,
          'lastPlayedIndex': album.lastPlayedIndex,
          'totalTracks': album.totalTracks,
          'playedTracks': album.playedTracks,
        },
        'songId': songId,
      };

  factory LatestPlayed.fromMap(Map<String, dynamic> map) => LatestPlayed(
        Album(
          id: map['album']['id'] as int,
          title: map['album']['title'] as String,
          author: map['album']['author'] as String,
          imageId: map['album']['imageId'] as int,
          sourcePath: map['album']['sourcePath'] as String,
          lastPlayedTime: map['album']['lastPlayedTime'] as int,
          lastPlayedIndex: map['album']['lastPlayedIndex'] as int,
          totalTracks: map['album']['totalTracks'] as int,
          playedTracks: map['album']['playedTracks'] as int,
        ),
        map['songId'] as int,
      );
}

class AlbumState {
  final bool isLoading;
  final bool isGridView;
  final List<Album> albums;
  final Map<dynamic, dynamic> info;
  final LatestPlayed? latestPlayed;

  const AlbumState({
    required this.isLoading,
    required this.isGridView,
    required this.albums,
    required this.info,
    this.latestPlayed,
  });

  const AlbumState.initial()
      : isLoading = true,
        isGridView = true,
        albums = const [],
        info = const {},
        latestPlayed = null;

  AlbumState copyWith({
    bool? isLoading,
    bool? isGridView,
    List<Album>? albums,
    Map<dynamic, dynamic>? info,
    LatestPlayed? latestPlayed,
  }) =>
      AlbumState(
        isLoading: isLoading ?? this.isLoading,
        isGridView: isGridView ?? this.isGridView,
        albums: albums ?? this.albums,
        info: info ?? this.info,
        latestPlayed: latestPlayed ?? this.latestPlayed,
      );
}

class AlbumNotifier extends StateNotifier<AlbumState> {
  static const _kIsGridView = 'album.isGridView';
  final Ref ref;

  AlbumNotifier(this.ref) : super(const AlbumState.initial()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _restoreIsGridView();
    await load();
  }

  void toggleView() {
    final next = !state.isGridView;
    state = state.copyWith(isGridView: next);
    _persistIsGridView(next);
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final albums =
        await ref.read(albumRepositoryProvider).getAlbumsByLastPlayedTime();
    state = state.copyWith(isLoading: false, albums: albums, info: {});
  }

  Future<void> loaddb(String audioPath) async {
    state = state.copyWith(isLoading: true);
    Stream<Map<String, int>> result = rebuildDb(audioPath, ref);
    await for (final loadinfo in result) {
      final albums =
          await ref.read(albumRepositoryProvider).getAlbumsByLastPlayedTime();
      state = state.copyWith(isLoading: false, albums: albums, info: loadinfo);
    }
  }

  void updateHistory(LatestPlayed history) {
    state = state.copyWith(latestPlayed: history);
    ref
        .read(albumRepositoryProvider)
        .updateLastPlayedTimeWithId(history.album.id);
  }

  Future<void> _restoreIsGridView() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(_kIsGridView);
    if (stored != null && stored != state.isGridView) {
      state = state.copyWith(isGridView: stored);
    }
  }

  Future<void> _persistIsGridView(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsGridView, value);
  }
}

final albumProvider = StateNotifierProvider<AlbumNotifier, AlbumState>(
    (ref) => AlbumNotifier(ref));
