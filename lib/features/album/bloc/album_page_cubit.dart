import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:lemon/core/backEnd/data/repositories/album_repository.dart';
import 'package:lemon/core/backEnd/load_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/main.dart';

part 'album_page_state.dart';

class AlbumPageCubit extends HydratedCubit<AlbumPageState> {
  AlbumPageCubit() : super(const AlbumPageInitial(isGridView: true)) {
    // Load the initial data when the cubit is created
    load();
  }

  void playListPageChangeView() =>
      emit(state.copyWith(isGridView: !state.isGridView));

  /// Initialize the data for all albums, from database
  /// called when album page init state.
  Future<void> load() async {
    emit(
      AlbumPageInitial(
          isGridView: state.isGridView, latestPlayed: state.latestPlayed),
    );
    final albums = await getIt<AlbumRepository>().getAlbumsByLastPlayedTime();
    emit(
      AlbumPageIdeal(
          isGridView: state.isGridView,
          albums: albums,
          latestPlayed: state.latestPlayed,
          info: {}),
    );
  }

  /// Initialize the data for all albums, from database
  /// called when album page init state.
  Future<void> loaddb() async {
    emit(
      AlbumPageLoading(
          isGridView: state.isGridView, latestPlayed: state.latestPlayed),
    );
    final container = getIt<ProviderContainer>();
    Stream<Map<String, int>> result =
        rebuildDb(container.read(settingsProvider).audioPath);
    await for (final loadinfo in result) {
      final albums = await getIt<AlbumRepository>().getAlbumsByLastPlayedTime();
      emit(
        AlbumPageIdeal(
          isGridView: state.isGridView,
          albums: albums,
          latestPlayed: state.latestPlayed,
          info: loadinfo,
        ),
      );
    }
  }

  // Update the last played time of the album
  // And, update the last played index of the album
  void updateHistory(LatestPlayed history) {
    emit(state.copyWith(latestPlayed: history));
    getIt<AlbumRepository>().updateLastPlayedTimeWithId(history.album.id);
  }

  @override
  AlbumPageState? fromJson(Map<String, dynamic> json) {
    try {
      return AlbumPageState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AlbumPageState state) {
    return state.toMap();
  }
}
