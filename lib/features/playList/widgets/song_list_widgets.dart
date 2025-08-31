import 'package:flutter/material.dart';

import '../../../core/data/models/models.dart';
import '../utils/texts.dart';
import 'song_progress_widgets.dart';

Widget songTileNormal(BuildContext context, Song song) {
  return ListTile(
      leading:
          Text("${song.track}", style: Theme.of(context).textTheme.titleMedium),
      title: Text(formatTitle(song)),
      subtitle: Text(formatSubtitle(song)));
}

/// when selected, song tile look like this
Widget selectIndicator(BuildContext context, Song song) {
  return Container(
    color: Theme.of(context).colorScheme.primaryFixed.withAlpha(100),
    child: songTileNormal(context, song),
  );
}
