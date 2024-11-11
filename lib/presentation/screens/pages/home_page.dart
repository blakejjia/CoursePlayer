import 'package:course_player/logic/blocs/album_page/album_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPageBloc, AlbumPageState>(
        builder: (context, state) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      );
    });
  }
}
