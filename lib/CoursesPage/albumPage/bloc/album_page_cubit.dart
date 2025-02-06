import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/common/data/models/models.dart';

import '../../../common/data/providers/load_from_db.dart';
import '../../../main.dart';

part 'album_page_state.dart';


class AlbumPageCubit extends HydratedCubit<AlbumPageState> {
  AlbumPageCubit()
      : super(const AlbumPageState(isGridView: false, albums:[]));

  void playListPageChangeView() =>
      emit(state.copyWith(isGridView: !state.isGridView));

  /// Initialize the data for all albums, from database
  Future<int> init() async {
    final albums = await getIt<LoadFromDb>().getAllPlaylists();
    emit(state.copyWith(albums: albums));
    return 0;
  }

  void playListCubitUpdateSongProgress(
      int playlistId, int index, int position) {
    if (playlistId == 0) return;
    // final newPlayHistory = Map<int, List<int>>.from(state.progress);
    // newPlayHistory[playlistId] = [index, position];
    // emit(state.copyWith(
    //     progress: newPlayHistory,
    //     latestPlayed: [playlistId, index, position]));
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
