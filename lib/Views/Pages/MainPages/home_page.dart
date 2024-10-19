import 'package:course_player/Shared/Providers/load_from_db.dart';
import 'package:course_player/Views/components/RefreshFutureBuilder.dart';
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
    return RefreshFutureBuilder(
      _refreshData,
      () => getIt<loadFromDb>().getAllPlaylists(),
      child: (data) {
        return ListView(
          children: [
            Text('Data: ' + data.toString()),
          ],
        );
      },
    );
  }
}
