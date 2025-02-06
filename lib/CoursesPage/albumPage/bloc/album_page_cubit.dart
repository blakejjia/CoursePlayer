import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'album_page_state.dart';


class AlbumPageCubit extends HydratedCubit<AlbumPageState> {
  AlbumPageCubit()
      : super(const AlbumPageState(isGridView: false, progress: {}));

  void playListPageChangeView() =>
      emit(state.copyWith(isGridView: !state.isGridView));

  void playListCubitUpdateSongProgress(
      int playlistId, int index, int position) {
    if (playlistId == 0) return;
    final newPlayHistory = Map<int, List<int>>.from(state.progress);
    newPlayHistory[playlistId] = [index, position];
    emit(state.copyWith(
        progress: newPlayHistory,
        latestPlayed: [playlistId, index, position]));
  }

  @override
  AlbumPageState? fromJson(Map<String, dynamic> json) {
    return AlbumPageState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AlbumPageState state) {
    return state.toMap();
  }
}
