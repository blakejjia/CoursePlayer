import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/backEnd/data/models/models.dart';
import 'package:lemon/backEnd/data/repositories/album_repository.dart';

import '../../../../../main.dart';

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
      AlbumPageInitial(isGridView: state.isGridView),
    );
    final albums = await getIt<AlbumRepository>().getAlbumsByLastPlayedTime();
    emit(
      AlbumPageIdeal(
        isGridView: state.isGridView,
        albums: albums,
        latestPlayed: state is AlbumPageIdeal
            ? (state as AlbumPageIdeal).latestPlayed
            : null,
      ),
    );
  }

  // Update the last played time of the album
  // And, update the last played index of the album
  void updateHistory(LatestPlayed history) {
    emit(
      AlbumPageIdeal(
        isGridView: state.isGridView,
        albums: (state as AlbumPageIdeal).albums,
        latestPlayed: history,
      ),
    );
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
