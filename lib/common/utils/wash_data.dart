// TODO 1: algorithms here weather applied depends on settings bloc

/// [washArtist] was applied when loading data from file
/// this function is used to clean up the artist name
String washArtist(String? artist) {
  if (artist == null) {
    return 'Unknown Artist';
  } else if (artist.length > 20) {
    return '${artist.substring(0, 20)}...';
  }
  return artist;
}

/// [washPlaylistArtist] was applied when loading data from file
/// this function is used to format the author of the playlist
String washPlaylistArtist(Set<String> artists) {
  if(artists.isEmpty) {
    return 'Unknown Artist';
  } else if (artists.length < 3) {
    return artists.map((artist) => washArtist(artist)).toSet().join(' ');
  } else {
    return "群星";
  }
}