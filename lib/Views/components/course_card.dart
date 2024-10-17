import 'package:course_player/Shared/models.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Playlist playList;
  const CourseCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return mCard(context, playList);
  }

  Widget mCard(BuildContext context,Playlist playlist) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(      // image  
              height: 100,
              width: double.infinity,
              child: Image.network("https://itying.com/images/flutter/2.png", fit: BoxFit.cover,),
            ),
            Padding(   // course detail
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: _courseDetail(context, playlist),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseDetail(BuildContext context, Playlist playlist) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              playlist.title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            )),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //   child: Text(playlist, // TOODO: 显示 playlist.author
        //       overflow: TextOverflow.ellipsis,
        //       style: Theme.of(context).textTheme.bodyMedium,
        //       maxLines: 2,
        //       textAlign: TextAlign.center),
        // ),
      ],
    );
  }

}