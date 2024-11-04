import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'playlist_page_state.dart';

class PlaylistPageCubit extends HydratedCubit<PlaylistPageState> {
  PlaylistPageCubit() : super(const PlaylistPageState(islistview: true));

  void changeView() => emit(PlaylistPageState(islistview: !state.islistview));

  @override
  PlaylistPageState? fromJson(Map<String, dynamic> json) {
    return PlaylistPageState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PlaylistPageState state) {
    return state.toMap();
  }
}
