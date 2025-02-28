import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/album_repository.dart';

import '../../../main.dart';

part 'album_page_state.dart';

class AlbumPageCubit extends HydratedCubit<AlbumPageState> {
  AlbumPageCubit() : super(const AlbumPageState(isGridView: false, albums: []));

  void playListPageChangeView() =>
      emit(state.copyWith(isGridView: !state.isGridView));

  /// Initialize the data for all albums, from database
  /// called when album page init state.
  Future<void> load() async {
    final albums = await getIt<AlbumRepository>().getAlbumsByLastPlayedTime();
    emit(state.copyWith(albums: albums));
  }

  // Update the last played time of the album
  // And, update the last played index of the album
  void updateHistory(LatestPlayed history){
    emit(state.copyWith(latestPlayed: history));
    getIt<AlbumRepository>().updateLastPlayedTimeWithId(history.album.id);
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
