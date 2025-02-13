import '../../common/data/models/models.dart';

String formatAlbumProgress(Album album){
  int progress = (album.playedTracks*100/album.totalTracks).round();
  return "$progress%";
}