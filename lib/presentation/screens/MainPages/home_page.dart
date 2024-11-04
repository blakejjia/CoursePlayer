import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/presentation/widgets/future_builder.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MRefreshFutureBuilder(
      _refreshData,
      () => getIt<LoadFromDb>().getAllCovers(),
      child: (data) {
        return ListView(
          children: [
            ...data!.map((cover)=> Text('Cover id: ${cover.id}, hash: ${cover.hash}'))
          ],
        );
      },
    );
  }
}
