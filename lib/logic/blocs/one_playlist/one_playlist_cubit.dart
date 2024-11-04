import 'package:bloc/bloc.dart';

part 'one_playlist_state.dart';

class OnePlaylistCubit extends Cubit<OnePlaylistState> {
  OnePlaylistCubit() : super(const OnePlaylistState(sortBy: 0));



}
