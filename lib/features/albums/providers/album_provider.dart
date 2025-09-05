import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/audio/providers/audio/audio_player_provider.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/file_sys/providers/filesys_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon/main.dart';

class AlbumsState {
  final bool isLoading;
  final bool isGridView;
  final List<Album> albums;
  final String? lastPlayedAlbumId;
  final Map<String, dynamic>? info;

  const AlbumsState({
    required this.isLoading,
    required this.isGridView,
    required this.albums,
    this.lastPlayedAlbumId,
    this.info,
  });

  const AlbumsState.initial()
      : isLoading = true,
        isGridView = true,
        albums = const [],
        lastPlayedAlbumId = null,
        info = null;

  AlbumsState copyWith({
    bool? isLoading,
    bool? isGridView,
    List<Album>? albums,
    String? lastPlayedAlbumId,
    Map<String, dynamic>? info,
  }) =>
      AlbumsState(
        isLoading: isLoading ?? this.isLoading,
        isGridView: isGridView ?? this.isGridView,
        albums: albums ?? this.albums,
        lastPlayedAlbumId: lastPlayedAlbumId ?? this.lastPlayedAlbumId,
        info: info ?? this.info,
      );
}

class AlbumsNotifier extends StateNotifier<AlbumsState> {
  static const _kIsGridView = 'album.isGridView';
  final Ref ref;

  AlbumsNotifier(this.ref) : super(const AlbumsState.initial()) {
    _bootstrap();
  }

  // init
  Future<void> _bootstrap() async {
    await _restoreIsGridView();
    await load();
  }

  // ================== business logic ===================
  // view
  void toggleView() {
    final next = !state.isGridView;
    state = state.copyWith(isGridView: next);
    _persistIsGridView(next);
  }

  // data
  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final albums =
        await ref.read(albumRepositoryProvider).getAlbumsByLastPlayedTime();
    state = state.copyWith(isLoading: false, albums: albums);
  }

  Future<void> loaddb(String audioPath) async {
    state = state.copyWith(isLoading: true);
    await ref.read(mediaLibraryProvider.notifier).rebuild(audioPath);
    load();
  }

  // audio
  void updateHistory(String albumId) {
    state = state.copyWith(lastPlayedAlbumId: albumId);
  }

  void playAlbumById(String albumId, {String? songId}) {
    final album = state.albums.firstWhere((album) => album.id == albumId);
    songId ??= album.lastPlayedSong?.id;
    ref.read(audioPlayerProvider.notifier).locateAudio(
          album: album,
          songId: songId,
        );
  }

  // ================= persist =================
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

final albumsProvider = StateNotifierProvider<AlbumsNotifier, AlbumsState>(
    (ref) => AlbumsNotifier(ref));
