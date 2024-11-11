import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'playlist_page_state.dart';

class PlaylistPageCubit extends HydratedCubit<PlaylistPageState> {
  PlaylistPageCubit()
      : super(const PlaylistPageState(isGridView: true, playHistory: {}));

  void playListPageChangeView() =>
      emit(state.copyWith(isGridView: !state.isGridView));

  void playListCubitUpdateSongProgress(
      int playlistId, int index, int position) {
    final newPlayHistory = Map<int, List<int>>.from(state.playHistory);
    newPlayHistory[playlistId] = [index, position];
    emit(state.copyWith(playHistory: newPlayHistory));
  }

  @override
  PlaylistPageState? fromJson(Map<String, dynamic> json) {
    return PlaylistPageState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PlaylistPageState state) {
    return state.toMap();
  }
}
